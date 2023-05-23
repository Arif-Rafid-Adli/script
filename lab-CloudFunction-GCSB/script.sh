#! /bin

printf ("Task 1 : Create a function")
mkdir gcf_hello_world
cd gcf_hello_world
nano index.js
printf ("Task 1 Done")

printf (/n"Task 2 : Create a cloud storage bucket "n\)

 gsutil mb -p [PROJECT_ID] 
 gs://[BUCKET_NAME]

 printf (/n"Task 2 Done"n\)

 printf (/n"Task 3 :  Deploy your function"\n)

 gcloud functions deploy helloWorld \
  --stage-bucket [BUCKET_NAME] \
  --trigger-topic hello_world \
  --runtime nodejs8