#!/bin/bash

# Check if sdkman is installed
if [ -z "$SDKMAN_DIR" ]; then
  echo "sdkman is not installed. Please install sdkman first."
  exit 1
fi

# Load sdkman
source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Get the current Java version
current_java_version=$(sdk current java | grep -oP '(?<=Using java version ).*')

# Print the current Java version with the Java Unicode character
echo -e "Java $current_java_version"
