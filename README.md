## Description
The SVSI Wireshark plugin is a dissector specifically tailored for AMX SVSI packets, offering detailed insights into their content.

## Setup & Process
1. Download the file [svsi_protocol.lua](svsi_protocol.lua).

2. Copy the downloaded `svsi_protocol.lua` file to your Wireshark LUA plugins folder.

3. Locate your Wireshark LUA plugins folder by navigating to Help -> About Wireshark. Then, select the "Folders" tab and look for either "Global Lua Plugins" or "Personal Lua Plugins."

4. Once the file is copied, load the plugin by selecting Analyze -> Reload Lua Plugins.

## Usage
### Filtering
The plugin provides the following filters for effective packet analysis:

#### Common Filters
- `svsi`: Display all SVSI packets.
- `svsi.video`: Display only SVSI video packets.
- `svsi.audio`: Display only SVSI audio packets.
- `svsi.stream_number`: Display packets by stream number; the stream number is a combination of the stream and group bytes.
- `svsi.control`: Display control packets.

#### Other Filters
- `svsi.audio_channel`
- `svsi.audio_rate`
- `svsi.channel_count`
- `svsi.stream`
- `svsi.group`
- `svsi.header`
- `svsi.packet_count`
- `svsi.speaker_placement`

### Definitions
- **SVSI Section:**
  - **Header:** SVSI Packet header will always be "SVSI"
  - **Stream Number:** The SVSI stream number, representing the value of the Stream and Group bytes.

- **Video Section:**
  - **Packet Count:** Video packet count value.

- **Audio Section:**
  - **Packet Count:** Audio packet count value.
  - **Audio Rate:** Audio Sample Rate.
  - **Audio Channel:** Audio Packet destination channels.
  - **Channel Count:** Total channels of audio being sent.
  - **Speaker Mapping:** Destination speakers for these two channels of audio.

