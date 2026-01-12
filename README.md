# Hotstar Application (Java WAR + Docker)

This project is a **Java Web Application (WAR)** built using **Maven** and deployed on **Apache Tomcat**.  
The application is containerized using **Docker** and can be run locally with port exposure.

---

## 🛠️ Tech Stack

- Java (JDK 17)
- Maven
- Apache Tomcat 9
- Docker
- Linux (Ubuntu / WSL)

---

## 📁 Project Structure

Hotstar-App/
├── src/
│ └── main/
│ ├── java/
│ └── webapp/
├── target/
│ └── myapp.war
├── Dockerfile
├── pom.xml
└── README.md


🧱 Build the Application (WAR)
mvn clean install
On successful build, the WAR file will be generated at: target/myapp.war


🐳 Dockerfile Used
FROM tomcat:9.0-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/myapp.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]



📦 Build Docker Image
docker build -t hotstar:v1.0 .
Verify
docker images


▶️ Run Docker Container

docker run -itd \
  --name hotstarcontainer \
  -p 8080:8080 \
  hotstar:v1.0

Check running container: docker ps

🌐 Access Application

http://localhost:8080


🧹 Stop & Remove Container

docker stop hotstarcontainer
docker rm hotstarcontainer


🗑️ Remove Docker Image (Optional)

docker rmi hotstar:v1.0

