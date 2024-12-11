Here’s a step-by-step guide to creating a Java "Hello World" application, containerizing it using Docker, and pushing the Docker image to AWS Elastic Container Registry (ECR).

---

### **Step 1: Create a Simple Java "Hello World" Application**

1. **Directory Structure**:
   ```
   java-docker-hello-world/
   ├── src/
   │   └── Main.java
   ├── Dockerfile
   ├── pom.xml  # For Maven
   └── README.md
   ```

2. **`Main.java`**:
   ```java
   public class Main {
       public static void main(String[] args) {
           System.out.println("Hello, World from Dockerized Java!");
       }
   }
   ```

3. **`pom.xml`** (for Maven):
   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>
       <groupId>com.example</groupId>
       <artifactId>hello-world</artifactId>
       <version>1.0-SNAPSHOT</version>
       <build>
           <plugins>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-compiler-plugin</artifactId>
                   <version>3.8.1</version>
                   <configuration>
                       <source>8</source>
                       <target>8</target>
                   </configuration>
               </plugin>
           </plugins>
       </build>
   </project>
   ```

---

### **Step 2: Create a Dockerfile**

```dockerfile
# Use an OpenJDK base image
FROM openjdk:8-jdk-alpine

# Set working directory
WORKDIR /app

# Copy the compiled JAR into the container
COPY target/hello-world-1.0-SNAPSHOT.jar app.jar

# Define the command to run the application
CMD ["java", "-jar", "app.jar"]
```

---

### **Step 3: Build the Application**

1. Compile the Java application:
   ```bash
   mvn clean package
   ```

2. After building, ensure the JAR file `hello-world-1.0-SNAPSHOT.jar` is in the `target` directory.

---

Steps to Push an Image to ECR Using IAM Role
1. Set Up the IAM Role
Create the IAM Role:

Go to IAM > Roles in the AWS Management Console.
Create a new role and choose EC2 as the trusted entity.
Attach the policy AmazonEC2ContainerRegistryFullAccess or a custom policy with the required permissions:
json
Copy code
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:CreateRepository",
        "ecr:DescribeRepositories",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Resource": "*"
    }
  ]
}
Attach the IAM Role to the EC2 Instance:

Go to EC2 > Instances in the AWS Management Console.
Select your instance, choose Actions > Security > Modify IAM Role, and attach the role you just created.


### **Step 4: Build and Tag the Docker Image**

1. Build the Docker image:
   ```bash
   docker build -t java-docker-hello-world .
   ```

2. Tag the image for AWS ECR:
   ```bash
   docker tag java-docker-hello-world:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/java-docker-hello-world:latest
   ```

---

### **Step 5: Push the Docker Image to AWS ECR**

1. **Login to AWS ECR**:
   ```bash
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
   ```

2. **Create an ECR Repository**:
   ```bash
   aws ecr create-repository --repository-name java-docker-hello-world
   ```

3. **Push the Docker image to ECR**:
   ```bash
   docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/java-docker-hello-world:latest
   ```

---

### **Step 6: Verify the Image in ECR**

1. Go to the AWS Management Console.
2. Navigate to **ECR > Repositories > java-docker-hello-world**.
3. Confirm that your Docker image has been successfully pushed.

---

### **Additional Notes**
- Replace `<aws_account_id>` and `<region>` with your AWS account details and the desired AWS region.
- Ensure AWS CLI is installed and configured with appropriate IAM permissions.

This completes the process of creating, containerizing, and deploying a Java "Hello World" application to AWS ECR! Let me know if you need help setting up a deployment pipeline for this image.
