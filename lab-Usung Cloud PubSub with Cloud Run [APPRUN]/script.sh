#! /bin/bash

printf "Setup\n"
gcloud config set account student-04-fecff4fd6543@qwiklabs.net #emailqwiklab
gcloud config set project qwiklabs-gcp-03-9e14875d4e3b #projectID
printf "Setup Done\n"

printf "Task 1. Ensure that the Cloud Pub/Sub API is successfully enable\n"
sleep 5
printf "Task 1 Done\n"

printf "Task 2. Developing a minimal viable product(MVP)\n"
gcloud services enable run.googleapis.com
LOCATION=us-central1
gcloud config set compute/region $LOCATION
 gcloud run deploy store-service \
  --image gcr.io/qwiklabs-resources/gsp724-store-service \
  --region $LOCATION \
  --allow-unauthenticated
 gcloud run deploy order-service \
  --image gcr.io/qwiklabs-resources/gsp724-order-service \
  --region $LOCATION \
  --no-allow-unauthenticated
printf "Task 2 Done\n"
sleep 5
printf "Task 3. Deplpying Cloud Pub/Sub\n"
gcloud pubsub topics create ORDER_PLACED
printf "Task 3 Done\n"
sleep 5
printf "Task 4. Creating a service account\n"
gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "Order Initiator"
gcloud iam service-accounts list --filter="Order Initiator"
sleep 5
gcloud run services add-iam-policy-binding order-service --region $LOCATION \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker --platform managed
PROJECT_NUMBER=$(gcloud projects list \
  --filter="qwiklabs-gcp" \
  --format='value(PROJECT_NUMBER)')
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
   --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
   --role=roles/iam.serviceAccountTokenCreator

printf "Task 4 Done\n"
sleep 5
printf "Task 5. Create a Cloud Pub/Sub subcription\n"
 ORDER_SERVICE_URL=$(gcloud run services describe order-service \
   --region $LOCATION \
   --format="value(status.address.url)")
 gcloud pubsub subscriptions create order-service-sub \
   --topic ORDER_PLACED \
   --push-endpoint=$ORDER_SERVICE_URL \
   --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
printf "Task 5 Done\n"
sleep 5
printf "Task 6. Testing the application\n"
 STORE_SERVICE_URL=$(gcloud run services describe store-service \
   --region $LOCATION \
   --format="value(status.address.url)")
curl -X POST -H "Content-Type: application/json" -d @test.json $STORE_SERVICE_URL
printf "Task 6 Done\n"