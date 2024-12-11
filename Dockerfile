# Use an OpenJDK base image
FROM openjdk:8-jdk-alpine

# Set working directory
WORKDIR /app

# Copy the compiled JAR into the container
COPY target/hello-world-1.0-SNAPSHOT.jar app.jar

# Define the command to run the application
CMD ["java", "-jar", "app.jar"]
