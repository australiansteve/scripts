#!/bin/bash
#
# This script clones the 'heisenberg' WordPress starter theme, created by ZeekInteractive, 
# which is based on the WordPress starter theme _s (underscores.me) 
# 
# It replaces all references to 'heisenberg' variations, as described in the _s github page (https://github.com/Automattic/_s)
# 
# It then installs all packages leaving the new theme ready for deployment
#
# Author: australiansteve [https://github.com/australiansteve]
# 

if [ "$1" != "" ]; then
	THEME_NAME=$1
    echo "Creating theme '$THEME_NAME'";

    echo "Creating $THEME_NAME directory and moving into it"
    mkdir $THEME_NAME;
    cd $THEME_NAME

    echo "Cloning 'heisenberg' from github into $THEME_NAME directory"
    git clone https://github.com/ZeekInteractive/heisenberg.git .

    echo "Replacing 'heisenberg' references in gulpfile"
    perl -pi -e "s{'heisenberg'}{'$THEME_NAME'}g" gulpfile.js
    perl -pi -e "s{'heisenberg.dev/'}{'localhost/'}g" gulpfile.js

    #_s replacements. See https://github.com/Automattic/_s

    echo "Search for: 'heisenberg' and replace"
    perl -e "s{'heisenberg'}{'$THEME_NAME'}g" -pi $(find . -type f)
    perl -e "s|\"heisenberg\"|\"$THEME_NAME\"|g" -pi $(find . -type f)

    echo "Search for: heisenberg_ and replace"
    perl -e "s|heisenberg_|$THEME_NAME\_|g" -pi $(find . -type f)

    echo "Search for: Text Domain: heisenberg and replace"
    perl -e "s{Text Domain: heisnberg}{Text Domain: $THEME_NAME}g" -pi $(find . -type f)

    echo "Search for:  heisenberg and replace"
    perl -e "s{ heisenberg}{ $THEME_NAME}g" -pi $(find . -type f)

    echo "Search for: heisenberg- and replace"
    perl -e "s{heisenberg-}{$THEME_NAME-}g" -pi $(find . -type f)

    echo "Search for: ZeekInteractive/heisenberg and replace"
    perl -e "s{ZeekInteractive/heisenberg}{australiansteve/$THEME_NAME}g" -pi $(find . -type f)

    echo "Search for: Heisenberg and replace"
    perl -e "s{Heisenberg}{\u$THEME_NAME}g" -pi $(find . -type f)


    echo "Installing bower components (Foundation)"
	bower install
    
    echo "Install packages"
    npm install

    echo "Committing changes"
    git add -A
    git commit -m "Intial commit of theme based on ZeekInteractive's 'heisenberg' starter theme"

else
    echo "Must provide theme name!";
    exit 1;
fi