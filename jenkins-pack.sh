#!/bin/bash

#source $HOME/.bash_profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

export LANG=en_US.UTF-8

export PACKAGE_BASENAME="RestApp-${JOB_NAME}-${BUILD_NUMBER}"

export GYM_OUTPUT_NAME="${PACKAGE_BASENAME}.ipa"

export DSYM_OUTPUT_PATH="../Build/${BUILD_NUMBER}"

cd RestApp

git reset --hard

if [ "$TARGET" == "Enterprise" ]
then
  rm -r ./RestApp/Images.xcassets
  mv ./RestApp/Images-Enterprise.xcassets ./RestApp/Images.xcassets
fi

fastlane $TARGET debug:$DEBUG

if [ "$TARGET" != "Release" ]
then
  curl "${IPAPK_SERVER}/upload" -F "package=@${WORKSPACE}/Build/${BUILD_NUMBER}/${GYM_OUTPUT_NAME}" --insecure
fi
