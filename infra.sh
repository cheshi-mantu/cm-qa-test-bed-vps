#!/bin/bash

#use following to update the repo from github
#git fetch && git reset --hard HEAD &&git merge '@{u}'

# deleting a user
# killall -u $1 && userdel -f $1 && userdel -r $1
# userdel -rfRZ $1

echo "Script should be started under root user"

#creating new log file
LOG_FILE_NAME=exec-log.txt
# just out of curiocity< how long will it take
TIME_START=$(date)


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

docker version >> ${LOG_FILE_NAME}

#groupadd docker
usermod -aG docker ${NEW_USER}
#newgrp docker

echo "$(date) Installing docker-compose..." |& tee -a ${LOG_FILE_NAME}
#curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#chmod +x /usr/local/bin/docker-compose

apt-get install docker-compose -y


echo "$(date) Checking docker-compose version" |& tee -a ${LOG_FILE_NAME}

docker-compose version


echo "$(date) Installing docker compose as docker plug-in..." |& tee -a ${LOG_FILE_NAME}

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose

chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
docker compose version

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

echo "Waiting 60 seconds for jenkins to start up."

sleep 60

clear

JENKINS_PASSWORD=$(docker exec -t test-bed_jenkins_1 cat /var/jenkins_home/secrets/initialAdminPassword)

echo "This is your initial Jenkins admin password: ${JENKINS_PASSWORD}" |& tee -a ${LOG_FILE_NAME}
echo
echo
echo
echo

echo "Selenoid's status: $(curl $IP_ADDRESS:4444/wd/hub/status)"|& tee -a ${LOG_FILE_NAME}

echo
echo
echo
echo "Selenoid's UI status: $(curl $IP_ADDRESS:8080/status)"|& tee -a ${LOG_FILE_NAME}

echo
echo
echo
echo "Now, try to open Jenkins at: http://$IP_ADDRESS:8888 and use $JENKINS_PASSWORD"


TIME_END=$(date)

echo "QA test bed setup has been completed"
echo "Now, you need to configure Jenkins and you are ready to go."
echo "1. Stop your test bed with docker-compose down (you need to be in the folder with the configs to do that)"
echo "2. Log-in as ${NEW_USER} with password ${NEW_USER_PASSWORD}"
echo "3. Start test bed with docker-compose up -d command"

echo "What's done:"
echo "Root's password has been updated to '${ROOT_PASS}'"
echo "New user '${NEW_USER}' has been created with the password '${NEW_USER_PASS}'"
echo "Test bed files are here: /home/$NEW_USER/test-bed" |& tee -a ${LOG_FILE_NAME}
echo "jenkins, selenoid, selenoid-ui docker images were downloaded and started"
echo "jenkins application ${IP_ADDRESS}:8888" |& tee -a ${LOG_FILE_NAME}
echo "selenoid application ${IP_ADDRESS}:4444/wd/hub" |& tee -a ${LOG_FILE_NAME}
echo "selenoid-ui application ${IP_ADDRESS}:8080" |& tee -a ${LOG_FILE_NAME}

echo "All logs of this script are stored in '${LOG_FILE_NAME}', so if you missed something, check the log"

echo "Now, you need to close the connection - 'exit'"
echo "Log in as '${NEW_USER}' with the password '${NEW_USER_PASS}' via ssh ${NEW_USER}@${IP_ADDRESS}"


echo "Started:  $TIME_START" |& tee -a ${LOG_FILE_NAME}
echo "Finished: $TIME_END" |& tee -a ${LOG_FILE_NAME}
