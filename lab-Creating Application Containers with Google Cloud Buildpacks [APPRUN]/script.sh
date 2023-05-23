#! /bin/bash
gcloud auth set account student-04-9c7c3d1ddb71@qwiklabs.net #emailqwiklab
gcloud config set project qwiklabs-gcp-02-ae8bbe050d2f       #projectid qwiklab

gcloud services enable run.googleapis.com
gcloud config set compute/region us-central1

git clone https://github.com/GoogleCloudPlatform/buildpack-samples.git
cd buildpack-samples/sample-nod
pack build --builder=gcr.io/buildpacks/builder sample-node
docker run -it -e PORT=8080 -p 8080:8080 sample-node

gcloud beta run deploy --source .
