# sb-cors
- CORS 학습을 위한 예시 프로젝트 생성(Ubuntu22.04, Springboot 3, gradle, Java 17)
- `setup-springboot.sh` 를 실행시켜서 `cors-demo` 프로젝트에 CORS 를 테스트할 수 있는 SpringBoot 프로젝트를 생성.

## Installation
### EC2 사용할 경우, 보안 그룹(Security Group)에 8080 port 가 open 되어있는지 확인
- Springboot 애플리케이션은 기본적으로 8080 port 로 실행되기 때문에 해당 port 가 open 되어있어야 외부와 통신할 수 있음. 
![security group - 8080](https://github.com/ohahohah/sb-cors/assets/17819874/f4adb98d-5862-4b9e-b4d0-13ab47ac1694)


### 초기 설정
- `setup-springboot.sh`으로 CORS 설정이 되어있는 Springboot 프로젝트를 만들고 실행시킴. 그에 필요한 패키지 자동 설치
1. Ubuntu 환경에 접속
1-1. (선택사항) git 이 설치되어있지 않다면 패키지 설치 
```sh
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y git
```
2.  본 repository 를 clone
```sh
git clone https://github.com/siyoungoh/sb-cors.git
```
3. repository 디렉토리로 이동 후 `setup-springboot.sh` 를 실행시킴. 
```sh
cd ./sb-cors
chmod +x ./setup-springboot.sh
./setup-springboot.sh
```

### 프로세스 종료 
#### 아래와 같은 화면에서 프로세스를 종료하면 `ctrl + c` 를 입력
```sh

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.0)

2024-06-28T05:19:23.951Z  INFO 18849 --- [           main] c.example.corsdemo.CorsDemoApplication   : Starting CorsDemoApplication using Java 17.0.11 with PID 18849 (/home/ubuntu/cors-demo/build/classes/java/main started by ubuntu in /home/ubuntu/cors-demo)
2024-06-28T05:19:23.957Z  INFO 18849 --- [           main] c.example.corsdemo.CorsDemoApplication   : No active profile set, falling back to 1 default profile: "default"
2024-06-28T05:19:25.468Z  INFO 18849 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2024-06-28T05:19:25.484Z  INFO 18849 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2024-06-28T05:19:25.487Z  INFO 18849 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.1]
2024-06-28T05:19:25.714Z  INFO 18849 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2024-06-28T05:19:25.717Z  INFO 18849 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1684 ms
2024-06-28T05:19:26.433Z  INFO 18849 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2024-06-28T05:19:26.449Z  INFO 18849 --- [           main] c.example.corsdemo.CorsDemoApplication   : Started CorsDemoApplication in 3.072 seconds (process running for 3.816)
<==========---> 80% EXECUTING [54s]
````

#### 다른 터미널에서 프로세스를 종료하려면 `kill -9 [PID]` 를 사용
1. 현재 SpringBoot PID(Process ID) 찾기
  - 전체 프로세스 중에 java 로 실행되고 있는 CorsDemoApplication 애플리케이션 프로세스를 찾음
```sh
ps aux | grep java | grep CorsDemoApplication
```
- 결과 조회화면에서 PID 를 찾음. 예를 들면 아래와 같은 결과일때에는 ubuntu 바로 옆에 적힌 숫자 `18849`가 PID 임. 
```sh
ubuntu@ip-172-31-25-111:~$ ps aux | grep java | grep CorsDemoApplication
ubuntu     18849  1.8 10.3 2134380 100480 ?      Sl   05:19   0:02 /usr/lib/jvm/java-17-openjdk-amd64/bin/java (내용 중간 생략) com.example.corsdemo.CorsDemoApplication
```
2. 프로세스 종료 명령어 입력
```sh
kill -9 18849
```

### 애플리케이션 시작하기
- 초기 시작 후에는 아래 명령어를 사용해 프로젝트를 시작시킴
- 프로젝트 디렉토리로 이동. 기본값은 `cors-demo`
```sh
cd ~/cors-demo
```
- gradle 을 사용해서 실행
```sh
gradle bootRun
```
- 참고. 명령어 오류 
  - 만약 이동한 디렉토리에 소스코드파일과 함께 gradle이 있고, 시스템에도 gradle 설치가 되어있는데 아래와 같은 에러가 발생한다면, gradle 환경 설정 확인 필요. 
  - 정상적인 프로젝트 디렉토리 예시
```sh
ubuntu@ip-172-31-25-111:~/cors-demo$ ls -l
total 16
drwxrwxr-x 5 ubuntu ubuntu 4096 Jun 28 05:19 build
-rw-rw-r-- 1 ubuntu ubuntu  467 Jun 28 05:18 build.gradle
-rw-rw-r-- 1 ubuntu ubuntu   31 Jun 28 05:18 settings.gradle
drwxrwxr-x 3 ubuntu ubuntu 4096 Jun 28 05:18 src
```  
- 오류 메시지 예시
```sh
ubuntu@ip-172-31-25-111:~/sb-cors$ gradle bootRun
Command 'gradle' not found, but can be installed with:
sudo snap install gradle  # version 7.2, or
sudo apt  install gradle  # version 4.4.1-13
See 'snap info gradle' for additional versions.
```
- 아래 명령어로 gradle 환경변수 세팅 후 다시 `gradle bootRun` 실행시키기
```sh
export PATH=$PATH:/opt/gradle/bin
source /etc/profile.d/gradle.sh
```

## CORS 테스트 - Postman을 사용하여 EC2 인스턴스의 Spring Boot 애플리케이션을 테스트
- Postman을 사용하여 EC2 인스턴스의 Spring Boot 애플리케이션을 테스트하는 방법. 이 단계를 따라 Postman을 사용하여 EC2 인스턴스의 Spring Boot 애플리케이션 API를 테스트할 수 있음. CORS 설정이 올바르게 되어 있으면, 요청이 정상적으로 처리되고 응답을 받을 수 있음.

### 사전 준비
1. **EC2 인스턴스에서 Spring Boot 애플리케이션 실행**:
   `setup-springboot.sh` 스크립트를 성공적으로 실행하고 Spring Boot 애플리케이션이 실행 중인지 확인함.
2. **보안 그룹 설정**:
   EC2 인스턴스의 보안 그룹이 포트 8080을 허용하도록 설정되어 있는지 확인함.

### Postman 사용하여 Spring Boot 애플리케이션 테스트

#### 1. Postman 설치 및 실행

1. **Postman 설치**:
   -  [Postman 공식 웹사이트](https://www.postman.com/downloads/)에서 Postman을 다운로드하고 설치함.
2. **Postman 실행**:
   -  Postman을 실행함.

#### 2. 새로운 요청 생성

1. **새 요청 생성**:
   -  Postman을 열고, 상단의 "New" 버튼을 클릭함.
   -  "HTTP Request"를 선택함.

2. **GET 요청 설정**:
   -  요청 유형을 `GET`으로 설정함.
   -  URL 입력란에 EC2 인스턴스의 공인 IP 주소와 포트를 입력함. 예를 들어, `http://your-ec2-ip:8080/hello`.
   -  예: `http://3.123.45.67:8080/hello` (여기서 `3.123.45.67`은 EC2 인스턴스의 공인 IP 주소임).

3. **헤더 설정**:
   -  "Headers" 탭을 선택하고, 새로운 헤더를 추가함.
   -  Key: `Origin`
   -  Value: `http://localhost:3000`
   -  이는 로컬에서 테스트하는 것처럼 CORS 헤더를 설정하는 것임.

4. **요청 전송**:
   -  "Send" 버튼을 클릭하여 요청을 전송함.

#### 3. 응답 확인

1. **정상 응답**:
   -  CORS 설정이 올바르게 되어 있다면, 응답 상태 코드가 `200 OK`로 표시되고 응답 본문에 "Hello, World!"가 표시됨.
   -  예시 응답:
     ```plaintext
     Hello, World!
     ```

2. **CORS 오류 확인**:
   -  만약 CORS 설정에 문제가 있다면, Postman 콘솔에서 오류 메시지를 확인할 수 있음.
   -  테스트를 위해  "Headers" 탭의 Key: `Origin` 의 Value를 `http://localhost:3001` 로 3000 이 아닌 다른 포트 주소를 사용해조기
   -  CORS 오류 예시:
     ```plaintext
     Access to fetch at 'http://your-ec2-ip:8080/hello' from origin 'http://localhost:3000' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
     ```
     ![postman-cors-error](https://github.com/ohahohah/sb-cors/assets/17819874/042e9384-7b6d-4513-b3c8-3c647409e96e)



## 스크립트로 생성되는 프로젝트 구조 설명
- Spring Boot 애플리케이션을 개발하기 위한 표준 Gradle 프로젝트 구조임. src 디렉토리에는 소스 코드가 위치하며, build 디렉토리는 빌드 결과물이 저장됨. build.gradle과 settings.gradle 파일은 Gradle 빌드 도구를 사용하여 프로젝트를 설정하고 관리하는 데 사용됨.

- build
```sh
.
├── build
│   ├── classes
│   │   └── java
│   │       └── main
│   │           └── com
│   │               └── example
│   │                   └── corsdemo
│   │                       ├── CorsDemoApplication.class
│   │                       ├── HelloController.class
│   │                       └── WebConfig.class
│   ├── generated
│   │   └── sources
│   │       ├── annotationProcessor
│   │       │   └── java
│   │       │       └── main
│   │       └── headers
│   │           └── java
│   │               └── main
│   ├── resolvedMainClassName
│   └── tmp
│       └── compileJava
│           └── previous-compilation-data.bin
├── build.gradle
├── settings.gradle
└── src
    └── main
        └── java
            └── com
                └── example
                    └── corsdemo
                        ├── CorsDemoApplication.java
                        ├── HelloController.java
                        └── WebConfig.java

23 directories, 10 files
```
- 1. `build` 디렉토리
  - `build` 디렉토리는 Gradle 빌드 도구가 생성한 파일들을 포함함. 프로젝트가 빌드될 때 자동으로 생성됨.
- 2. build.gradle
  - build.gradle 파일은 Gradle 빌드 스크립트임. 이 파일에는 프로젝트의 의존성, 플러그인, 빌드 설정 등이 정의되어 있음. Spring Boot 프로젝트를 설정하고 빌드하는 데 사용됨.
- 3. settings.gradle
  - settings.gradle 파일은 Gradle 설정 파일임. 이 파일에는 프로젝트의 루트 이름과 포함된 서브 프로젝트들이 정의되어 있음.
- 4. src/main/java/com/example/corsdemo
  - src 디렉토리는 소스 파일들이 위치하는 곳임. src/main/java는 메인 소스 파일들을 포함하며, com/example/corsdemo는 패키지 구조를 나타냄.
  - CorsDemoApplication.java
    - Spring Boot 애플리케이션의 메인 클래스임. 애플리케이션의 진입점으로, Spring Boot 애플리케이션을 실행하는 역할을 함.
  - HelloController.java
    - 간단한 REST 컨트롤러임. /hello 경로로 GET 요청을 받으면 "Hello, World!" 문자열을 반환함.
  - WebConfig.java
    - Spring MVC 설정 클래스임. CORS 설정을 포함하고 있어 특정 출처에서 오는 요청을 허용함.
    - 다음 코드 조각은 Spring MVC의 CORS 설정을 구성하는 부분임:
    ```java
    registry.addMapping("/**")
            .allowedOrigins("http://localhost:3000")  // 허용할 출처
            .allowedMethods("GET", "POST", "PUT", "DELETE", "HEAD")
            .allowCredentials(true);
    ```
    -  `registry.addMapping("/**")`:
        -  모든 경로에 대해 CORS 설정을 적용함.
    -  `.allowedOrigins("http://localhost:3000")`:
        -  `http://localhost:3000` 도메인에서 오는 요청을 허용함.
    -  `.allowedMethods("GET", "POST", "PUT", "DELETE", "HEAD")`:
        -  HTTP 메서드 `GET`, `POST`, `PUT`, `DELETE`, `HEAD`를 허용함.
    -  `.allowCredentials(true)`:
        -  자격 증명(쿠키, 인증 헤더 등)을 포함한 요청을 허용함.
