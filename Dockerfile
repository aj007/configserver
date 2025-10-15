FROM openjdk:21
WORKDIR /app
COPY ./target/configserver-1.0.0-SNAPSHOT.jar /app
EXPOSE 8888
CMD ["java", "-jar", "configserver-1.0.0-SNAPSHOT.jar"]