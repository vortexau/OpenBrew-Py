# OpenBrew - Control App

This app uses the Gulp taskrunner to execute the build process. To run this, you'll need the list of dependancies in the 'packages.json' file. This is a special file that NodeJS, specifically the [NPM|Node Package Manager] uses to install packages.

Prerequisites:
 - [NodeJS] NodeJS
 - [NPM] NPM
 - Android SDK
 - (iOS) OSX, with XCode with Command Line Tools 
 - ImageMagick (For automatically building app icons, from the root icon)

Steps:
 - Install [NodeJS] NodeJS, following your OS's guidelines.
 - Install the [NodeJS] NodeJS packages.
   - npm install
 - Install [Gulp] Gulp, Globally
   - npm install -g gulp
 - Run the Build
   - gulp build

The build will build Android by default, but if you're on OS-X it will also attempt to build for iOS also. The build includes a couple of hooks to make the build easier, such as generating the icons automatically etc.

The gulpfile.js could possibly be tidied up a little bit, too. This is also of course an on-going work and will often change.

This app is, like the rest of the code, licenced with [BEERWARE] licence

[NodeJS]: <https://nodejs.org/en/>
[Gulp]: <http://gulpjs.com>
[NPM]: <https://www.npmjs.com/>
[BEERWARE]: <https://fedoraproject.org/wiki/Licensing/Beerware>
