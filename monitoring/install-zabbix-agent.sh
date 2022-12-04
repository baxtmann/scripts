#This script will install Zabbix agent on a Linux server if it does not already exist, and edit the configuration file to point to the Zabbix server.

#Check if Zabbix agent is already installed
if [ -f /etc/zabbix/zabbix_agentd.conf ]; then
    echo "Zabbix agent is already installed, we will just update the configuration file."
    server_hostname=$(hostname)
    sed -i "s/^Hostname=.*/Hostname=$server_hostname/" /etc/zabbix/zabbix_agentd.conf
    sed -i 's/^Server=.*/Server=zabbix.jumpstartlabs.co/' /etc/zabbix/zabbix_agentd.conf
    sed -i "s/^ServerActive=.*/ServerActive=zabbix.jumpstartlabs.co/" /etc/zabbix/zabbix_agentd.conf
    #now we restart and enable the zabbix agent
    systemctl restart zabbix-agent
else
    #Install Zabbix agent
    echo "Installing Zabbix agent"
    #first we need to determine if the os is ubuntu 18 or 20
    # Check if the lsb_release command is available
    if command -v lsb_release >/dev/null 2>&1; then
        # Get the Ubuntu version number
        ubuntu_version=$(lsb_release -r | awk '{print $2}')

        # Check if the version is 18.04 or 20.04
        if [ $ubuntu_version = "18.04" ]; then
            # Ubuntu version is 18.04
            wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu18.04_all.deb
            dpkg -i zabbix-release_6.2-4+ubuntu18.04_all.deb
            apt update
            apt install zabbix-agent2 zabbix-agent2-plugin-* -y
            #We need to get the hostname of the server now and add it to the zabbix_agentd.conf file
            server_hostname=$(hostname)
            sed -i "s/^Hostname=.*/Hostname=$server_hostname/" /etc/zabbix/zabbix_agentd.conf
            sed -i 's/^Server=.*/Server=zabbix.jumpstartlabs.co/' /etc/zabbix/zabbix_agentd.conf
            sed -i "s/^ServerActive=.*/ServerActive=zabbix.jumpstartlabs.co/" /etc/zabbix/zabbix_agentd.conf
            #now we restart and enable the zabbix agent
            systemctl restart zabbix-agent2
            systemctl enable zabbix-agent2
        fi
        if [ $ubuntu_version = "20.04" ]; then
            # Ubuntu version is 20.04
            wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu20.04_all.deb
            dpkg -i zabbix-release_6.2-4+ubuntu20.04_all.deb
            apt update
            apt install zabbix-agent2 zabbix-agent2-plugin-* -y
            #We need to get the hostname of the server now and add it to the zabbix_agentd.conf file
            server_hostname=$(hostname)
            sed -i "s/^Hostname=.*/Hostname=$server_hostname/" /etc/zabbix/zabbix_agentd.conf
            sed -i 's/^Server=.*/Server=zabbix.jumpstartlabs.co/' /etc/zabbix/zabbix_agentd.conf
            sed -i "s/^ServerActive=.*/ServerActive=zabbix.jumpstartlabs.co/" /etc/zabbix/zabbix_agentd.conf
            #now we restart and enable the zabbix agent
            systemctl restart zabbix-agent2
            systemctl enable zabbix-agent2
        fi
        else
            # Ubuntu version is not 18.04 or 20.04, so print an error message and exit
            echo "Error: This script is only compatible with Ubuntu 18.04 and 20.04."
            exit 1
        fi
    fi
    #If statement for if the lsb release doesn't run
    if ! command -v lsb_release >/dev/null 2>&1; then
        echo "Error: This script is only compatible with Ubuntu 18.04 and 20.04."
        exit 1
    fi
