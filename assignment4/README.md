# Data Center Programming Assignment #4

## Case 3 (for Kubernetes case):

- Evolve Project #3 over Kubernetes.
- Containers in Project #3 can be
  - Containers in a same Pod, or
  - Independent Pods

### Build Step:

1. Start your Kubernetes engine(Only minikube)

2. Only execute autobuild.sh in bash shell

   When delete this application, only execute autodelete.sh

3. Then ,you can use this application at http://\<minikube _ip>:external_port

### WARNING:

- This application is made my executable on minikube. Please execute this application on minikube.
- In autobuild.sh, "patch" command in there. It is necessary on minikube, because LoadBalancer in minikube can't set the external IP automatically. So, I used "minikube ip" command for setting external ip to my cluster ip.
- If you using replicas on this application, it will make an error for that. I think that this error is because of the socket conflict. I'm searching about this error and will solve it soon :X

### Describe:

- It is evolved Project based on Assignment #3. Function in this application is same to assignment #3. There are frontend with backend using node.js, and database using MySql. They are communication each other. If user in chatting web is expand text to server, text will send to messages table in messages database. 
- I deploy mychat and mydb. And they contain the Service and StatefulSet.

