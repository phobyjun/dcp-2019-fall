# Data Center Programming Assignment #2

## :Evolve Project #1 to Multi-Container Model

### Build Step:

1. Setting external port in docker-compose.yml
2. docker-compose up, it's all

### WARNING:

- When you access to web application of mychat container using your external port, If the mydb container were not prepared yet, it is caused critical error. Please wait a second(about 10 seconds), and access this application.

### Describe:

This application is based on Assignment #1. Differences are database and communication between web and database. If the user on socket sends messages on application, it will be transport to database. It is made my multi-container model using customized image based on node.js and MySql.