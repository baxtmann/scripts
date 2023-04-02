# scripts
Random Scripts I've Made/Used

# Kubernetes
- init.sh - Installs latest updates for raspbian and enables virtualization (required step when doing Kubernetes on RPI)

Quick way to pull down script: 


Install Zabbix Agent:
sudo git clone https://github.com/baxtmann/scripts && cd scripts/ && cd monitoring/ && sudo sh ./install-zabbix-agent.sh

Install Wazuh Agent:
sudo git clone https://github.com/baxtmann/scripts && cd scripts/ && cd security/ && sudo sh ./wazuh.sh