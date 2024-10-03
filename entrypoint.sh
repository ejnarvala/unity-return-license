#!/usr/bin/env bash

echo "Entrypoint script started."
echo "Current directory:"
pwd
echo "Files: $(ls)"
echo "Environment Variables:"
printenv

UNITY_LICENSING_SERVER=$1

echo "Unity Licensing Server: $UNITY_LICENSING_SERVER"
if [[ -n "$UNITY_SERIAL" ]]; then
  #
  # PROFESSIONAL (SERIAL) LICENSE MODE
  #
  # This will return the license that is currently in use.
  #
  unity-editor \
    -logFile /dev/stdout \
    -quit \
    -returnlicense
elif [[ -n "$UNITY_LICENSING_SERVER" && -f "license.txt" ]]; then
  #
  # FLOATING LICENSE FILE MODE
  #
  # This will return the license that is currently in use.
  #
  echo "Found license.txt file. Parsing file for floating license."
  PARSEDFILE=$(grep -oP '\".*?\"' < license.txt | tr -d '"')
  FLOATING_LICENSE_ID=$(sed -n 2p <<< "$PARSEDFILE")

  echo "Updating services-config.json to use $UNITY_LICENSING_SERVER"
  sed 's/%URL%/test/g' services-config.json.template > /usr/share/unity3d/config/services-config.json

  echo "Configuring services-config.json"
  echo "Returning floating license: \"$FLOATING_LICENSE_ID\""
  /opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --return-floating "$FLOATING_LICENSE_ID"
else
  echo "No license was returned."
fi
