#!/bin/bash

# Update and install necessary packages
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y wget unzip git

# Install Java 17
sudo apt install -y openjdk-17-jdk

# Check if Gradle is installed and remove it if it is
if command -v gradle &> /dev/null
then
    echo "Gradle is already installed. Removing existing Gradle."
    sudo rm -rf /opt/gradle
    sudo rm -f /usr/bin/gradle
    sudo rm -f /usr/local/bin/gradle
    sudo rm -f /etc/profile.d/gradle.sh
fi

# Install Gradle
wget https://services.gradle.org/distributions/gradle-7.5-bin.zip
unzip -o gradle-7.5-bin.zip
sudo mv gradle-7.5 /opt/gradle

# Set up environment variables for Gradle
echo 'export PATH=$PATH:/opt/gradle/bin' | sudo tee /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh

# Verify Gradle installation
gradle -v

# Remove existing project directory if it exists
if [ -d "~/cors-demo" ]; then
    rm -rf ~/cors-demo
fi

# Create Spring Boot project directory
mkdir -p ~/cors-demo
cd ~/cors-demo

# Initialize Gradle project without interactive prompts
echo "rootProject.name = 'cors-demo'" > settings.gradle

cat > build.gradle <<EOL
plugins {
    id 'org.springframework.boot' version '3.0.0'
    id 'io.spring.dependency-management' version '1.0.15.RELEASE'
    id 'java'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}
EOL

# Create application main class
mkdir -p src/main/java/com/example/corsdemo
cat > src/main/java/com/example/corsdemo/CorsDemoApplication.java <<EOL
package com.example.corsdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CorsDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(CorsDemoApplication.class, args);
    }

}
EOL

# Create WebConfig class for CORS configuration
cat > src/main/java/com/example/corsdemo/WebConfig.java <<EOL
package com.example.corsdemo;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:3000")  // 허용할 출처
                .allowedMethods("GET", "POST", "PUT", "DELETE", "HEAD")
                .allowCredentials(true);
    }
}
EOL

# Create a simple REST controller
cat > src/main/java/com/example/corsdemo/HelloController.java <<EOL
package com.example.corsdemo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, World!";
    }
}
EOL

# Ensure environment variables are set correctly
source /etc/profile.d/gradle.sh

# Build and run the Spring Boot application
gradle bootRun
