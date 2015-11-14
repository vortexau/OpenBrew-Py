#!/bin/bash
if cordova-icon ; then
    echo "Cordova Icon succeeded"
else
    echo "Have you run 'npm install cordova-icon' and 'npm install cordova-icon -g'? Have you got ImageMagick installed?"
fi
