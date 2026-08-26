FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /workspace
COPY .mvn .mvn
COPY mvnw pom.xml ./
COPY src src
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw && ./mvnw clean package -q

FROM eclipse-temurin:17-jre-alpine

WORKDIR /app
COPY --from=build /workspace/target/classes classes

ENTRYPOINT ["java", "-cp", "/app/classes", "com.demo.Main"]