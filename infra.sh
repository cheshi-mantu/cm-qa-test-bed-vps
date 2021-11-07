#!/bin/bash

#use following to update the repo from github
#git fetch && git reset --hard HEAD &&git merge '@{u}'

echo "Script should be started under root user"

#creating new log file
LOG_FILE_NAME=exec-log.txt

echo "$(date) log file has been created" > ${LOG_FILE_NAME}
echo "Log file ${LOG_FILE_NAME} has been created."

IP_ADDRESS=$(curl https://ipv4.icanhazip.com/)

echo "$(date) IP address of this machine ${IP_ADDRESS}" |& tee -a ${LOG_FILE_NAME}

# echo "$(date) IP address of this machine ${IP_ADDRESS}"

# Creating the password for the user root

echo "#########################################################"
echo "We would need to create a new password for you, $(whoami)"
echo "#########################################################"

read -p "Please enter new password for your account: " ROOT_PASS
echo $ROOT_PASS

echo "Created new password for $(whoami) = ${ROOT_PASS}" |& tee -a ${LOG_FILE_NAME}

echo -e "${ROOT_PASS}\n${ROOT_PASS}\n" | passwd

clear

echo "We are going to create a new user now."
echo "Everything you will do with your test bed needs to be done under user we are going to create!"

sleep 3

read -p "Please enter new user's name: " NEW_USER

useradd -m -g users ${NEW_USER}
echo "$(date) Added user ${NEW_USER}" |& tee -a ${LOG_FILE_NAME}

echo "Adding ${NEW_USER} to sudoers"
usermod -aG sudo ${NEW_USER}

echo "$(date) Added user ${NEW_USER} to sudoers" |& tee -a ${LOG_FILE_NAME}

read -p "We need to create a new password for ${NEW_USER}: " NEW_USER_PASS

echo -e "${NEW_USER_PASS}\n${NEW_USER_PASS}\n" | passwd ${NEW_USER}

echo "$(date) new password for ${NEW_USER} created ${NEW_USER_PASS} " |& tee -a ${LOG_FILE_NAME}

echo "Listing the /home directory" |& tee -a ${LOG_FILE_NAME}
ls /home/ |& tee -a ${LOG_FILE_NAME}

echo "Adding authorized keys to /home/${NEW_USER})"
cp -a /root/.ssh /home/${NEW_USER}

echo "$(date) $(ls -a /home/${NEW_USER}/.ssh) has been added from root" |& tee -a ${LOG_FILE_NAME}

echo "$(date) Current ownership over $(ls -lr /home/${NEW_USER}/.ssh)" |& tee -a ${LOG_FILE_NAME}

echo "$(date) updating the ownership over /home/${NEW_USER}/.ssh" |& tee -a ${LOG_FILE_NAME}

chown -R ${NEW_USER}:users /home/${NEW_USER}/.ssh

echo "$(date) ownership over $(ls -a /home/${NEW_USER}/.ssh) has been updated" |& tee -a ${LOG_FILE_NAME}

# installing new software

echo "Updating repos, upgrading installed software"
apt update && apt upgrade -y |& tee -a ${LOG_FILE_NAME}

echo "$(date) Installing Midnight Commander"

apt install mc -y |& tee -a ${LOG_FILE_NAME}

echo "$(date) Installing default JDK" |& tee -a ${LOG_FILE_NAME}

apt install default-jdk -y |& tee -a ${LOG_FILE_NAME}

echo "$(date) $(java --version)" |& tee -a ${LOG_FILE_NAME}

echo "Curent Java version is $(java --version)" |& tee -a ${LOG_FILE_NAME}

echo "Updating repos, upgrading installed software"

cat << EOF >> /etc/environment
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
EOF

source /etc/environment

echo "$(date) Checking JAVA_HOME is set" |& tee -a ${LOG_FILE_NAME}
echo "$(date) echo JAVA_HOME is set to $(echo $JAVA_HOME)" |& tee -a ${LOG_FILE_NAME}

echo "$(date) Downloading script for the docker's installation and running it" |& tee -a ${LOG_FILE_NAME}

curl -sSL https://get.docker.com | sh

docker version |& tee -a ${LOG_FILE_NAME}

groupadd docker |& tee -a ${LOG_FILE_NAME}
usermod -aG docker
newgrp docker

echo "$(date) Installing docker-comose..." |& tee -a ${LOG_FILE_NAME}
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose |& tee -a ${LOG_FILE_NAME}

echo "$(date) Checking docker-compose version"

docker-compose version

cp -r ./test-bed /home/${NEW_USER} |& tee -a ${LOG_FILE_NAME}

chown -R ${NEW_USER}:users /home/${NEW_USER}/test-bed |& tee -a ${LOG_FILE_NAME}

# Pulling chrome images for selenoid

echo "Pulling chrome images for selenoid" |& tee -a ${LOG_FILE_NAME}

CHROME_RELEASES="93 94 95"

for RELEASE in $CHROME_RELEASES
do
    echo "Pulling chrome ${RELEASE}.0" |& tee -a ${LOG_FILE_NAME}
    docker pull selenoid/vnc:chrome_${RELEASE}.0
done

runuser -l ${NEW_USER} -c 'cd ~/test-bed && docker-compose up -d'
echo "This is your initial Jenkins admin password" 

JENKINS_PASSWORD= $(docker exec -t test-bed_jenkins_1 cat /var/jenkins_home/secrets/initialAdminPassword)

echo "This is your initial Jenkins admin password: ${JENKINS_PASSWORD}" |& tee -a ${LOG_FILE_NAME}

echo "Selenoid's status: $(curl ${IP_ADDRESS}:4444/wd/hub) "


# echo

# echo "checking selenoid is up" 

# https://ipv4.icanhazip.com/
