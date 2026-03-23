FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml pom.xml
RUN mvn dependency:go-offline -B
COPY src/ src/
RUN mvn package -DskipTests

FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app
COPY  --from=build app/target/test-service-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 9090

ENTRYPOINT [ "java", "-jar", "app.jar" ]