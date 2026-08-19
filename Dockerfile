FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw && ./mvnw dependency:go-offline -q
COPY src src
RUN sed -i 's/\r$//' mvnw && ./mvnw clean package -q -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/classes ./classes
ENTRYPOINT ["java", "-cp", "classes", "com.demo.Main"]
