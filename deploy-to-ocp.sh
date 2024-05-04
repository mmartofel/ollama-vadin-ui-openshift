#
# Marek Martofel, Red Hat
#
# Deploy project, server and client services with kustomization
#

oc apply -k ./deployment/project
oc adm policy add-scc-to-user anyuid -z default -n ai-ollama-chat-application
oc apply -k ./deployment/server -n ai-ollama-chat-application
oc apply -k ./deployment/client -n ai-ollama-chat-application
