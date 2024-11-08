# very useful commmands for podman

podman logs elasticsearch
podman logs logstash
podman logs kibana

podman exec 'pod-name' /bin/bash

podman ps

podman exec -it elasticsearch /bin/bash

podman exec -it --user root kibana /bin/bash
podman exec -it --user root elasticsearch /bin/bash
podman exec -it --user root logstash /bin/bash



podman restart <container_name_or_id>

cat /etc/os-release


