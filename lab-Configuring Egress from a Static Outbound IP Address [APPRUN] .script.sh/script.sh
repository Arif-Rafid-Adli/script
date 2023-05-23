#! /bin/bash
echo "Setup"
gcloud config set account student-04-95d16e0dfe74@qwiklabs.net #emailQwiklab
gcloud config set project wNkwdYvrs32Q #ProjectID
echo "Setup Done"

echo "Task 1. Enable the Cloud Run API and configure your Shell environment for flexibiilty"

gcloud services enable run.googleapis.com
gcloud config set compute/region us-central1
LOCATION="us-central1"

echo "Task 1 Done"

echo "Task 2. Create a service"

git clone https://github.com/GoogleCloudPlatform/buildpack-samples.git
cd buildpack-samples/sample-go
pack build --builder=gcr.io/buildpacks/builder sample-go
docker run -it -e PORT=8080 -p 8080:8080 sample-go
pack set-default-builder gcr.io/buildpacks/builder:v1
pack build --publish gcr.io/$GOOGLE_CLOUD_PROJECT/sample-go

echo "Task 2 Done"

echo "Task 3. Create a subnetwork"
gcloud compute networks list
gcloud compute networks subnets create mysubnet \
--range=192.168.0.0/28 --network=default --region=$LOCATION
echo "Task 3 Done"

echo "Task 4. Create a serverless VPC Access connector"
gcloud compute networks vpc-access connectors create myconnector \
  --region=$LOCATION \
  --subnet-project=$GOOGLE_CLOUD_PROJECT \
  --subnet=mysubnet
echo "Task 4 Done"

echo "Task 5. Configure network address translation (NAT)"
gcloud compute routers create myrouter \
  --network=default \
  --region=$LOCATION
gcloud compute addresses create myoriginip --region=$LOCATION
gcloud compute routers nats create mynat \
  --router=myrouter \
  --region=$LOCATION \
  --nat-custom-subnet-ip-ranges=mysubnet \
  --nat-external-ip-pool=myoriginip
echo "Task 5 Done"

echo "Task 6. Route Cloud Run traffic through the VPC network"
gcloud run deploy sample-go \
   --image=gcr.io/$GOOGLE_CLOUD_PROJECT/sample-go \
   --vpc-connector=myconnector \
   --vpc-egress=all-traffic
echo "Task 6 Done"
