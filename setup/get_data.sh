#!/usr/bin/env bash

# Either locally or remotely (on ec2) downloads necessary data.

sudo yum install python-pip -y
sudo pip3 install gdown

gdown https://drive.google.com/uc?id=10yVowvmFjMkY21-DGF2pej_Lbecfqou7
echo "Finished downloading training data."

echo "Unzipping training data..."
tar -xcf train-256.zip

curl -X GET https://storage.googleapis.com/kaggle-forum-message-attachments/536499/13292/test_256-2.zip -o test.zip
echo "Finished downloading test data."

echo "Unzipping test data..."
unzip test.zip

curl -X GET https://s3.amazonaws.com/google-landmark/metadata/train.csv -o train.csv
curl -X GET https://s3.amazonaws.com/google-landmark/metadata/test.csv -o test.csv
