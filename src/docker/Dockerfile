# Iteration 1; Base dockerfile, works
FROM openjdk:8-jdk-alpine
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]

# Build Docker Image: docker build -t myapp:v1 --build-arg JAR_FILE=target/app.jar .
# Main goal, when we build docker images optimize the size of the image.
# Which helps reduce build and deployment times as part of iterative deployment.

# Iteration 2
# Layers really matters... So we moved the application classes to last layer.
FROM openjdk:8-jdk-alpine
ARG DEPENDENCY
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java", "-cp", "app:app/lib/*", "org.microservices.Application.java"]

# We still need to do one more thing, Use multistage to build and extract only classes.
# Step : Test and package
# the first stage of our build, mvn package.
FROM maven:3.6-jdk-8-alpine as mavenbuilder
WORKDIR /app
COPY pom.xml .
RUN mvn -e -B dependency:resolve
COPY src ./src
RUN mvn -e -B package
RUN java -Djarmode=layertools -jar /app/target/app.jar extract

# the third stage of our build will copy the extracted layers
FROM openjdk:8-jdk-alpine
WORKDIR application
COPY --from=mavenbuilder /app/dependencies/ ./
COPY --from=mavenbuilder /app/spring-boot-loader/ ./
COPY --from=mavenbuilder /app/snapshot-dependencies/ ./
COPY --from=mavenbuilder /app/application/ ./
EXPOSE 8080
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]

# Run Docker
# docker container run --name microservicesapp -p 8080:8080 microservicesapp:1.0