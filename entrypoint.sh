#!/usr/bin/env bash

echo "Entrypoint script started."
echo "Current directory:"
pwd
echo "Files: $(ls)"
echo "Environment Variables:"
printenv

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
elif [[ -n "$FLOATING_LICENSE" ]]; then
  #
  # FLOATING LICENSE MODE
  #
  # This will return the license that is currently in use.
  #
  echo "Returning floating license: \"$FLOATING_LICENSE\""
  /opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --return-floating "$FLOATING_LICENSE"

elif [[ -f "license.txt" ]]; then
  echo "Found license.txt file. Parsing file for floating license."
  PARSEDFILE=$(grep -oP '\".*?\"' < license.txt | tr -d '"')
  FLOATING_LICENSE_ID=$(sed -n 2p <<< "$PARSEDFILE")

  #
  # FLOATING LICENSE FILE MODE
  #
  # This will return the license that is currently in use.
  #
  echo "Returning floating license: \"$FLOATING_LICENSE_ID\""
  /opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --return-floating "$FLOATING_LICENSE_ID"
else
  echo "No UNITY_SERIAL detected! No license was returned."
fi
