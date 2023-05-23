#! /bin/bash
printf "Setup\n"
gcloud config set account student-04-95d16e0dfe74@qwiklabs.net #emailqwiklab
gcloud config set project qwiklabs-gcp-01-d49523f08b61 #projectIDqwiklab
printf "Setup Done\n"

printf "Task 1. Configure the enviroment\n"
gcloud services enable run.googleapis.com
gcloud config set compute/region us-central1
gcloud config set run/region us-central1
LOCATION="us-central1"
printf "Task 1 Done\n"

printf "Task 2. Write a simple application\n"
mkdir helloworld && cd helloworld
printf "Task 2 Done\n"

printf "Task 3. Containerize your app and upload it to Container Registry Artifact Registry)\n"
gcloud builds submit --tag gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld
printf "Task 3 Done\n"

printf "Task 4. Deploy your container to Cloud Run\n"
gcloud run deploy --image gcr.io/$GOOGLE_CLOUD_PROJECT/helloworld
printf "Task 4 Done\n"

printf "Task 5. Reserve an external IP address\n"
gcloud compute addresses create example-ip \
    --ip-version=IPV4 \
    --global
gcloud compute addresses describe example-ip \
    --format="getaddress)" \
    --global
printf "Task 5 Done\n"

printf "Task 6. Create the external HTTP load balancer\n"
gcloud compute network-endpoint-groups create myneg \
   --region=$LOCATION \
   --network-endpoint-type=serverless  \
   --cloud-run-service=helloworld
gcloud compute backend-services create mybackendservice \
    --global
gcloud compute backend-services add-backend mybackendservice \
    --global \
    --network-endpoint-group=myneg \
    --network-endpoint-group-region=$LOCATION
gcloud compute url-maps create myurlmap \
    --default-service mybackendservice
gcloud compute target-http-proxies create mytargetproxy \
    --url-map=myurlmap
gcloud compute forwarding-rules create myforwardingrule \
    --address=example-ip \
    --target-http-proxy=mytargetproxy \
    --global \
    --ports=80
printf "Task 6 Done\n"