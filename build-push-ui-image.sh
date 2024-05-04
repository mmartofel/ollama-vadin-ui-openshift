#
# Marek Martofel, Red Hat
#
# Maven package, create image locally with podman and push to public Quay regirtry
#

mvn package -Pproduction
podman build -t quay.io/mmartofe/ollama-vaadin-gui .
podman push quay.io/mmartofe/ollama-vaadin-gui

