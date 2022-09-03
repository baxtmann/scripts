echo "updating apt and apt-get"
sudo apt-get update && sudo apt update
echo "upgrarding apt and apt-get"
sudo apt-get upgrade -y && sudo apt upgrade -y

echo "enable virtualization for raspbian"
cp /boot/cmdline.txt /boot/cmdline.txt.bak1
orig="$(head -n1 /boot/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
echo $orig | tee /boot/cmdline.txt
echo "rebooting..."
reboot