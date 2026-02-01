#!/bin/bash

# Load sdkman
source "/home/ion/.sdkman/bin/sdkman-init.sh"

# Get the current Java version
current_java_version=$(sdk current java | grep -oP '(?<=Using java version ).*')

# Print the current Java version
echo -e "Java $current_java_version"
