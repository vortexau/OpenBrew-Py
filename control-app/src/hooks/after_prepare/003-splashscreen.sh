#!/bin/bash
if cordova-splash ; then
    echo "Cordova Splash succeeded"
else
    echo "Have you run 'npm install cordova-splash' and 'npm install cordova-splash -g'? Have you got ImageMagick installed?"
fi

