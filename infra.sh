#!/bin/bash

# echo "Script should be started as root user"

#creating new log file
LOG_FILE_NAME=exec-log.txt

echo "$(date) log file has been created" > ${LOG_FILE_NAME}
echo "Log file ${LOG_FILE_NAME} has been created."

# Creating the password for the user root
echo "#########################################################"
echo "We would need to create a new password for you, $(whoami)"
echo "#########################################################"

read -p "Please enter new password for your account: " NEW_PASS
echo $NEW_PASS

echo "Created new password for $(whoami) = ${NEW_PASS}" >> ${LOG_FILE_NAME}

echo -e "${NEW_PASS}\n${NEW_PASS}\n" | passwd

echo "We are going to create a new user now."

sleep 5

# read -p "Please enter new user's name: " NEW_USER

# useradd -m -g users ${NEW_USER}
# echo "$(date) Added user ${NEW_USER}" >> ${LOG_FILE_NAME}

# echo "Adding ${NEW_USER} to sudoers"
# usermod -aG sudo ${NEW_USER}

# echo "$(date) Added user ${NEW_USER} to sudoers" >> ${LOG_FILE_NAME}

# read -p "We need to create a new password for ${NEW_USER}: " NEW_USER_PASS

# echo -e "${NEW_USER_PASS}\n${NEW_USER_PASS}\n" | passwd ${NEW_USER}

# echo "$(date) new password for ${NEW_USER} created ${NEW_USER_PASS} " >> ${LOG_FILE_NAME}

# echo "Listing the /home directory "
# ls /home/

# echo "Adding authorized keys to /home/${NEW_USER})"
# cp -a /root/.ssh /home/${NEW_USER}

# echo "$(date) $(ls -a /home/${NEW_USER}/.ssh) has been added from root"

# echo "$(date) $(ls -a /home/${NEW_USER}/.ssh) has been added" >> ${LOG_FILE_NAME}
# echo "$(date) Current ownership over $(ls -lr /home/${NEW_USER}/.ssh)" >> ${LOG_FILE_NAME}

# echo "Now updating the ownership over /home/${NEW_USER}/.ssh"

# chown -R ${NEW_USER}:users /home/${NEW_USER}/.ssh

# echo "$(date) Ownership over $(ls -a /home/${NEW_USER}/.ssh) has been updated" >> ${LOG_FILE_NAME}
# echo "$(date) Ownership over $(ls -lr /home/${NEW_USER}/.ssh) has been updated" >> ${LOG_FILE_NAME}

# # installing new software

# echo "Updating repos, upgrading installed software"
# #apt update && apt upgrade -y

# echo "Installing Midnight Commander"
# #apt install mc -y

# echo "Installed midnight commander" >> ${LOG_FILE_NAME}

# echo "Installing default JDK"

# apt install default-jdk -y >> ${LOG_FILE_NAME}
# java --version

# echo "Curent Java version is $(java --version)" >> ${LOG_FILE_NAME}

# echo "Updating repos, upgrading installed software"
# #apt update && apt upgrade -y

# echo "Installing Midnight Commander"
# #apt install mc -y

# echo "Installed midnight commander" >> ${LOG_FILE_NAME}

# echo "Installing default JDK"

# apt install default-jdk -y

# echo "java --version is $(java --version)"
# echo "$(date) java --version is $(java --version)" >> ${LOG_FILE_NAME}

# echo "Curent Java version is $(java --version)" >> ${LOG_FILE_NAME}


# cat << EOF >> /etc/environment
# JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
# EOF
# source /etc/environment

# echo "Checking JAVA_HOME is set"
# echo "echo JAVA_HOME output is $(echo $JAVA_HOME)"
# echo "$(date) JAVA_HOME is set to ${JAVA_HOME}" >> ${LOG_FILE_NAME}

# echo "Downloading script for the docker's installation and running it"
# curl -sSL https://get.docker.com | sh
# docker version

# docker version >> ${LOG_FILE_NAME}

# echo 
# groupadd docker >> ${LOG_FILE_NAME}
# usermod -aG docker $NEW_USER >> ${LOG_FILE_NAME}
# newgrp docker >> ${LOG_FILE_NAME}

# echo "Installing docker-comose..."
# curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# echo "Checking docker-compose version"
# docker-compose version

# echo "Checking docker-compose version" >> ${LOG_FILE_NAME}

# docker-compose version >> ${LOG_FILE_NAME}

# mkdir /home/${NEW_USER}/test-bed
# mkdir /home/${NEW_USER}/test-bed/init
# mkdir /home/${NEW_USER}/test-bed/init/selenoid
# mkdir /home/${NEW_USER}/test-bed/work

# curl -L https://github.com/cheshi-mantu/cm-qa-test-bed-vps/blob/main/test-bed/init/selenoid/browsers.json -o /home/${NEW_USER}/test-bed/init/selenoid/browsers.json

# curl -L https://github.com/cheshi-mantu/cm-qa-test-bed-vps/blob/main/test-bed/docker-compose.yml -o /home/${NEW_USER}/test-bed/docker-compose.yml

# chown -R ${NEW_USER}:users /home/${NEW_USER}/test-bed

# runuser -l ${NEW_USER} -c 'cd ~/ && git clone https://github.com/cheshi-mantu/cm-qa-test-bed-vps.git test-bed'
# runuser -l ${NEW_USER} -c 'cd ~/test-bed/test-bed && docker-compose up -d'
# echo "This is your initial Jenkins admin password" 

# JENKINS_PASSWORD= $(docker exec -t test-bed_jenkins_1 cat /var/jenkins_home/secrets/initialAdminPassword)

# echo "This is your initial Jenkins admin password: ${JENKINS_PASSWORD}" >> ${LOG_FILE_NAME}


# echo "Pulling chrome images for selenoid"
# CHROME_RELEASES="93 94 95"

# for RELEASE in $CHROME_RELEASES
# do
#     echo "Pulling chrome ${RELEASE}.0"
#     docker pull selenoid/vnc:chrome_${RELEASE}.0
# done


# echo

# echo "checking selenoid is up" 

# https://ipv4.icanhazip.com/
