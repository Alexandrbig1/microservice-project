#!/bin/bash

# Install Docker, Docker Compose, Python 3.9+, and Django with pip

set -e

apt-get update -y

PACKAGES="docker.io docker-compose python3 python3-pip"

for i in $PACKAGES; do
  if dpkg -l | grep -q $i > /dev/null 2>&1; then
    echo "$i is already installed."
  else
    echo "Installing $i..."
    apt-get install -y $i --no-install-recommends
  fi
done

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED_VERSION="3.9"
if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]]; then
  echo "Python version $PYTHON_VERSION is OK."
else
  echo "Python 3.9 or newer is required. Current version: $PYTHON_VERSION"
  exit 1
fi

# Check Django
if pip3 show django > /dev/null 2>&1; then
  echo "Django is already installed."
else
  echo "Installing Django..."
  pip3 install django
fi

echo "All tools are installed and up to date."