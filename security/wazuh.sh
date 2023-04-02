#!/bin/bash

#Set the env
export WAZUH_MANAGER='wazuh.jumpstartlabs.co'
# Install Wazuh agent dependencies
sudo apt-get update
sudo apt-get install curl apt-transport-https lsb-release gnupg2 -y

# Import the Wazuh GPG key
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -

# Add Wazuh repository
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

# Install Wazuh agent
sudo apt-get update
sudo apt-get install wazuh-agent -y

# Register the Wazuh agent with the manager
#sudo /var/ossec/bin/agent-auth -m wazuh.jumpstartlabs.co -p 1515

#Replace the line in ossec config file with the location of the wazuh server.
sed -i 's/\(<address>\)MANAGER_IP\(<\/address>\)/\1wazuh.jumpstartlabs.co\2/' /var/ossec/etc/ossec.conf

# Set up the Wazuh agent service
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
sudo systemctl status wazuh-agent
