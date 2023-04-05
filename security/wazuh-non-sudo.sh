#!/bin/bash

#Set the env
export WAZUH_MANAGER='wazuh.jumpstartlabs.co'
# Install Wazuh agent dependencies
apt-get update
apt-get install curl apt-transport-https lsb-release gnupg2 -y

# Import the Wazuh GPG key
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -

# Add Wazuh repository
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list

# Install Wazuh agent
apt-get update
apt-get install wazuh-agent -y

# Register the Wazuh agent with the manager
#/var/ossec/bin/agent-auth -m wazuh.jumpstartlabs.co -p 1515

#Replace the line in ossec config file with the location of the wazuh server.
sed -i 's/\(<address>\)MANAGER_IP\(<\/address>\)/\1wazuh.jumpstartlabs.co\2/' /var/ossec/etc/ossec.conf

# Set up the Wazuh agent service
systemctl enable wazuh-agent
systemctl start wazuh-agent
systemctl status wazuh-agent
