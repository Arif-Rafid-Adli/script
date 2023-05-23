#! /bin/bash

echo "Setup"
gcloud config set account student-04-fecff4fd6543@qwiklabs.net #emailqwiklab
gcloud config set project qwiklabs-gcp-01-03564f7fecda #projectID
echo "Setup Done"
sleep 5
echo "Task 1. Enable the Cloud Run API and configure your Shell environment"
gcloud services enable run.googleapis.com
gcloud config set compute/region us-central1
LOCATION="us-central1"
echo "Task 1 Done"
sleep 5
echo "Task 2. Write the sample application"
mkdir helloworld && cd helloworld
nano package.json
nano index.js
echo "Task 2 Done"
sleep 5
echo "Task 3. Containerize your app and upload it to Artifact Registry"
nano Dockerfile
gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld
gcloud container images list
docker run -d -p 8080:8080 gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld
echo "Task 3 Done"
sleep 5
echo "Task 4. Enable the Cloud Run API and configure your Shell environment"
gcloud run deploy --image gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld --allow-unauthenticated --region=$LOCATION
echo "Task 4 Done"
echo "Task 5. Clean up"
gcloud container images delete gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld
gcloud run services delete helloworld --region=us-central1
echo "Task 5 Done"

