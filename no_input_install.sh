#!/bin/bash

# This script runs the install.sh script with automated input
# provided by a heredoc to ensure a hands-free installation.

echo "Starting automated installation..."

wget https://raw.githubusercontent.com/weberam2/SimpleDotFiles/main/install.sh
chmod +x install.sh

./install.sh << EOF
n
y
n
$(echo -e '\r')
$(echo -e '\r')
EOF

echo "Automated installation complete!"
