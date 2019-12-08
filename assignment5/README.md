# Data Center Programming Assignment #5

## CONTENTS:

- ABSTRACT
- [Application](#Application)
  - [mychat](#mychat)
- Kubernetes
- <번외> Google Kubernetes Engine

## ABSTRACT:

- Socket.io를 이용해 간단한 채팅 웹 어플리케이션을 만들어 보았습니다. 사용자들의 채팅 기록과 이름, 시간은 MySql DB에 저장됩니다. 프론트와 백엔드는 하나의 이미지로 구현하였고 DB도 하나의 이미지로 구현하였습니다. 각각의 이미지는 1개의 StatefulSet과 Service를 가지게 구현했습니다.
- 이 프로젝트는 Minikube 위에서의 실행을 가정하고 진행되었으며, 다른 Kubernetes engine을 사용 시 제대로 실행이 되지 않을 수 있습니다.
- 소스 코드는 다음 링크에서 확인할 수 있습니다. [LINK]( https://github.com/phobyjun/dcp-2019-fall/tree/master/assignment4 )

## Application

### mychat

- mychat image Link: [LINK]( https://hub.docker.com/repository/docker/yunjun2/mychat ), 1.1.4 version을 기준으로 설명합니다.

- 폴더 구조는 다음과 같습니다.

  ```c
  mychat
  |___node_modules
  |	|	...
  |	|	...
  |
  |___public
  |	|___css
  |		|	chat.css
  |
  |___views
  |	|	index.ejs
  |	
  |	.dockerignore
  |	Dockerfile
  |	index.js
  |	package.json
  |	package-lock.json
  ```

- 구성 요소의 설명은 다음과 같습니다.

  - node_modules: 필요한 node.js이 들어있는 폴더입니다. local에서 어플리케이션 구현 시 필요한 것으로 .dockerignore에서 build 시 제외합니다.

  - public/css/chat.css: 프론트엔드 구현 시 사용되는 css 파일입니다.

    ```css
    @import url('https://fonts.googleapis.com/css?family=Nanum+Gothic&display=swap');
    
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    body {
        font-family: 'Nanum Gothic', sans-serif;
        font: 13px;
    }
    form {
        background: #fff;
        padding: 3px;
        position: fixed;
        bottom: 0;
        width: 100%;
        border-color: #000;
        border-top-style: solid;
        border-top-width: 1px;
    }
    form input {
        border-style: solid;
        border-width: 1px;
        padding: 10px;
        width: 85%;
        margin-right: .5%;
    }
    form button {
        width: 10%;
        background: #60a3bc;
        border: none;
        padding: 10px;
        margin-left: 2%;
        transition: all 0.4s ease 0s;
    }
    form button:hover {
        background: #434343;
        -webkit-box-shadow: 0px 5px 40px -10px rgba(0,0,0,0.57);
        -moz-box-shadow: 0px 5px 40px -10px rgba(0,0,0,0.57);
        box-shadow: 5px 40px -10px rgba(0,0,0,0.57);
        transition: all 0.4s ease 0s;
        color: #fff;
    }
    #messages {
        list-style-type: none;
        margin: 0;
        padding: 0;
    }
    #messages li {
        padding: 5px 10px;
    }
    #messages li:nth-child(odd) {
        background: #eee;
    }
    ```

  - views/index.ejs: express 모듈을 사용해 html을 렌더링 하는 파일이며 index.js에서 index.ejs를 불러와 렌더링 및 통신을 수행합니다.

    ```ejs
    <!DOCTYPE html>
    <html>
    <head>
        <title>MyChat</title>
        <link rel="stylesheet" href="/css/chat.css"/>
        <script src="../../socket.io/socket.io.js"></script>
        <script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
    </head>
    <body>
        <ul id="messages"></ul>
        <div id="bottom"/>
        <form action="/" method="POST" id="chatForm">
          <input id="text" autocomplete="off" autofocus="on" placeholder="여기에 텍스트 입력"/>
          <button>보내기</button>
        </form>
        <script>
                var height = document.getElementById('chatForm').offsetHeight;
                document.getElementById('bottom').style.height = height + "px";
                var socket = io.connect();
    
                $('form').submit(function(e){
                    e.preventDefault();
                    socket.emit('chat_message', $('#text').val());
                    $('#text').val('');
                    return false;
                });
    
                socket.on('chat_message', function(msg){
                    $('#messages').append($('<li>').html(msg));
                    document.getElementById('bottom').scrollIntoView();
                });
    
                socket.on('is_online', function(username) {
                    $('#messages').append($('<li>').html(username));
                    document.getElementById('bottom').scrollIntoView();
                });
    
                var username = prompt('이름을 입력하세요');
                socket.emit('username', username);
        </script>
    </body>
    </html>
    ```

  - .dockerignore: image build 시 제외할 파일을 설정합니다.

    ```
    node_modules
    npm-debug.log
    ```

  - Dockerfile: image를 build하기 위한 스크립트가 작성된 파일입니다.

    ```Dockerfile
    FROM node:10
    MAINTAINER Junseok, Yoon<phobyjun@khu.ac.kr>
    
    WORKDIR /usr/src/app
    COPY package*.json ./
    
    RUN npm install
    
    COPY . .
    
    EXPOSE 8080
    
    CMD ["node", "index.js"]
    
    ```

  - index.js: MySql과의 통신, 서버, 통신을 위한 js 파일입니다.

    ```js
    const express = require('express');
    const router = express.Router();
    const mysql = require('mysql');
    const app = express();
    const http = require('http').Server(app);
    const io = require('socket.io')(http);
    const path = require('path');
    
    app.use(express.static(path.join(__dirname, 'public')));
    app.get('/', function(req, res) {
        res.render('index.ejs');
    });
    
    // MySql
    var connection = mysql.createConnection({
        host: 'mydb',
        port: '3306',
        user: 'root',
        password: 'root',
        database: 'messages'
    });
    
    // Current Time
    var moment = require('moment');
    require('moment-timezone');
    moment.tz.setDefault("Asia/Seoul");
    
    io.sockets.on('connection', function(socket) {
        socket.on('username', function(username) {
            socket.username = username;
            io.emit('is_online', '🔵 <i>' + socket.username + '님이 들어왔습니다.</i>');
        });
    
        socket.on('disconnect', function(username) {
            io.emit('is_online', '🔴 <i>' + socket.username + '님이 나갔습니다.</i>');
        });
    
        socket.on('chat_message', function(message) {
            io.emit('chat_message', '<strong>' + socket.username + '</strong>: ' + message);
            var query = 'INSERT INTO messages VALUES ("' + socket.username + '", "' + message + '", "' + moment().format('HH:mm:ss') + '");'
            connection.query(query, function(err, rows, fields) {
                    if (!err) {
                        console.log('The solution is: ', rows);
                    }
                    else {
                        console.log('Error while performing Query.', err);
                    }
            });
        });
    });
    
    const server = http.listen(8080, '0.0.0.0', function() {
        console.log('listening on localhost:8080');
    });
    ```

- 