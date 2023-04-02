
#This script will install Zabbix agent on a Linux server if it does not already exist, and edit the configuration file to point to the Zabbix server.

#Check if Zabbix agent is already installed
if [ -f /etc/zabbix/zabbix_agent2.conf ]; then #CHANGE THIS ONCE INITIAL TESTING IS DONE TO AGENT2 PATH
    echo "Zabbix agent is already installed, we will just update the configuration file."
    server_hostname=$(hostname)
    sed -i "s/^Hostname=.*/Hostname=$server_hostname/" /etc/zabbix/zabbix_agent2.conf
    sed -i 's/^Server=.*/Server=zabbix.jumpstartlabs.co,192.168.0.180/' /etc/zabbix/zabbix_agent2.conf
    sed -i "s/^ServerActive=.*/ServerActive=zabbix.jumpstartlabs.co,192.168.0.180/" /etc/zabbix/zabbix_agent2.conf
    #now we restart and enable the zabbix agent
    systemctl restart zabbix-agent
elif [ -f /etc/zabbix/zabbix_agentd.conf ]; then #CHANGE THIS ONCE INITIAL TESTING IS DONE TO AGENT2 PATH
    echo "Zabbix agent is already installed, we will just update the configuration file."
    server_hostname=$(hostname)
    sed -i "s/^Hostname=.*/Hostname=$server_hostname/" /etc/zabbix/zabbix_agentd.conf
    sed -i 's/^Server=.*/Server=zabbix.jumpstartlabs.co,192.168.0.156/' /etc/zabbix/zabbix_agentd.conf
    sed -i "s/^ServerActive=.*/ServerActive=zabbix.jumpstartlabs.co,192.168.0.156/" /etc/zabbix/zabbix_agentd.conf
    #now we restart and enable the zabbix agent
    systemctl restart zabbix-agent
else
    # Install Zabbix agent
    echo "Installing Zabbix agent"

    if command -v lsb_release >/dev/null 2>&1; then
        ubuntu_version=$(lsb_release -r | awk '{print $2}')
    else
        ubuntu_version=""
    fi

    if [ "$(uname -m)" = "armv7l" ] && [ "$(grep -E 'Raspbian' /etc/os-release)" ]; then
        os="raspbian"
    elif [ "$ubuntu_version" = "18.04" ] || [ "$ubuntu_version" = "20.04" ]; then
        os="ubuntu"
    else
        echo "Error: This script is only compatible with Ubuntu 18.04, 20.04, and Raspbian on ARM architecture."
        exit 1
    fi

    if [ "$os" = "raspbian" ]; then
        wget https://repo.zabbix.com/zabbix/6.4/raspbian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian9_all.deb
        dpkg -i zabbix-release_6.4-1+debian9_all.deb
    elif [ "$os" = "ubuntu" ]; then
        if [ "$ubuntu_version" = "18.04" ]; then
            wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu18.04_all.deb
            dpkg -i zabbix-release_6.2-4+ubuntu18.04_all.deb
        elif [ "$ubuntu_version" = "20.04" ]; then
            wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-4%2Bubuntu20.04_all.deb
            dpkg -i zabbix-release_6.2-4+ubuntu20.04_all.deb
        fi
    fi

    apt update
    apt install zabbix-agent2 -y

    server_hostname=$(hostname)
    sed -i "s/^Hostname=.*/Hostname=$server_hostname/" /etc/zabbix/zabbix_agent2.conf
    sed -i 's/^Server=.*/Server=zabbix.jumpstartlabs.co,192.168.0.180/' /etc/zabbix/zabbix_agent2.conf
        sed -i "s/^ServerActive=.*/ServerActive=zabbix.jumpstartlabs.co,192.168.0.180/" /etc/zabbix/zabbix_agent2.conf

    # Now we restart and enable the zabbix agent
    systemctl restart zabbix-agent2
    systemctl enable zabbix-agent2
fi


