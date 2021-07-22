#!/bin/bash

# Load config
echo "#\!/bin/bash" > archiso-install.sh
cat config.sh >> archiso-install.sh

# Load installation process
cat archiso.sh >> archiso-install.sh

chmod +x archiso-install.sh

./archiso-install.sh
