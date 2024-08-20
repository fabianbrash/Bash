#!/bin/bash

ip_array=("192.168.181.10" "192.168.181.14" "192.168.181.15" "192.168.181.16" "192.168.181.17")

# Define the command you want to run on each IP
remote_command="sudo systemctl stop firewalld && rm -rf mks && sudo yum install -y bzip2" # Replace this with the command you want to run on the remote host

# Define SSH user
user="alma" # Replace with your SSH username

# Loop through each IP address in the array
for ip in "${ip_array[@]}"
do
    echo "Connecting to $ip"
    ssh "${user}@${ip}" "${remote_command}"
    if [ $? -eq 0 ]; then
        echo "Command executed successfully on $ip"
    else
        echo "Failed to execute command on $ip"
    fi
    echo "--------------------------------"
done
