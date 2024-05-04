mvn package -Pproduction
podman build -t quay.io/mmartofe/ollama-vaadin-gui .
podman push quay.io/mmartofe/ollama-vaadin-gui

