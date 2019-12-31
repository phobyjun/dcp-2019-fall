# Data Center Programming Mid-term Exam

## Lecture 2. Cloud Computing & Infrastructure

Goals of Reading Articles

- Cloud computing이 무엇인가?
- Utility clouding과 cloud computing economics의 개념이 무엇인가?
- Cloud computing의 components와 service model이 무엇인가?

**What is Cloud Computing**

Cloud computing is:

> a model for enabling ubiquitous, convenient, on-demand network access to a shared pool of configurable computing resources that can be rapidly provisioned and released with minimal management effort or service provider interaction

**Defining Cloud Computing**

Cloud computing refer to both

- The applications delivered as services over the Internet
- The hardware and systems software in the data centers that provide those service

The data center hardware & software is what we call a Cloud

From a hardware provisioning and pricing point o view, three aspects are new:

- The appearance of infinite computing resources available on demand
- The elimination of an up-front commitment by cloud users
- The ability to pay for use of computing resources on a short-term basis as needed

**Public clouds vs Private data centers**

| Advantage                                                    | Public Cloud | Data Center             |
| ------------------------------------------------------------ | ------------ | ----------------------- |
| Appearance of infinite computing resources on demand         | Yes          | No                      |
| Elimination of an up-front commitment by Cloud users         | Yes          | No                      |
| Ability to pay for use of computing resources on a short-term basis as needed | Yes          | No                      |
| Economies of scale due to very large data centers            | Yes          | Usually not             |
| Higher utilization by multiplexing of workloads from different organizations | Yes          | Depends on company size |
| Simplify operation and increase utilization via resource virtualization | Yes          | No                      |

**Software as a Service(SaaS)**

- Gmail, Google Doces, YouTube, Facebook, Dropbox, Spotify, etc.
- cloud infrastructure 위에서 돌아가는 제공자의 어플리케이션을 사용하게 해준다.
- 어플리케이션은 다양한 클라이언트들에서 사용 가능하다. 이는 웹 브라우져 또는 program interface와 같은 thin client를 통해 가능하다.
- 사용자는 cloud infrastructure를 관리하거나 통제하지 않는다.

**Platform as a Service(PaaS)**

- Google Apps Engine, etc.
- 제공자로부터 지원되는 도구, 프로그래밍 언어, 라이브러리, 서비스들을 사용해 사용자로 하여금 만들어지거나 습득된 어플리케이션을 cloud infrastructure에 올릴수 있게 해준다.
- 사용자는 cloud infrastructure를 관리하거나 통제하지 않는다.
- 사용자는 어플리케이션-호스팅 환경을 위해 만들어진 머플리케이션과 가능한 설정들을 통제할 수 있다.

**Infrastructure as as Service(Iaas)**

- Amazon EC2, Amazon S3, Windows Azure
- 사용자에게 근본적인 computing resources를 제공한다. 
- 사용자는 cloud infrastructure를 관리하고 통제할 수 있다.

**Deployment Models**

- Private cloud
- Community cloud
- Public cloud
- Hybrid cloud

**Private Cloud**

하나의 조직에 의해 만들어지고, 다수의 사용자들에게 제공되는 cloud infrastructure. 조직에 의해 소유되고 관리된다.

**Community Cloud**

같은 문제를 가진 여러 조직들에 소속되어있는 사용자의 특정 커뮤니티에 의해 사용되기 위해 제공되는 cloud infrastructure. 하나 또는 하나 이상의 조직들에 의해 소유되고 관리된다.

**Public Cloud**

대중들에 의해 사용되기 위해 제공되는 cloud infrastructure. 

**Hybrid Cloud**

하나 이상의 public cloud와 하나 이상이 private cloud가 서로 연결되어 작동하는 cloud infrastructure.

## Lecture 3. Infrastructure & Virtualization

**On-Premises(On-prem)**

Refers to private data centers that companies house in their own facilities and maintain themselves.

On-prem infrastructure can be used to run private clouds, in which compute resources are virtualized in much the same way as those of public clouds.

![1571834662932](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571834662932.png)

![1571834722483](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571834722483.png)

**Server**

- Central processing unit(CPU)
- Memory
- Storage

**Web Server**

- 클라이언트를 에게 웹 페이지를 저장, 처리, 전달한다.
- 클라이언트와 서버 사이의 통신은 HTTP를 사용한다.
- 페이지는 서의 대부분이 이미지, 스타일 시트, 스크립트를 포함한 HTML 문서로서 전달된다.

**Database Server**

- 다른 컴퓨터 프로그램 또는 다른 컴퓨터에게 데이터베이스 서비스를 제공하는 데이터베이스 어플리케이션을 가지는 서버.
- SQL server
  - SQL 데이터베이스 안의 데이터는 연관 데이터의 모음으로서 테이블에 저장된다.
  - 행(columns)과 열(rows)을 포함한다.
  - example. MySQL, Microsoft SQL server, etc.
- NoSQL server
  - Database provides a mechanism for storage and retrieval of
    data modeled in means other than the tabular relations
    used in relational databases.

**Operation System(OS)**

- Linux
- Linux Kernel

**Middleware**

- os에서 가능한 수준을 넘어선 소프트웨어 어플리케이션을 제공하는 컴퓨터 소프트웨어

**IaC(Infrastructure as Code)**

- 표준 operating 절차와 manual processes 대신 소스 코드의 사용을 통해 IT 인프라를 관리하는 접근법
- 서버, 데이터베이스, 네트워크, 다른 인프라를 소프트웨어로서 다룸
- 코드(code)는 사용자로 하여금 인프라 components를 빠르고 즉각적으로 만들고 설정할 수 있게 도와줌
- 코드(스크립트)로 하여금 인프라 구축, 관리 자동화

**Benefits of Infrastructure as Code**

- Speed and simplicity
- Configuration consistency
- Minimization of risk
- Increased efficiency in software development
- Cost savings

![1571836806860](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571836806860.png)

![1571836818697](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571836818697.png)

![1571836825172](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571836825172.png)

## Lecture 4. Virtualization & Container Technology

![1571837672626](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571837672626.png)

![1571837691621](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571837691621.png)

**Hypervisor Vitualization**

![1571837935768](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571837935768.png)

**Problems of Virtual Machine**

- 각각의 VM은 10기가바이트를 웃도는 바이너리 파일들과 라이브러리, 어플리케이션이 포함된 os의 전체 복사본을 포함한다.
- 부팅 속도가 느리다.

![1571838704461](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571838704461.png)

**Container**

- Container는 어플리케이션 레이어에서 추상화된다.
- 다수의 container는 다른 container들과 os 커널을 공유한다.
- os 수준에서 가상화된다.
- lightweight, faster, use a fraction of the memory

## Lecture 5. Docker Introduction

**What is Docker**

- Open platform
- 인프라에서 어플리케이션과 분리됨.
- 어플리케이션을 관리하는 방법처럼 인프라를 관리할 수 있다.
- 코드 작성과 running 사이의 딜레이를 줄일 수 있다.

**Why use Docker?**

Operation environments independent Immutable Infrastructure using 'Dockerfile'

- Flexible
- Lightweight
- Interchangeable

![1571841662134](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571841662134.png)

![1571841747998](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571841747998.png)

![Docker cheat sheet by RebelLabs](https://jrebel.com/wp-content/uploads/image-blog-docker-cheatsheet.png)

## Lecture 6. Docker Overview

**Docker Engine**

- 컨테이너를 관리하는 지속적 처리
- 도커의 핵심 작업을 수행함
  - Building, running, distributing containers
- background에서 작동함

![1571844081599](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571844081599.png)

**Docker Daemon**

- Listen for Docker API requests and manages Docker objects

**Docker Client**

- 도커 엔진에게 명령어를 주기 위해 CLI가 사용된다.
- 웹 상의 클라이언트-서버 구조와 비슷하다.
- 도커 클라이언트는 도커 엔진에게 컨테이너와 컨테이너화의 작업을 수행하라고 말한다.
- 도커 커맨드는 도커 API를 사용한다.
- 도커 클라이언트는 하나 이상의 데몬과 통신한다.

![1571844584153](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571844584153.png)

**Docker Registries**

- 도커 이미지 저장
- Public registry
  - 누구나 사용 가능
  - Docker hub & Docker cloud
- Private registry
  - Docker Trusted Registry(DTR)

![1571846036265](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571846036265.png)

**Namespaces**

- 컨테이너를 부르는 독립된 workspace를 제공하기 위해 네임스페이스라는 기술을 사용한다.
- 컨테이너를 run할 때, 도커는 컨테이너를 위한 네임스페이스의 집합을 만든다.
- 이 네임스페이스들은 독립적인 레이어를 제공한다.

**Control Groups (cgroups)**

- 자원 관리에 대한 의무
- 어플리케이션에 특정 자원 집합을 제한
- 도커 엔진이 사용 가능한 하드웨어 자원을 컨테이너에게 공유하게 한다.

## Lecture 7. Docker Hub & Dockerfile

**Dockerfile**

![KakaoTalk_20191024_012446936](C:\Users\Junseok Yoon\Desktop\KakaoTalk_20191024_012446936.png)

![KakaoTalk_20191024_012450469](C:\Users\Junseok Yoon\Desktop\KakaoTalk_20191024_012450469.png)

- 주어진 이미지를 빌드하기 위해 필요한 모든 커맨드들을 순차적으로 포함하고 있는 텍스트 파일
- 도커는 도커파일로부터 명령어들을 읽어옴으로서 자동으로 이미지를 빌드한다.
- 도커 이미지는 도커파일 명령어를 나타내는 읽기-전용 레이어를 포함한다.

![1571848157938](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571848157938.png)

![1571848197177](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571848197177.png)

![1571848209068](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571848209068.png)

## Lecture 8. Build and Push Images

**nginx server**

```dockerfile
FROM ubuntu:14.04
MAINTAINER Dr.Sungwon "drsungwon@khu.ac.kr"
RUN apt-get update
RUN apt-get install -y nginx
RUN?echo "this is a ubuntu container"
WORKDIR /etc/nginx
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
```

**python server**

```dockerfile
FROM python:latest
MAINTAINER Dr.Sungwon "drsungwon@khu.ac.kr"
COPY ./app
RUN apt-get update
RUN echo "this is a python web server container"
CMD ["python", "/app/webserver.py"]
EXPOSE 9000
```

**javascript server**

```dockerfile
FROM node:10
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]
```

## Lecture 9. Docker Compose

**Docker Services**

![1571851357834](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571851357834.png)

- a service only runs one image, but it codifies the way that image runs

**Docker Compose**

- 멀티-컨테이너 도커 어플리케이션을 실행하고 정의하기 위한 도구
- 어플리케이션 서비스에 YAML 파일을 사용함
  - docker-compose.yml

- Start all services

  ​	docker-compose up

- Stop all services

  ​	docker-compose down

- Scale up selected services when required

  ​	docker-compose scale

**How to create docker compose files**

- 작업 공간 생성
- docker-compose.yml 파일 생성
- TAB 사용 불가

![1571851959227](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571851959227.png)

**Create modified services using Port Mapping**

- NAT/PAT
  - NAT: Network Address Translation
  - PAT: Port Address Translation

![1571852097755](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571852097755.png)

**YAML: YAML Ain't Markup Language**

- 사용자 친화적인 데이터 직렬화 언어
- 들여쓰기 기반 scoping
- Use Cases
  - Configuration files
  - Log files
  - Cross-language data sharing
  - Debugging of complex data structures

## Lecture 10. Docker Storage

- 컨테이너 안에서 파일을 저장할 때의 문제
- 호스트 머신에 파일 저장
  - volumes
  - bind mounts
  - tmpfs mount
  - named pipe

![1571855732048](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571855732048.png)

**Volumes**

- 도커에 의해 관리되는 호스트 파일시스템의 도커 영역에 저장된다
  - Linux: /var/lib/docker/voulmes
  - Non-Docker 프로세스는 파일 시스템의 도커 영역을 수정할 수 없음
- 호스트 머신 위의 도커의 스토리지 디렉터리 안에서 새로운 디렉터리 만들어짐
  - 도커는 이 새로운 디렉터리의 content들을 관리함
- Volume Characteristics:
  - 만들어진 볼륨은 다수의 컨테이너에서 동시에 마운트될 수 있음
  - 볼륨을 사용하는 컨테이너가 동작하고있지 않을 때, 볼륨은 여전히 도커에서 사용 가능하며 자동으로 지워지지 않음
  - 볼륨 drivers를 사용해 원격으로 호스트 또는 클라우드에 데이터 저장 가능함
- Volume management commands:
  - docker volume create
  - docker volume prune

**Bind Mounts**

- 호스트 시스템의 어느 곳이든지 저장할 수 있음
  - 심지어 중요한 시스템 파일 또는 디렉터리일수도 있음
  - Non-Docker 프로세스는 이 영역을 어느 때든지 수정 가능함
- 호스트 머신 위의 파일 또는 디렉터리가 컨테이너 안으로 마운트됨
- 도커 CLI 커맨드로 bind mount를 직접적으로 관리할 수 없음

## Lecture 11. Docker Machine

**What is Docker Machine?**

- virtual 호스트 위의 도커 엔진을 설치하고 docker-machine 커맨드로 호스트를 관리하게 해주기 위한 도구

![1571858302031](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858302031.png)

![1571858467171](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858467171.png)

![1571858401485](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858401485.png)

![1571858405973](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858405973.png)

![1571858409528](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858409528.png)

![1571858413224](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858413224.png)

![1571858418290](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858418290.png)

![1571858423385](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858423385.png)

![1571858426862](C:\Users\Junseok Yoon\AppData\Roaming\Typora\typora-user-images\1571858426862.png)

## CI/CD & DevOps

**DevOps 개념**

- Development와 Operation의 합성어
- SW 개발자들과 IT 종사자들 사이의 의사소통, 협업, 융합을 강조한 개발방법론
- 개발/운영/품질관리 부서 간 통합, 커뮤니케이션, 협업을 위한 일련의 방식
- 지속적 환경(지속적 평가 지속적 delivery와 배포, 지속적 운영, 지속적 통합 및 테스트)이 유지되는 cycle

**CI(Continuous Integration)**

- 여러 명으로 구성된 팀이 개발(수정)한 소프트웨어를 지속적으로 통합하고 QC(품질통제)하는 애자일 기법
- 자동화된 빌드와 테스트를 통하여 통합 에러 조기 검증으로 단위코드의 품질을 향상("integration hell" 방지)

**CD(Continuous Delivery)**

- 변경된 요구사항에 대한 개발/통합/배포/테스트/릴리즈를 자동화하여 SW의 개발과 운영을 통합하는 DevOps를 지원하는 SW의 연속적인 배포 출시