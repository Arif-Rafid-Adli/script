#! /bin/bash

#Setup 
gcloud auth list
gcloud config set project qwiklabs-gcp-04-023285f8bc10 #projectID
gsutil cp gs://spls/gsp499/user-authentication-with-iap.zip
unzip user-authentication-with-iap.zip
cd user-authentication-with-iap

#Task 1. Deploy the application and protect it with IAP
cd 1-HelloWorld
cat main.py
gcloud app deploy
gcloud app browse
gcloud services disable appengineflex.googleapis.com

#Task 2. Access user identity information
cd ~/user-authentication-with-iap/2-HelloUser
gcloud app deploy
# Test the updated IAP 
gcloud app browse


#Task 3. Use Cryptographic Verification
cd ~/user-authentication-with-iap/3-HelloVerifiedUser
gcloud app deploy
gcloud app browse
