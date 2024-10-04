#!/usr/bin/env bash

UNITY_LICENSING_SERVER=$1

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
  # This will return the floating license that is currently in use. 
  # This depends on a licensing server URL and a license file being present
  #
  # https://github.com/game-ci/unity-builder/blob/main/dist/platforms/ubuntu/steps/activate.sh#L70-L71
  PARSEDFILE=$(grep -oP '\".*?\"' < license.txt | tr -d '"')
  FLOATING_LICENSE_ID=$(sed -n 2p <<< "$PARSEDFILE")

  mkdir -p /usr/share/unity3d/config
  sed "s|%URL%|$UNITY_LICENSING_SERVER|g" /services-config.json.template > /usr/share/unity3d/config/services-config.json

  # https://github.com/game-ci/unity-builder/blob/main/dist/platforms/ubuntu/steps/return_license.sh#L8
  echo "Returning floating license: \"$FLOATING_LICENSE_ID\""
  /opt/unity/Editor/Data/Resources/Licensing/Client/Unity.Licensing.Client --return-floating "$FLOATING_LICENSE_ID"
else
  echo "No license was returned."
fi
