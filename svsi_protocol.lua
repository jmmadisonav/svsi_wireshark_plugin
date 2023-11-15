local my_info = {
  version = "0.0.1",
  author = "Jim Maciejewski",
  repository = "https://madisonav.com.au"
}

set_plugin_info(my_info)


svsi_protocol = Proto("SVSI", "SVSI")

local audio_rates = {
  [0] = "44100 khz",
  [1] = "32000 khz",
  [2] = "48000 khz"
}

local audio_channels = {
  [0x3c] = "Channels 1 and 2",
  [0x3d] = "Channels 3 and 4",
  [0x3e] = "Channels 5 and 6",
  [0x3f] = "Channels 7 and 8"
}

local audio_abbreviations = {

  ["FL"]  = "Front left",
  ["FC"]  = "Front centre",
  ["FR"]  = "Front right",
  ["FCL"] = "Front centre left",
  ["FCR"] = "Front centre right",
  ["RL"]  = "Rear left",
  ["RC"]  = "Rear centre",
  ["RR"]  = "Rear right",
  ["RCL"] = "Rear centre left",
  ["RCR"] = "Rear centre right",
  ["LFE"] = "Low frequency effect" 
}

control_packet = ProtoField.string("svsi.control", "Control")
video_packet = ProtoField.string("svsi.video", "Video")
audio_packet = ProtoField.string("svsi.audio", "Audio")
header_name = ProtoField.string("svsi.header", "Header")
stream_number = ProtoField.new("svsi.stream_number", "StreamNumber", base.DEC)
stream = ProtoField.uint8("svsi.stream", "Stream", base.HEX)
group = ProtoField.uint8("svsi.group", "Group", base.HEX)

packet_count = ProtoField.uint8("svsi.packet_count", "Packet Count", base.DEC )
audio_rate = ProtoField.uint8("svsi.audio_rate", "Audio Rate", base.HEX, audio_rates)
audio_channel = ProtoField.uint8("svsi.audio_channel", "Audio Channel", base.HEX, audio_channels)

svsi_protocol.fields = { control_packet, video_packet, audio_packet, packet_type, header_name, stream_number, stream, group, packet_count, audio_rate, audio_channel }


function svsi_protocol.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end
  local subtree = tree:add(svsi_protocol, buffer())
  pinfo.cols.protocol = "SVSI"

  -- Control
  if pinfo.dst_port == 50001 then
    subtree:set_text("SVSI (Control)")
    subtree:add(control_packet, buffer()):set_text("Discovery Packet: " .. "[0x" .. tostring(buffer(0,2)) .. "]")
    pinfo.cols.info = "Discovery [0x" .. tostring(buffer(0,2)) .. "]"
    return
  end


  -- Video and Audio
  local svsi_header = "53565349"
  if tostring(buffer(2, 4)) ~= svsi_header then return end

  -- Header
  subtree:add(header_name, buffer(2,4))

  -- Stream number
  local concatenated_range = buffer:bytes(10, 1) .. buffer:bytes(6, 1)
  local stream_number_string = tonumber(concatenated_range:tohex(),16)
  local stream_subtree = subtree:add(stream_number, buffer(6,5)):set_text("Stream Number: " .. stream_number_string)
  stream_subtree:add(group, buffer(10, 1))
  stream_subtree:add(stream, buffer(6, 1))
  
  local packet_count_string = tonumber(tostring(buffer(9, 1)), 16)


  -- Audio Only
  if pinfo.dst_port == 50003 then
    subtree:set_text("SVSI (Audio)")
    local audio_subtree = subtree:add(audio_packet, buffer(0,2)):set_text("Audio")

    -- Packet Count
    audio_subtree:add(packet_count, buffer(9, 1))

    -- Audio sample rate
    audio_subtree:add(audio_rate, buffer(0, 1))

    -- Audio channels
    audio_subtree:add(audio_channel, buffer(1, 1))
    pinfo.cols.info = "Audio stream: " .. stream_number_string  .. " / Packet number: " .. packet_count_string
  end

  -- Video Only
  if pinfo.dst_port == 50002 then 
    -- pinfo.cols.protocol = "SVSi-Video"
    subtree:set_text("SVSI (Video)")
    local video_subtree = subtree:add(video_packet, buffer(0,0)):set_text("Video")
    
    -- Packet Count
    video_subtree:add(packet_count, buffer(9, 1))
    pinfo.cols.info = "Video stream: " .. stream_number_string  .. " / Packet number: " .. packet_count_string
  end

 

end

local udp_port = DissectorTable.get("udp.port")
udp_port:add(50001, svsi_protocol)
udp_port:add(50002, svsi_protocol)
udp_port:add(50003, svsi_protocol)

