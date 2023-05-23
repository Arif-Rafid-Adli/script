echo "Setup"
gcloud config set account student-04-fecff4fd6543@qwiklabs.net #[emailQwiklab]
gcloud config set project qwiklabs-gcp-03-b64007b4eb28 #[projectID]
echo "Setup Done"

echo "Task 1. Configure the environment"
gcloud services enable run.googleapis.com
gcloud config set compute/refion us-central1
LOACTION="us-central1"
echo "Task 1 Done"

echo "Task 2. Create a Cloud SQL instance"
sleep 5
echo "Task 2 Done"

echo "Task 3. Populate the Cloud SQL instance"
gcloud sql connect poll-database --user=postgres
\connect postgres;
CREATE TABLE IF NOT EXISTS votes
( vote_id SERIAL NOT NULL, time_cast timestamp NOT NULL,
candidate VARCHAR(6) NOT NULL, PRIMARY KEY (vote_id) );
CREATE TABLE IF NOT EXISTS totals
( total_id SERIAL NOT NULL, candidate VARCHAR(6) NOT NULL,
num_votes INT DEFAULT 0, PRIMARY KEY (total_id) );
INSERT INTO totals (candidate, num_votes) VALUES ('TABS', 0);
INSERT INTO totals (candidate, num_votes) VALUES ('SPACES', 0);
echo "Task 3 Done"

echo "Task 4. Deploy a public service"
CLOUD_SQL_CONNECTION_NAME=$(gcloud sql instances describe poll-database --format='value(connectionName)')
gcloud beta run deploy poll-service \
   --image gcr.io/qwiklabs-resources/gsp737-tabspaces \
   --region $LOCATION \
   --allow-unauthenticated \
   --add-cloudsql-instances=$CLOUD_SQL_CONNECTION_NAME \
   --set-env-vars "DB_USER=postgres" \
   --set-env-vars "DB_PASS=secretpassword" \
   --set-env-vars "DB_NAME=postgres" \
   --set-env-vars "CLOUD_SQL_CONNECTION_NAME=$CLOUD_SQL_CONNECTION_NAME"
gcloud beta run deploy poll-service \
   --image gcr.io/qwiklabs-resources/gsp737-tabspaces \
   --region $LOCATION \
   --allow-unauthenticated \
   --add-cloudsql-instances=$CLOUD_SQL_CONNECTION_NAME \
   --set-env-vars "DB_USER=postgres" \
   --set-env-vars "DB_PASS=secretpassword" \
   --set-env-vars "DB_NAME=postgres" \
   --set-env-vars "CLOUD_SQL_CONNECTION_NAME=$CLOUD_SQL_CONNECTION_NAME"
POLL_APP_URL=$(gcloud run services describe poll-service --platform managed --region us-central1 --format="value(status.address.url)")
echo "Task 4 Done"

echo "Task 5. Testing the application"
sleep 5
echo "Task 5 Done"