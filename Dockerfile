# 1. Use official Tomcat 9 image
FROM tomcat:9.0-jdk17

# 2. Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# 3. Copy WAR file into Tomcat webapps
COPY target/myapp.war /usr/local/tomcat/webapps/ROOT.war

# 4. Expose Tomcat port
EXPOSE 8080

# # 5. Start Tomcat
# CMD ["catalina.sh", "run"]

# 6. Start Tomcat
ENTRYPOINT [ "catalina.sh", "run" ]

# 7. User set to root
USER root


# 8. # Metadata about the image
LABEL app.name="hotstar-app" \
      app.type="java-war" \
      app.server="tomcat9" \
      app.version="1.0"
