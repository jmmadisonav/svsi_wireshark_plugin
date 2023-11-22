local my_info = {
  version = "0.0.1",
  author = "Jim Maciejewski",
  repository = "https://github.com/jmmadisonav/svsi_wireshark_plugin.git"
}

set_plugin_info(my_info)

svsi_protocol = Proto("SVSI", "SVSI")

local audio_rates = {
  [0] = "44100 khz",
  [1] = "32000 khz",
  [2] = "48000 khz"
}

local audio_channels = {
  [0x3c] = "1 and 2",
  [0x3d] = "3 and 4",
  [0x3e] = "5 and 6",
  [0x3f] = "7 and 8"
}

local speaker_placements = {
  [0] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-None 8-None"
    },
  [1] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-None 8-None"
  },
  [2] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-None 8-None"
  },
  [3] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-None 8-None"
  },
  [4] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-None 8-None"
  },
  [5] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-None 8-None"
  },
  [6] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-None 8-None"
  },
  [7] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-None 8-None"
  },
  [8] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-None 8-None"
  },
  [9] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-None 8-None"
  },
  [10] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-None 8-None"
  },
  [11] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-None 8-None"
  },
  [12] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre 8-None"
  },
  [13] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre 8-None"
  },
  [14] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre 8-None"
  },
  [15] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre 8-None"
  },
  [16] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre Left 8-Rear Centre Right"
  },
  [17] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre Left 8-Rear Centre Right"
  },
  [18] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre Left 8-Rear Centre Right"
  },
  [19] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Rear Centre Left 8-Rear Centre Right"
  },
  [20] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [21] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [22] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [23] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-None 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [24] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [25] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [26] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [27] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-Rear Centre 6-None",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [28] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [29] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-None",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [30] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-None 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  },
  [31] = {
    [0x3c] = "1-Front Left 2-Front Right",
    [0x3d] = "3-Low Frequency Effect 4-Front Centre",
    [0x3e] = "5-Rear Left 6-Rear Right",
    [0x3f] = "7-Front Centre Left 8-Front Centre Right"
  }
}
  
control_packet = ProtoField.string("svsi.control", "Control")
video_packet = ProtoField.string("svsi.video", "Video")
audio_packet = ProtoField.string("svsi.audio", "Audio")
header_name = ProtoField.string("svsi.header", "Header")
stream_number = ProtoField.string("svsi.stream_number", "Stream Number")
stream = ProtoField.uint8("svsi.stream", "Stream", base.HEX)
group = ProtoField.uint8("svsi.group", "Group", base.HEX)

packet_count = ProtoField.uint8("svsi.packet_count", "Packet Count", base.DEC )
audio_rate = ProtoField.uint8("svsi.audio_rate", "Audio Rate", base.HEX, audio_rates)
audio_channel = ProtoField.uint8("svsi.audio_channel", "Audio Channels", base.HEX, audio_channels)
channel_count = ProtoField.string("svsi.channel_count", "Channel Count")
speaker_placement = ProtoField.string("svsi.speaker_placement", "Speaker Placement")

svsi_protocol.fields = { control_packet, video_packet, audio_packet, packet_type, header_name, stream_number, stream, group, packet_count, audio_rate, audio_channel, channel_count, speaker_placement }

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
  if pinfo.src_port == 50001 then
    subtree:set_text("SVSI (Control)")
    subtree:add(control_packet, buffer()):set_text("Discovery Response")
    pinfo.cols.info = "Discovery Response"
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
  local stream_subtree = subtree:add(stream_number, stream_number_string):set_text("Stream Number: " .. stream_number_string)
  stream_subtree:add(group, buffer(10, 1))
  stream_subtree:add(stream, buffer(6, 1))
  
  local packet_count_string = tonumber(tostring(buffer(9, 1)), 16)


  -- Audio Only
  if pinfo.dst_port == 50003 then
    subtree:set_text("SVSI (Audio)")
    pinfo.cols.info = "Audio stream: " .. stream_number_string  .. " / Packet count: " .. packet_count_string
    local audio_subtree = subtree:add(audio_packet, buffer(0,2)):set_text("Audio")

    -- Packet Count
    audio_subtree:add(packet_count, buffer(9, 1))

    -- Audio sample rate
    audio_subtree:add(audio_rate, buffer(0, 1))

    -- Audio channels
    audio_subtree:add(audio_channel, buffer(1, 1))
    
    --Speaker Placement
    local speaker_subtree = audio_subtree:add(speaker_placement, buffer(8,1)):set_text("Speaker Mapping: " .. "(0x" .. buffer(8,1) .. ")")
    local placement = buffer(8, 1):bitfield(3, 5)
    local channels = tonumber(buffer:bytes(1,1):tohex(),16)
    local channel_count_string = buffer(8, 1):bitfield(0, 3)
    speaker_subtree:add(channel_count, buffer(8,1)):set_text(buffer(8, 1):bitfield(0, 1) .. buffer(8, 1):bitfield(1, 1) .. buffer(8, 1):bitfield(2, 1) .. ". .... = Channel Count: " .. buffer(8, 1):bitfield(0, 3) + 1)
    speaker_subtree:add(speaker_placement, buffer(8,1)):set_text("..." .. buffer(8, 1):bitfield(3, 1) .. " " .. buffer(8, 1):bitfield(4, 1) .. buffer(8, 1):bitfield(5, 1) .. buffer(8, 1):bitfield(6, 1) .. buffer(8, 1):bitfield(7, 1) .. " = Mapping: " .. speaker_placements[placement][channels])
  end

  -- Video Only
  if pinfo.dst_port == 50002 then 
    subtree:set_text("SVSI (Video)")
    pinfo.cols.info = "Video stream: " .. stream_number_string  .. " / Packet count: " .. packet_count_string
    local video_subtree = subtree:add(video_packet, buffer(0,0)):set_text("Video")
    
    -- Packet Count
    video_subtree:add(packet_count, buffer(9, 1))
  end

end

local udp_port = DissectorTable.get("udp.port")
udp_port:add(50001, svsi_protocol)
udp_port:add(50002, svsi_protocol)
udp_port:add(50003, svsi_protocol)

