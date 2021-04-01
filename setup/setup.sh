#!/usr/bin/env bash

# Locally automates provisioning of an ec2 instance and environment setup.
# Assumes ssh config has been set with user and ignoring strict host key checking for EC2 instances.

INSTANCE_TYPE=p2.xlarge # 1xK80
IMAGE_ID=ami-09dc0f04371b9015c # AWS Deep Learning AMI (Linux 2, v23)
KEY_NAME=${1}
SG_ID=${2}
SUBNET_ID=${3}

if [[ -n ${4} ]]; then
  LOCAL_DATA_DIR=${4}
fi

# provision ec2 instance
RUN_OUTPUT=$(aws ec2 run-instances --count 1 --image-id ${IMAGE_ID} --instance-type ${INSTANCE_TYPE} --key-name ${KEY_NAME} --security-group-ids ${SG_ID} --subnet-id ${SUBNET_ID})
INSTANCE_ID=$(echo ${RUN_OUTPUT} | tr "," "\n" | grep InstanceId | awk -F " " '{print $2}' | sed 's/[,"]//g')
PUBLIC_DNS=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} --query 'Reservations[].Instances[].PublicDnsName' | grep ec2 | sed 's/[,"]//g' | sed 's/ //g')
echo "Provisioning ${INSTANCE_TYPE} EC2 instance with AMI ${IMAGE_ID} and instance ID ${INSTANCE_ID} and public DNS ${PUBLIC_DNS}"

# wait for instance to spin up.
echo "Waiting 120 seconds for instance to spin up..."
sleep 120

# optionally scp over a directory to the EC2 instance
if [[ -n ${4} ]]; then
  echo "Will scp the directory ${4} to the EC2 instance."
  scp -r ${4} ${PUBLIC_DNS}:~
fi

scp setup/get_data.sh ${PUBLIC_DNS}:~
scp train_and_inference.py ${PUBLIC_DNS}:~
scp sample_submission.csv ${PUBLIC_DNS}:~

# setup ec2 instance and forward ec2 port to localhost
ssh -L localhost:8888:localhost:8888 ${PUBLIC_DNS} <<ENDSSH
set -o xtrace

source activate tensorflow_p36
conda install nomkl -y

ENDSSH

echo "Setup complete."
