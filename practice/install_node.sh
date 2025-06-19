#!/bin/bash

# Debian/Ubuntu Node.js Installer Script

apt-get update -y

PACKAGES="nodejs npm git"

for i in $PACKAGES; do
    if dpkg -l | grep -q $i > /dev/null 2>&1; then
        echo "$i already installed."
    else
        echo "Installing $i..."
        apt-get install -y $i --no-install-recommends
    fi
done

if npm -g list express > /dev/null 2>&1; then
    echo "Express is already installed."
else
    echo "Installing Express..."
    npm install -g express
fi