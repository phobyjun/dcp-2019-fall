# Data Center Programming Assignment #3

## : Implement Docker Swarm Mode Using At Least 2 Docker Machines.

### Build Step:

1. Setting external port in docker-compose.yml
2. Create three docker-machines 
   - manager
   - db-worker
   - chat-worker
3. Set label to docker-machines (mydb and mychat)
   - docker-machine ssh <manager_node> docker node update --label-add label=mydb
   - docker-machine ssh <manager_node> docker node update --label-add label=mychat
4. docker-compose up, it's all

### WARNING:

- If you use node.role in constraints, docker-compose will make an error when you compose up. So, you have to use node.labels.label in constraints.
- If you don't make your own networks, each machines(services) cannot communication. So, you have to make your own networks. In docker-compose.yml, the network mynet is in there.

### Describe:

This application is based on Assignment #2. It simply evolve assignment #2 from 2 containers to 2 machines. So, any function in this assignment is same to assignment #2.