# render YAML without applying (great for teaching)
helm template hello ./helm-hello -n demo

# install (creates a Helm release named "hello")
helm install hello ./helm-hello -n demo

kubectl get deploy,svc -n demo
minikube service hello-helm-hello -n demo --url
# open the printed URL in browser or curl it:
curl "$(minikube service hello-helm-hello -n demo --url)"

===========================================================
helm upgrade hello ./helm-hello -n demo --set message="Hello from Helm v2"
curl "$(minikube service hello-helm-hello -n demo --url)"

===========================================================

helm history hello -n demo
helm rollback hello 1 -n demo
curl "$(minikube service hello-helm-hello -n demo --url)"

========================================================
minikube service hello-helm-hello -n demo --url

helm uninstall hello -n demo



==========================
kubectl create ns test
kubectl create ns staging

# Install TEST
helm install hello-test ./helm-hello -n test -f helm-hello/environments/test/values.yaml

# Install STAGING
helm install hello-staging ./helm-hello -n staging -f helm-hello/environments/staging/values.yaml

minikube service hello-test-helm-hello -n test --url
minikube service hello-staging-helm-hello -n staging --url

=====================================
For 3rd party HELM chart:

helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm repo update

helm template mysql bitnami/mysql --namespace default
helm install bitnami/mysql --generate-name
helm list
helm uninstall mysql
helm status mysql

helm status mysql
helm get values mysql
helm get manifest mysql


helm upgrade mysql bitnami/mysql  \
  --set replicaCount=2 \
  --set service.type=NodePort
kubectl get deploy,svc 

helm history mysql
helm upgrade mysql bitnami/mysql  --set replicaCount=9999

helm rollback mysql 1 
helm history mysql 