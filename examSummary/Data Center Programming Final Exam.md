# Data Center Programming Final Exam

## Docker in Docker

### What is Docker in Docker

- Docker in Docker, a.k.a DinD
- 일반적으로 Docker에서는 권장하지 않음
- 비록 권장하지는 않지만 본격적으로 사용된 케이스가 있음.
- DinD는 오픈 소스 프로젝트임
  - 소프트웨어 컨테이너 안에서 어플리케이션의 deployment를 자동화함.
  - OS 수준의 가상화를 자동화하고 추상화하는 추가적인 layer를 더해줌.
  - Linux, Mac OS, Windows에서 지원함

![1576496006599](img/1576496006599.png)

### DinD docker-compose.yml

```yaml
version: "3.7"
services:
	manager:
		container_name: manager
		image: docker:18.05.0-ce-dind
		privileged: true
		tty true
		ports:
		- 8000:80
		- 9000:9000
```

## Docker Swarm

![1576497702345](img/1576497702345.png)

![1576497710476](img/1576497710476.png)

### Container Orchestration

- Container orchestration: 디플로이먼트, 매니지먼트, 스케일링, 네트워킹 그리고 컨테이너 기반의 어플리케이션의 유효성을 자동화하는 과정
- 일 과정을 자동화함으로써 팀의 업무 능력을 향상시킬 수 있다.
  - 매뉴얼하게 수행했기 떄문에 어플리케이션의 dployment는 과거에는 매우 어려웠다.
- 컨테이너 오케스트레이션은 workload를 단순화한다.
  - 사용자들은 기계적 작업을 처리하기 싫어한다. (코드 치는거)
  - 동시에 더 많은 컨테이너 그룹들과 통신한다.
  - 컨테이너 레지스터를 계획하고 구현한다.
  - 네트워크, 스토리지, 보안 그리고 다른 서비스들을 제공한다.

![1576498776039](img/1576498776039.png)

### Swarm Basic

- Docker Swarm은 컨테이너 오케스트레이션을 위한 도구이다.
  - 다수의 docker 컨테이너를 하나의 서비스로서 관리하고 통제한다.
- Swarm은 Docker에서 실행되고 cluster 안에 있는 머신들의 그룹임
- Swarm은 swarm mode로 실행되고 마치 그것처럼 행동하는 다수의 Docker hosts들을 포함한다.
  - manager: member(worker)들과 대표들을 관리함
  - worker: swarm 서비스들을 실행함

![1576499693147](img/1576499693147.png)

### Service over Docker Swarm

![1576499709928](img/1576499709928.png)

- Task: swarm manager로부터 관리되고 swarm 서비스의 한 부분인 컨테이너를 실행시키는 것
- Node: swarm에 속해있는 Docker engine의 객체
  - Manager nodes: task라고 불리는 일들의 집합들을 worker 노드들에게 배분해줌
  - Worker nodes: manager node들로부터 배분받은 task들을 실행시킴

### Docker Swarm Example

```dockerfile
// create docker machines
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" manager
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" worker1
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" worker2

// Define Manager Node
docker-machine ssh {manager name} docker swarm init --advertise-addr {manager ip}

// Define Worker Nodes
docker-machine ssh {worker name} docker swarm join --token <token> <manager ip>:2377
```

### Docker Stack

- Swarm은 전의 작업처럼 개별의 컨테이너들을 만들지 않음
  - 대신, 모든 Swarm 작업들은 서비스들처럼 계획됨
  - 즉, Swarm이 자동으로 관리하고 유지하는 네트워킹 기능이 추가된 확장 가능한 컨테이너들의 그룹임.
- 모든 Swarm 객체들은 stack 파일이라고 불리는 것 안에서 묘사될 수 있고 그래야만 한다.
  - 이 YAML 파일은 Swarm app의 기능과 설정들을 모두 묘사한다. 그리고 Swarm 환경에서 쉽게 만들어지고 없어질 수 있다.

### Docker Stack Example

**Create docker-compose.yml**

```yaml
version: "3.7"
services:
	webserver:
		image: nginx:latest
		deploy:
			replicas: 4
			placement:
				comstraints: [node.role != manager]
		ports:
		- 8080:80
```

```
// Copy yml file into manager node
docker-machine scp docker-compose.yml manager:~

// Deploy application stack through manager node
docker-machine ssh manager docker stack deploy -c docker-compose.yml helloswarm
```

### Auto Load Balancing

![1576500769652](img/1576500769652.png)

## Docker Labels

### What are Docker Object Labels?

- Docker objects 의 메타데이터에 접근하는 방법
- objects는 다음의 예가 있다:
  - Images
  - Containers
  - Local daemons
  - Volumes
  - Networks
  - Swarm nodes
  - Swarm services

### 왜 Labels를 써야하나?

- Image를 조직화할 수 있음
- 라이센스 정보를 기록할 수 있음
- 컨테이너, 볼륨, 네트워크 사이의 관계를 설명할 수 있음

### Label Keys & Values

- Label은 key-value 쌍이고 문자열로 저장됨
- 하나의 object에 다수의 label들을 설정할 수 있음
- 각각의 key-value 쌍은 object 안에서 유일함
- 만약 다수의 value에 같은 key값이 있으면, 가장 최근에 write된 값이 이전 value에 덮어씌여짐

### Key Format Recommendations

- Label의 key는 key-value 쌍의 왼쪽에 존재함
- Key는 알파벳 문자열이고 점(.)과 하이픈(-)을 포함할 수 있음.

## Kubernetes Overview

### What is Kubernetes

- 컨테이너화된 어플리케이션의 deployment, scailing, management를 자동화하기 위한 오픈 소스 시스템.

### What Kubernetes Manages

- 컨테이너들의 클러스터
- 어플리케이션의 deployment를 위한 도구를 제공
- 필요에 따라 어플리케이션을 확장
- 존재하는 컨테이너화된 어플리케이션들의 변화를 관리
- 컨테이너 아래에 있는 하드웨어의 사용을 최적화하게 도와준다.
- 어플리케이션 컴포넌트가 시스템이 필요로 할 때 재시작하고 움직이게 한다.

## Microservices and Katakoda

### Monolithic vs Microservice

![1576506191084](img/1576506191084.png)

#### Monolithic Applcation

![1576506204714](img/1576506204714.png)

- e-commerce 어플리케이션을 빌드하는 경우를 생각해보면
  - 소비자로부터 주문을 받는다
  - 인벤토리와 사용 가능한 크레딧을 검증한다
  - 물건을 보넨다
- StoreFrontUI를 포함한 다수의 기능들을 필요로 한다.
- StoreFrontUI는 백엔드 서비스, 크레딧 확인, 인벤토리 유지, 주문 배송과 함께 user 인터페이스를 구현한다. 

어플리케이션이 빌드 된후 크기가 커지면 어떻게 될까?

#### Microservice Application

![1576506568072](img/1576506568072.png)

- 확장 가능성(Scalability)

  - 각각의 마이크로서비스는 다른 마이크로서비스들의 영향 없이 독립적으로 확장할 수 있어야 한다.

- 유효성(Availability)

  - 서비스가 실행 실패해도 다른 마이크로서비스들이 사용 가능해야 하고,
  - 실행 실패된 마이크로서비스는 빠르게 복구될수 있다.

- 실패 관용(Fault Tolerance)

  - 실패해도 다른 서비스들은 스무스하게 실행된다. 그러므로 오직 어플리케이션의 작은 부분이 영향을 받아도 전체 어플리케이션은 영향을 받지 않는다.

- 민첩성(Agility)

  - 빠른 deployment 방식이 끊임없이 변화하는 비즈니스 요구사항을 위한 아키텍쳐에 적합하게 한다. 매우 민첩한 환경을 의미한다.

- Polyglot Persistence

  - use case에 적합한 도구를 선택한다.
  - 어플리케이션 스택은 특정 데이터베이스에 종속되지 않는다.

  ![1576507667002](img/1576507667002.png)

- 유지 보수성(Maintainaiblity)

  - 줄어든 코드의 양이 유지 보수하기 쉽게 만든다.

왜 마이크로서비스 아키텍쳐를 사용하는가?

![1576507964587](img/1576507964587.png)

![1576507976368](img/1576507976368.png)

## Nodes and Pods

### Container

![1576508044970](img/1576508044970.png)

### Pods

![1576508051764](img/1576508051764.png)

- Pod은 Kubernetes의 기본적인 빌드 블록이다. - 가장 작고 가장 단순한 Kubernetes object 모델의 유닛이다.
- Pod은 Cluster에서 실행중인 프로세스들을 나타낸다.
- Pod은 어플리케이션의 컨테이너, 스토리지 자원, 유일한 네트워크 IP, 컨테이너가 실행해야 할 방법에 대한 옵션을 캡슐화한다.

### Pods Networking

- 각각의 Pod은 유일한 IP 주소를 할당받는다. 하나의 Pod 안의 모든 컨테이너는 IP 주소, 네트워크 포트를 포함하는 네트워크 네임스페이스를 공유한다. 
- Pod 안의 컨테이너들은 localhost를 사용해 다른 컨테이너들과 통신할 수 있다.
- Pod 안의 컨테이너들이 Pod 외부의 객체와 통신할 때, 포트와 같은 공유된 네트워크 자원을 사용해야 한다.

### Nodes

![1576508342942](img/1576508342942.png)

- Cluster에 종속된 VM 또는 물리적 머신과 같은 Kubernetes 안의 worker 머신이다.
- 각각의 node는 pod들을 실행하기 위해 필요하고 master 컴포넌트에 의해 관리되는 서비스들을 포함한다.
- Node 위의 서비스들은 컨테이너 런타임, kubelet, kube-proxy를 포함한다.

### Clusters

![1576508859119](img/1576508859119.png)

![1576508870275](img/1576508870275.png)

- 쿠버네티스에 의해 관리되는 컨테이너화된 어플리케이션들을 실행시키는 node들의 집합
- 이 예제에서 대부분의 쿠버네티스 디플로이먼트, cluster의 node들은 public 인터넷에 속해있지 않다.
- Cluster 마스터는 모든 nodes들의 실행을 결정해야 한다:
  - 작업 스케쥴링
  - 작업의 라이프사이클, 스케일링, 업그레이드를 관리

### Deployment

![1576509126474](img/1576509126474.png)

- 프로그래머가 Deployment의 고안된 상태를 나타낸다.
- Deployment Controller는 현재 상태를 고안된 상태로 바꿀 수 있다.
- Example:
  - kubectl create deployment --help

### Ingress

![1576509942881](img/1576509942881.png)

- Cluster의 서비스들로의 http와 같은 외부 접근을 관리하는 API 객체

- Ingress는 load balancing, SSL termination, name-based virtual hosting을 제공할 수 있다.

- Expose HTTP Service to External Network Example:

  ```
  kubectl expose deployment first-deployment --port=80 --type=NodePort --name=my-services
  ```

## Controllers

### What is the Controller?

-  Take case of routine tasks to ensure the desired state of the cluster matches the observed state.

- Pod의 status를 갱신하고, Pod을 spec에 정의된 상태로 지속적으로 변화시키는 주체

- Pod Concept

  ![1576511396259](img/1576511396259.png)

### Pods Selection using Label in Service

- 쿠버네티스 Pod은 영원하지 않다. Pod이 만들어지고 없어질 때, 다시 부활하지 않는다. 만약 어플리켕션을 실행하기 위해 Deployment를 사용하면, 동적으로 Pod들을 만들어 없앨 수 있다.
- 각각의 Pod들은 자신만의 IP 주소를 가지지만, Depolyment에서 동시에 실행되고 있는 Pod들의 집합은 나중에 실행되고 있는 Pod들의 집합과 다르지 않다.

![1576512121370](img/1576512121370.png)

### ReplicaSet

- ReplicaSet의 목적
  - 어느 특정한 시간에 실행되는 stable한 replica pod들의 집합을 유지하기 위해
  - 구분되는 Pod들의 특정한 숫자의 유효성을 보장하기 위해
- Pod을 복제 생성하고, 복제된 Pod의 개수를 지속적으로 유지하는 Controller
- ReplicaSet은 다음과 같이 정의된다.
  - 얻을 수 있는 Pod들을 식별하는 방법을 지정하는 selector
  - 얼마나 많은 수의 Pod들이 유지되어야 하는지 결정하는 replica의 개수
  - replica 수의 기준에 만족하도록 만들어야 하는 새로운 Pod들의 데이터를 지정하는 pod template.
- ReplicaSet은 정해진 숫자에 도달하기 위해 Pod들을 만들고 삭제한다.
- ReplicaSet이 새로운 Pod들을 만들기를 필요로 할 때, Pod template를 사용한다.

### Set-based Requirement

![1576513498765](img/1576513498765.png)

### Equality-based Requirement

![1576513520170](img/1576513520170.png)

### Service Distribution in ReplicaSet

![1576513565767](img/1576513565767.png)

![1576513576708](img/1576513576708.png)

![1576513601906](img/1576513601906.png)

![1576513618130](img/1576513618130.png)

![1576513623917](img/1576513623917.png)

## Kubernetes Objects & kubectl Commands

### What is Kubernetes Objects

- Pods
- Namespaces
- ReplicationController
- DeploymentContoller
- StatefulSets
- DaemonSets
- Services
- ConfigMaps
- Volumes

### 오브젝트

쿠버네티스를 이해하기 위해서 가장 중요한 부분이 오브젝트이다. 가장 기본적인 구성단위가 되는 기본 오브젝트(Basic object)와, 이 기본 오브젝트(Basic object) 를 생성하고 관리하는 추가적인 기능을 가진 컨트롤러(Controller) 로 이루어진다. 그리고 이러한 오브젝트의 스펙(설정)이외에 추가정보인 메타 정보들로 구성이 된다고 보면 된다. 

### 오브젝트 스펙 (Object Spec)

오브젝트들은 모두 오브젝트의 특성 (설정정보)을 기술한 오브젝트 스펙 (Object Spec)으로 정의가 되고, 커맨드 라인을 통해서 오브젝트 생성시 인자로 전달하여 정의를 하거나 또는 yaml이나 json 파일로 스펙을 정의할 수 있다. 

### 기본 오브젝트 (Basic Object)

쿠버네티스에 의해서 배포 및 관리되는 가장 기본적인 오브젝트는 컨테이너화되어 배포되는 애플리케이션의 워크로드를 기술하는 오브젝트로 Pod,Service,Volume,Namespace 4가지가 있다. 

간단하게 설명 하자면 Pod는 컨테이너화된 애플리케이션, Volume은 디스크, Service는 로드밸런서 그리고 Namespace는 패키지명 정도로 생각하면 된다. 그러면 각각을 자세하게 살펴보도록 하자.

### Why Kubernetes Objects?

- Cluster의 상태를 표현하기 위해
  - 실행 중인 컨테이너화된 어플리케이션들
  - 이 어플리케이션에서 사용 가능한 자원
  - restart 정책, 업그레이드, 실패 관용과 같은 어떻게 어플리케이션이 행동해야 할지에 관한 정책들

### Why Kubernetes API?

- Kubernetes objects와 작업하기 위해
  - create, modify, delete
- CLI에서 kubectl을 사용할 때

### Spec & Status

- Spec
  - object의 설정된 상태를 묘사함
  - object가 원하는 특성
- Status
  - object의 실제 상태를 묘사함
  - Kubernetes 시스템에 의해 제공되고 업데이트됨
  - Kubernetes Control Plan이 object의 실제 상태를 제공되는 설정된 상태와 맞게 관리함

### Use Cases of Spec & Status

![1576514730435](img/1576514730435.png)

![1576514742721](img/1576514742721.png)

### Describing a Kubernetes Object

![1576514770356](img/1576514770356.png)

![1576514794223](img/1576514794223.png)

## Services

- Kubernetes의 Service는 Pod들의 논리적 집합과 이들을 접근하는 policy를 정의한다.
- Service는 모든 Kubernetes object처럼 YAML 또는 JSON을 사용해 정의된다.
- Service가 대상으로 하는 Pod들의 집합은 주로 LabelSelector에 의해 결정된다.

![1576515916383](img/1576515916383.png)

![1576515924270](img/1576515924270.png)

![1576515927425](img/1576515927425.png)

- 비록 각각의 Pod들이 고유한 IP 주소를 가지고 있어도, 이 IP 주소는 Service 없이는 cluster 외부로 노출될 수 없다.
- Service들은 이것을 가능하게 한다.
- Service들은 ServiceSpec의 정의된 type을 통해 다른 방법들로 외부에 노출시킬 수 있다.

### ServiceSpec

- ClusterIP service
  - 기본적인 쿠버네티스 서비스이다.
  - cluster 내부에서 다른 cluster 내부의 어플리케이션에 접근하도록 해주는 service이다.
  - 외부 접근은 없다.
- NodePort service
  - 특정 서비스에 직접 외부 트래픽을 얻는 가장 원시적인 방법이다.
  - 이름에서 알 수 있듯이 모든 포트에서 특정 포트를 열고 이 포트로 전송된 모든 트래픽이 서비스로 전달된다.
- LoadBalancer service
  - 인터넷에 서비스를 노출시키는 기본적인 방법이다.
- Ingress
  - 실제로는 서비스의 type이 아니다.
  - 여러 서비스들의 앞에 있으면서 스마트 라우터 또는 클러스터의 진입점 역할을 한다.

![1576517177934](img/1576517177934.png)

## Images and Registries

### Images

- Docker image와 같다.
- Kubernetes pod에서 사용하기 전에 registry에 push해야 한다.
- 컨테이너의 이미지 속성 docker 명령과 동일한 구문을 지원합니다. 개인 레지스트리와 태그를 포함해서.

### Updating Images

- 기본적인 pull policy는 이미 존재하면 image를 pull하지 않는 **IfNotPresent**이다.

![1576517930274](img/1576517930274.png)

### Why You Should Avoid :latest tag

- production에서 컨테이너를 deploy할 때
  - 실행 중인 이미지의 버젼을 따라가기 어렵다
  - 롤-백하기 더욱 어렵다

## Scale and Rolling Updates

### Scaling an Application

- 트래픽이 몰릴 때, 유저에 요구에 따라 어플리케이션을 scale하는것이 필요하다.
- Scaling은 Deployment의 replicas의 숫자의 변화에 의해 이루어진다.

![1576518563358](img/1576518563358.png)

### Rolling Updates

- Rolling updates를 사용하면 Pod 인스턴스를 새 인스턴스로 업데이트하여 중단 시간 없이 deployment 업데이트를 수행할 수 있다.
- 새로운 Pod은 사용 가능한 자원들이 있는 node들에서 예약된다.
- Update는 버젼으로 기록된다.
- 어떤 Deployment도 이전 버젼으로 변환될 수 있다.

![1576519468196](img/1576519468196.png)

![1576519482424](img/1576519482424.png)

## Stateless and Stateful Application

### Stateless Applications

- 해당 클라이언트와의 다음 세션에서 사용하기 위해 한 세션에서 생성된 클라이언트 데이터를 저장하지 않는 프로그램이다.
- 과거의 기억이 없다.
- 모든 업무는 맨 처음에 한것처럼 실행된다.

### Statefull Applications

- 다음 세션에서의 사용을 위해 하나의 세션에서의 활동들로부터의 데이터를 클라이언트에 저장하는 프로그램이다.
- 과거의 기억이 있다.
- 이전의 업무가 기억되어 현재 업무에 영향을 끼칠 수 있다.

## Storage

### What is storage

![1576520338002](img/1576520338002.png)

### What is volume

![1576520352148](img/1576520352148.png)

![1576520730110](img/1576520730110.png)

![1576520388320](img/1576520388320.png)

### Pod

Pod 는 쿠버네티스에서 가장 기본적인 배포 단위로, 컨테이너를 포함하는 단위이다.

쿠버네티스의 특징중의 하나는 컨테이너를 개별적으로 하나씩 배포하는 것이 아니라 Pod 라는 단위로 배포하는데, Pod는 하나 이상의 컨테이너를 포함한다.



아래는 간단한 Pod를 정의한 오브젝트 스펙이다. 하나하나 살펴보면







- apiVersion은 이 스크립트를 실행하기 위한 쿠버네티스 API 버전이다 보통 v1을 사용한다.

- kind 에는 리소스의 종류를 정의하는데, Pod를 정의하려고 하기 때문에, Pod라고 넣는다.

- metadata에는 이 리소스의 각종 메타 데이타를 넣는데, 라벨(뒤에서 설명할)이나 리소스의 이름등 각종 메타데이타를 넣는다

- spec 부분에 리소스에 대한 상세한 스펙을 정의한다.

- - Pod는 컨테이너를 가지고 있기 때문에, container 를 정의한다. 이름은 nginx로 하고 도커 이미지 nginx:1.7.9 를 사용하고, 컨테이너 포트 8090을 오픈한다.



Pod 안에 한개 이상의 컨테이너를 가지고 있을 수 있다고 했는데 왜 개별적으로 하나씩 컨테이너를 배포하지 않고 여러개의 컨테이너를 Pod 단위로 묶어서 배포하는 것인가?



Pod는 다음과 같이 매우 재미있는 특징을 갖는다.



- Pod 내의 컨테이너는 IP와 Port를 공유한다. 
  두 개의 컨테이너가 하나의 Pod를 통해서 배포되었을때, localhost를 통해서 통신이 가능하다.
  예를 들어 컨테이너 A가 8080, 컨테이너 B가 7001로 배포가 되었을 때, B에서 A를 호출할때는 localhost:8080 으로 호출하면 되고, 반대로 A에서 B를 호출할때에넌 localhost:7001로 호출하면 된다. 
- Pod 내에 배포된 컨테이너간에는 디스크 볼륨을 공유할 수 있다. 
  근래 애플리케이션들은 실행할때 애플리케이션만 올라가는것이 아니라 Reverse proxy, 로그 수집기등 다양한 주변 솔루션이 같이 배포 되는 경우가 많고, 특히 로그 수집기의 경우에는 애플리케이션 로그 파일을 읽어서 수집한다. 애플리케이션 (Tomcat, node.js)와 로그 수집기를 다른 컨테이너로 배포할 경우, 일반적인 경우에는 컨테이너에 의해서 파일 시스템이 분리되기 때문에, 로그 수집기가 애플리케이션이 배포된 컨테이너의 로그파일을 읽는 것이 불가능 하지만, 쿠버네티스의 경우 하나의 Pod 내에서는 컨테이너들끼리 볼륨을 공유할 수 있기 때문에 다른 컨테이너의 파일을 읽어올 수 있다.

![img](https://t1.daumcdn.net/cfile/tistory/9913C64D5B02D9C826)



위와 같이 애플리케이션과 애플리케이션에서 사용하는 주변 프로그램을 같이 배포하는 패턴을 마이크로 서비스 아키텍쳐에서 사이드카 패턴(Side car pattern)이라고 하는데, 이 외에도 Ambassador, Adapter Container 등 다양한 패턴이 있는데, 이는 나중에 [다른 글](https://kubernetes.io/blog/2015/06/the-distributed-system-toolkit-patterns/)에서 상세하게 설명하도록 한다.

### Volume

Pod가 기동할때 디폴트로, 컨테이너마다 로컬 디스크를 생성해서 기동되는데, 이 로컬 디스크의 경우에는 영구적이지 못하다. 즉 컨테이너가 리스타트 되거나 새로 배포될때 마다 로컬 디스크는 Pod 설정에 따라서 새롭게 정의되서 배포되기 때문에, 디스크에 기록된 내용이 유실된다. 

데이타 베이스와 같이 영구적으로 파일을 저장해야 하는 경우에는 컨테이너 리스타트에 상관 없이 파일을 영속적으로 저장애햐 하는데, 이러한 형태의 스토리지를 볼륨이라고 한다. 

볼륨은 컨테이너의 외장 디스크로 생각하면 된다. Pod가 기동할때 컨테이너에 마운트해서 사용한다.



앞에서 언급한것과 같이 쿠버네티스의 볼륨은 Pod내의 컨테이너간의 공유가 가능하다.

![img](https://t1.daumcdn.net/cfile/tistory/99FC343C5B02D9C810)



웹 서버를 배포하는 Pod가 있을때, 웹서비스를 서비스하는 Web server 컨테이너, 그리고 컨텐츠의 내용 (/htdocs)를 업데이트하고 관리하는 Content mgmt 컨테이너, 그리고 로그 메세지를 관리하는 Logger라는 컨테이너이가 있다고 하자

- WebServer 컨테이너는 htdocs 디렉토리의 컨테이너를 서비스하고, /logs 디렉토리에 웹 억세스 기록을 기록한다. 
- Content 컨테이너는 htdocs 디렉토리의 컨텐트를 업데이트하고 관리한다.
- Logger 컨테이너는 logs 디렉토리의 로그를 수집한다.

이 경우 htdocs 컨텐츠 디렉토리는 WebServer와 Content 컨테이너가 공유해야 하고 logs 디렉토리는 Webserver 와 Logger 컨테이너가 공유해야 한다. 이러한 시나리오에서 볼륨을 사용할 수 있다. 



아래와 같이 htdocs와 logs 볼륨을 각각 생성한 후에, htdocs는 WebServer와, Contents management 컨테이너에 마운트 해서 공유하고, logs볼륨은 Logger와 WebServer 컨테이너에서 공유하도록 하면된다.  

![img](https://t1.daumcdn.net/cfile/tistory/997CE9435B02D9C824)





쿠버네티스는 다양한 외장 디스크를 추상화된 형태로 제공한다. iSCSI나 NFS와 같은 온프렘 기반의 일반적인 외장 스토리지 이외에도, 클라우드의 외장 스토리지인 AWS EBS, Google PD,에서 부터  github, glusterfs와 같은 다양한 오픈소스 기반의 외장 스토리지나 스토리지 서비스를 지원하여, 스토리지 아키텍처 설계에 다양한 옵션을 제공한다.

### Service

Pod와 볼륨을 이용하여, 컨테이너들을 정의한 후에, Pod 를 서비스로 제공할때, 일반적인 분산환경에서는 하나의 Pod로 서비스 하는 경우는 드물고, 여러개의 Pod를 서비스하면서, 이를 로드밸런서를 이용해서 하나의 IP와 포트로 묶어서 서비스를 제공한다.



Pod의 경우에는 동적으로 생성이 되고, 장애가 생기면 자동으로 리스타트 되면서 그 IP가 바뀌기 때문에, 로드밸런서에서 Pod의 목록을 지정할 때는 IP주소를 이용하는 것은 어렵다. 또한 오토 스케일링으로 인하여 Pod 가 동적으로 추가 또는 삭제되기 때문에, 이렇게 추가/삭제된 Pod 목록을 로드밸런서가 유연하게 선택해 줘야 한다. 

그래서 사용하는 것이 라벨(label)과 라벨 셀렉터(label selector) 라는 개념이다.



서비스를 정의할때, 어떤 Pod를 서비스로 묶을 것인지를 정의하는데, 이를 라벨 셀렉터라고 한다. 각 Pod를 생성할때 메타데이타 정보 부분에 라벨을 정의할 수 있다. 서비스는 라벨 셀렉터에서 특정 라벨을 가지고 있는 Pod만 선택하여 서비스에 묶게 된다.

아래 그림은 서비스가 라벨이 “myapp”인 서비스만 골라내서 서비스에 넣고, 그 Pod간에만 로드밸런싱을 통하여 외부로 서비스를 제공하는 형태이다.

![img](https://t1.daumcdn.net/cfile/tistory/99B11D475B02D9C802)





이를 스펙으로 정의해보면 대략 다음과 같다.







- 리소스 종류가 Service 이기 때문에, kind는 Service로 지정하고,

- 스크립트를 실행할 api 버전은 v1으로 apiVersion에 정의했다.

- 메타데이타에 서비스의 이름을 my-service로 지정하고

- spec 부분에 서비스에 대한 스펙을 정의한다.

- - selector에서 라벨이 app:myapp인 Pod 만을 선택해서 서비스에서 서비스를 제공하게 하고
  - 포트는 TCP를 이용하되, 서비스는 80 포트로 서비스를 하되, 서비스의 80 포트의 요청을 컨테이너의 9376 포트로 연결해서 서비스를 제공한다. 

### Name space

네임스페이스는 한 쿠버네티스 클러스터내의 논리적인 분리단위라고 보면 된다.

Pod,Service 등은 네임 스페이스 별로 생성이나 관리가 될 수 있고, 사용자의 권한 역시 이 네임 스페이스 별로 나눠서 부여할 수 있다.

즉 하나의 클러스터 내에, 개발/운영/테스트 환경이 있을때, 클러스터를 개발/운영/테스트 3개의 네임 스페이스로 나눠서 운영할 수 있다. 네임스페이스로 할 수 있는 것은

-  사용자별로 네임스페이스별 접근 권한을 다르게 운영할 수 있다.
-  네임스페이스별로 [리소스의 쿼타](https://kubernetes.io/docs/concepts/policy/resource-quotas/) (할당량)을 지정할 수 있다. 개발계에는 CPU 100, 운영계에는 CPU 400과 GPU 100개 식으로, 사용 가능한 리소스의 수를 지정할 수 있다. 
- 네임 스페이스별로 리소스를 나눠서 관리할 수 있다. (Pod, Service 등)



주의할점은 네임 스페이스는 논리적인 분리 단위이지 물리적이나 기타 장치를 통해서 환경을 분리(Isolation)한것이 아니다. 다른 네임 스페이스간의 pod 라도 통신은 가능하다. 

물론 네트워크 정책을 이용하여, 네임 스페이스간의 통신을 막을 수 있지만 높은 수준의 분리 정책을 원하는 경우에는 쿠버네티스 클러스터 자체를 분리하는 것을 권장한다.

![img](https://t1.daumcdn.net/cfile/tistory/999A364D5B02D9C834)



### 라벨

앞에서 잠깐 언급했던 것 중의 하나가 label 인데, 라벨은 쿠버네티스의 리소스를 선택하는데 사용이 된다. 각 리소스는 라벨을 가질 수 있고, 라벨 검색 조건에 따라서 특정 라벨을 가지고 있는 리소스만을 선택할 수 있다.

이렇게 라벨을 선택하여 특정 리소스만 배포하거나 업데이트할 수 있고 또는 라벨로 선택된 리소스만 Service에 연결하거나 특정 라벨로 선택된 리소스에만 네트워크 접근 권한을 부여하는 등의 행위를 할 수 있다. 

라벨은 metadata 섹션에 키/값 쌍으로 정의가 가능하며, 하나의 리소스에는 하나의 라벨이 아니라 여러 라벨을 동시에 적용할 수 있다.



셀렉터를 사용하는 방법은 오브젝트 스펙에서 selector 라고 정의하고 라벨 조건을 적어 놓으면 된다. 

쿠버네티스에서는 두 가지 셀렉터를 제공하는데, 기본적으로 Equaility based selector와, Set based selector 가 있다.

Equality based selector는 같냐, 다르냐와 같은 조건을 이용하여, 리소스를 선택하는 방법으로

- environment = dev
- tier != frontend

식으로, 등가 조건에 따라서 리소스를 선택한다.

이보다 향상된 셀렉터는 set based selector로, 집합의 개념을 사용한다.

-  environment in (production,qa) 는 environment가 production 또는 qa 인 경우이고, 
-  tier notin (frontend,backend)는 environment가 frontend도 아니고 backend도 아닌 리소스를 선택하는 방법이다.

다음 예제는 my-service 라는 이름의 서비스를 정의한것으로 셀렉터에서 app: myapp 정의해서 Pod의 라벨 app이 myapp 것만 골라서 이 서비스에 바인딩해서 9376 포트로 서비스 하는 예제이다.



### 컨트롤러

앞에서 소개한 4개의 기본 오브젝트로, 애플리케이션을 설정하고 배포하는 것이 가능한데 이를 조금 더 편리하게 관리하기 위해서 쿠버네티스는 컨트롤러라는 개념을 사용한다.

컨트롤러는 기본 오브젝트들을 생성하고 이를 관리하는 역할을 해준다. 컨트롤러는 Replication Controller (aka RC), Replication Set, DaemonSet, Job, StatefulSet, Deployment 들이 있다. 각자의 개념에 대해서 살펴보도록 하자.

### Replication Controller

Replication Controller는  Pod를 관리해주는 역할을 하는데, 지정된 숫자로 Pod를 기동 시키고, 관리하는 역할을 한다. 

Replication Controller (이하 RC)는 크게 3가지 파트로 구성되는데, Replica의 수, Pod Selector, Pod Template 3가지로 구성된다.

- Selector : 먼저 Pod selector는 라벨을 기반으로 하여,  RC가 관리한 Pod를 가지고 오는데 사용한다.
- Replica 수 :  RC에 의해서 관리되는 Pod의 수인데, 그 숫자만큼 Pod 의 수를 유지하도록 한다.예를 들어 replica 수가 3이면, 3개의 Pod만 띄우도록 하고, 이보다 Pod가 모자르면 새로운 Pod를 띄우고, 이보다 숫자가 많으면 남는 Pod를 삭제한다.
- Pod를 추가로 기동할 때 그러면 어떻게 Pod를 만들지 Pod에 대한 정보 (도커 이미지, 포트,라벨등)에 대한 정보가 필요한데, 이는 Pod template이라는 부분에 정의 한다.



![img](https://t1.daumcdn.net/cfile/tistory/99D817375B02D9C805)





주의할점은 이미 돌고 있는 Pod가 있는 상태에서 RC 리소스를 생성하면 그 Pod의 라벨이 RC의 라벨과 일치하면 새롭게 생성된 RC의 컨트롤을 받는다. 만약 해당 Pod들이 RC에서 정의한 replica 수 보다 많으면, replica 수에 맞게 추가분의 pod를 삭제하고, 모자르면 template에 정의된 Pod 정보에 따라서 새로운 Pod를 생성하는데, 기존에 생성되어 있는 Pod가 template에 정의된 스펙과 다를지라도 그 Pod를 삭제하지 않는다. 예를 들어 기존에 아파치 웹서버로 기동중인 Pod가 있고, RC의 template은 nginx로 Pod를 실행하게 되어 있다하더라도 기존에 돌고 있는 아파치 웹서버 기반의 Pod를 삭제하지 않는다. 



아래 예를 보자.

![img](https://t1.daumcdn.net/cfile/tistory/99C0CA475B02D9C701)



이 예제는 ngnix라는 이름의 RC를 정의한 것으로, label이 “app:ngnix”인 Pod들을 관리하고 3개의 Pod가 항상 운영되도록 설정한다.

Pod는 app:ngix 라는 라벨을 가지면서 이름이 ngnix이고 nginx 이미지를 사용해서 생성하고 컨테이너의 포트는 80 번 포트를 이용해서 서비스를 제공한다.

### ReplicaSet

ReplicaSet은 Replication Controller 의 새버전으로 생각하면 된다.

큰 차이는 없고 Replication Controller 는 Equality 기반 Selector를 이용하는데 반해, Replica Set은 Set 기반의 Selector를 이용한다. 

### Deployment

Deployment (이하 디플로이먼트) Replication controller와 Replica Set의 좀더 상위 추상화 개념이다. 실제 운영에서는 ReplicaSet 이나 Replication Controller를 바로 사용하는 것보다, 좀 더 추상화된 Deployment를 사용하게 된다.

### 쿠버네티스 배포에 대한 이해

쿠버네티스의 Deployment 리소스를 이해하기 위해서는 쿠버네티스에서 Deployment 없이 어떻게 배포를 하는지에 대해서 이해를 하면 Deployment 를 이해할 수 있다. 



다음과 같은 Pod와 RC가 있다고 하자

![img](https://t1.daumcdn.net/cfile/tistory/99D87C415B02D9C70F)



애플리케이션이 업데이트되서 새로운 버전으로 컨테이너를 굽고 이 컨테이너를 배포하는 시나리오에 대해서 알아보자. 여러가지 배포 전략이 있겠지만, 많이 사용하는 블루/그린 배포와 롤링 업데이트 방식 두가지 방법에 대해서 설명한다.

##### 블루/그린 배포

블루/그린 배포 방식은 블루(예전)버전으로 서비스 하고 있던 시스템을 그린(새로운)버전을 배포한 후, 트래픽을 블루에서 그린으로 한번에 돌리는 방식이다.

여러가지 방법이 있지만 가장 손쉬운 방법으로는 새로운 RC을 만들어서 새로운 템플릿으로 Pod를 생성한 후에, Pod 생성이 끝나면, 서비스를 새로운 Pod로 옮기는 방식이다.

![img](https://t1.daumcdn.net/cfile/tistory/99B387375B02D9C71C)



후에, 배포가 완료되고 문제가 없으면 예전 버전의 RC 와 Pod를 지워준다.

##### 롤링 업그레이드

롤링 업그레이드 방식은 Pod를 하나씩 업그레이드 해가는 방식이다. 

이렇게 배포를 하려면 먼저 새로운 RC를 만든후에, 기존 RC에서 replica 수를 하나 줄이고, 새로운 RC에는 replica 수를 하나만 준다.

![img](https://t1.daumcdn.net/cfile/tistory/99867C375B02D9C70C)



라벨을 같은 이름으로 해주면 서비스는 자연히 새로운 RC에 의해 생성된 Pod를 서비스에 포함 시킨다.

다음으로 기존 RC의 replica를 하나 더 줄이고, 새로운 RC의  replica를 하나 더 늘린다.

![img](https://t1.daumcdn.net/cfile/tistory/997F814A5B02D9C730)



그러면 기존 버전의 Pod가 하나더 서비스에서 빠지게 되고 새로운 버전의 Pod가 서비스에 추가된다.

마찬가지 작업을 반복하게 되면, 아래 그림과 같이 예전 버전의 Pod가 모두 빠지고 새 버전의 Pod만 서비스 되게 된다. 

![img](https://t1.daumcdn.net/cfile/tistory/99B387375B02D9C71C)



만약에 배포가 잘못되었을 경우에는 기존 RC의 replica 수를 원래대로 올리고, 새버전의 replicat 수를 0으로 만들어서 예전 버전의 Pod로 롤백이 가능하다.

이 과정은 [kubectl rolling-update](https://kubernetes.io/docs/tasks/run-application/rolling-update-replication-controller/)라는 명령으로 RC 단위로 컨트롤이 가능하지만, 그래도 여전히 작업이 필요하고, 배포 과정을 모니터링 해야 한다. 그리고 가장 문제는 kubectl rolling-update 명령은 클라이언트에서 실행 하는 명령으로, 명령어 실행중에 클라이언트의 연결이 끊어 지면 배포작업이 비정상적으로 끊어질 수 있는 문제가 있다. 

그리고 마지막으로, 롤백과정 역시 수동 컨트롤이 필요할 수 있다. 그래서 이러한 과정을 자동화하고 추상화한 개념을 Deployment라고 보면 된다. Deployment는 Pod 배포를 위해서 RC를 생성하고 관리하는 역할을 하며, 특히 롤백을 위한 기존 버전의 RC 관리등 여러가지 기능을 포괄적으로 포함하고 있다. 

### StatefulSet

마지막으로, 1.9에 정식으로 릴리즈된 StatefulSet이 있다. RS/RC나 다른 컨트롤러로는 데이타베이스와 같이 상태를 가지는 애플리케이션을 관리하기가 어렵다.  그래서 이렇게 데이타 베이스등과 같이 상태를 가지고 있는 Pod를 지원하기 위해서 StatefulSet 이라는 것이 새로 소개되었는데, 이를 이해하기 위해서는 쿠버네티스의 디스크 볼륨에 대한 이해가 필요하기 때문에 다음에 볼륨과 함께 다시 설명하도록 한다. 

### 노드

노드는 마스터에 의해 명령을 받고 실제 워크로드를 생성하여 서비스 하는 컴포넌트이다. 노드에는 Kubelet, Kube-proxy,cAdvisor 그리고 컨테이너 런타임이 배포된다.

### Kubelet

노드에 배포되는 에이전트로, 마스터의 API서버와 통신을 하면서, 노드가 수행해야 할 명령을 받아서 수행하고, 반대로 노드의 상태등을 마스터로 전달하는 역할을 한다. 

### Kube-proxy

노드로 들어오거는 네트워크 트래픽을 적절한 컨테이너로 라우팅하고, 로드밸런싱등 노드로 들어오고 나가는 네트워크 트래픽을 프록시하고, 노드와 마스터간의 네트워크 통신을 관리한다. 

### 볼륨 종류

쿠버네티스의 볼륨은 여러가지 종류가 있는데,  로컬 디스크 뿐 아니라, NFS, iSCSI, Fiber Channel과 같은 일반적인 외장 디스크 인터페이스는 물론, GlusterFS나, Ceph와 같은 오픈 소스 파일 시스템, AWS EBS, GCP Persistent 디스크와 같은 퍼블릭 클라우드에서 제공되는 디스크, VsphereVolume과 같이 프라이비트 클라우드 솔루션에서 제공하는 디스크 볼륨까지 다양한 볼륨을 지원한다. 

### emptyDir

emptyDir은 Pod가 생성될때 생성되고, Pod가 삭제 될때 같이 삭제되는 임시 볼륨이다. 

단 Pod 내의 컨테이너 크래쉬되어 삭제되거나 재시작 되더라도 emptyDir의 생명주기는 컨테이너 단위가 아니라, Pod 단위이기 때문에, emptyDir은 삭제 되지 않고 계속해서 사용이 가능하다. 

생성 당시에는 디스크에 아무 내용이 없기 때문에, emptyDir  이라고 한다.

emptyDir의 물리적으로 노드에서 할당해주는 디스크에 저장이 되는데, (각 환경에 따라 다르다. 노드의 로컬 디스크가 될 수 도 있고, 네트워크 디스크등이 될 수 도 있다.) emptyDir.medium 필드에 “Memory”라고 지정해주면, emptyDir의 내용은 물리 디스크 대신 메모리에 저장이 된다.

shared-storage라는 이름으로 emptyDir 기반의 볼륨을 만든 후에, nginx와 redis 컨테이너의 /data/shared 디렉토리에 마운트를 하였다.

Pod를 기동 시킨후에, redis 컨테이너의 /data/shared 디렉토리에 들어가 보면 당연히 아무 파일도 없는 것을 확인할 수 있다. 

![img](https://t1.daumcdn.net/cfile/tistory/99E63E3E5B1D3F102B)

이 상태에서 아래와 같이 file.txt 파일을 생성하였다. 

![img](https://t1.daumcdn.net/cfile/tistory/99A048415B1D3F102E)

다음 nginx 컨테이너로 들어가서 /data/shared 디렉토리를 살펴보면 file.txt 파일이 있는 것을 확인할 수 있다. 

![img](https://t1.daumcdn.net/cfile/tistory/99F382475B1D3F1033)

이 파일은 redis 컨테이너에서 생성이 되어 있지만, 같은 Pod 내이기 때문에, nginx 컨테이너에서도 접근이 가능하게 된다.