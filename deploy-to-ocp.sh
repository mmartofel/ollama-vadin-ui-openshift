#
# Marek Martofel, Red Hat
#
# Deploy project, server and client services with kustomization
#

echo
echo 'Creating ai-ollama-chat-application project ...'
echo 

oc apply -k ./deployment/project
oc adm policy add-scc-to-user anyuid -z default -n ai-ollama-chat-application
sleep 5                          # wait 5s for prooject to create

echo
echo 'Creating ollama server pod ...'
echo 

oc apply -k ./deployment/server -n ai-ollama-chat-application

echo
echo 'Creating ollama UI pod ...'
echo 

oc apply -k ./deployment/client -n ai-ollama-chat-application

echo 
sleep 5 # wait 5s for pods to come up

SERVER_POD_NAME=$(oc get pod -o name | sed -n 1p)

while :; do
  SERVER_READY_STATUS=$(oc get $SERVER_POD_NAME -o jsonpath='{.status.containerStatuses[0].ready}')
  if [ "$SERVER_READY_STATUS"="true" ]; then
    echo "Ollama server pod is now ready: $SERVER_POD_NAME"
    echo "Installing mistral model ..."
    oc exec $SERVER_POD_NAME -- ollama pull mistral
    oc exec $SERVER_POD_NAME -- ollama list
    break
  else
    echo "Pod is not yet ready: $SERVER_POD_NAME, current readiness state: $SERVER_READY_STATUS"
    sleep 2 # wait for 2 seconds before checking again
  fi
done

echo 

UI_POD_NAME=$(oc get pod -o name | sed -n 2p)

while :; do
  UI_READY_STATUS=$(oc get $UI_POD_NAME -o jsonpath='{.status.containerStatuses[0].ready}')
  if [ "$UI_READY_STATUS"="true" ]; then
    echo "UI pod is now ready: $UI_POD_NAME"
    break
  else
    echo "UI pod is not yet ready: $UI_POD_NAME, current readiness state: $UI_READY_STATUS"
    sleep 2 # wait for 2 seconds before checking again
  fi
done

UI_ROUTE=$(oc get route ollama-client-route -o jsonpath='{.spec.host}' -n ai-ollama-chat-application)

echo
echo 'Your application UI is now available at the url : '
echo
echo 'https://'$UI_ROUTE
echo
echo 'Note: if any errors above it is safe to run that script again. Hope it would go better.'
