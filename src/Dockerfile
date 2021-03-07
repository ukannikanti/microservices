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


