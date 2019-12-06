kubectl apply -f mydb.yaml --record
kubectl apply -f mychat.yaml --record

kubectl patch service mychat \
  -p '{"spec": {"type": "LoadBalancer", "externalIPs":["'$(minikube ip)'"]}}'
