 #!/bin/bash

 radarr_tag=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" | awk '/tag_name/{print $4;exit}' FS='[""]')
 curl -o /tmp/radar.tar.gz -L	"https://github.com/Radarr/Radarr/releases/download/${radarr_tag}/Radarr.develop.${radarr_tag#v}.linux.tar.gz"
 tar ixzf /tmp/radar.tar.gz -C /opt/radarr --strip-components=1
 chown -R radarr:radarr /opt/radarr
