# User Authentication - Strategy [Webhook token]
gcloud auth login

# Retrieve the Kubernetes credentials for a specific cluster:
gcloud container clusters get-credentials CLUSTER_NAME --zone=COMPUTE_ZONE

# Verify kube config file. [It should update with new credentials]
vi ~/.kube/config

#----------------------- User Authentication & Authorization - Strategy [X.509 Certificate] -----------------------

# Assume we want to add a new user to kubernetes to manage the cluster.
# Name: user1
# Generate a private key
openssl genrsa -out user1.key 2048

# Generate Certificate
openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=eng"\n

# Get the base64 encoded value of the CSR file content
cat user1.csr | base64 | tr -d "\n"

# Send Certificate to Kuberenetes cluster
kubectl create -f user1-signing-cert-request.yaml

# As an admin, you can approve this request.
kubectl certificate approve user1

# Get the certificate
kubectl get csr user1 -o yaml

kubectl get csr user1 -o jsonpath='{.status.certificate}' | base64 --decode > user1.crt

# User needs 2 files to get credentials.
# 1 => Get Certificate from Kuberentes
# 2 => Use the same key used to generate initial private key.
kubectl config set-credentials user1 --client-certificate=user1.crt --client-key=user1.key
kubectl config view

# Check if user1 have permissions to list pods

kubectl auth can-i list pods --as user1

# So far we only completed, User1 Authenticated to Kubernetes cluster.
# Now add authorization rules for user1
kubectl  create -f pod-reader-role.yaml

# Associate this role to User1.
kubectl create -f role-binding.yaml

#----------------------- Service Account Authentication -----------------------

# Create a service account. [Example application might be ci/cd application]
gcloud auth activate-service-account ci-cd-pipeline@myproject1-292702.iam.gserviceaccount.com \
    --key-file=gsa-key.json

gcloud config set project myproject1-292702

# This will populate credentials
gcloud container clusters get-credentials gkecluster-2 --zone=us-west2-a




