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



### **Step 3: Build the Application**

1. Compile the Java application:

2.  
 
   ```
   sudo apt install maven
   ```
   
   ```
   mvn clean package
   ```

3. After building, ensure the JAR file `hello-world-1.0-SNAPSHOT.jar` is in the `target` directory.

Here’s a sample `README.md` file format tailored for documenting steps to push a Docker image to AWS ECR using an IAM role:

## Push Docker Image to AWS ECR Using IAM Role

## Steps

### 4. Set Up the IAM Role

1. Go to the **AWS Management Console**.
2. Navigate to **IAM > Roles** and create a new role:
   - **Trusted entity**: EC2.
   - Attach the `AmazonEC2ContainerRegistryFullAccess` policy or use the custom policy above.
3. Attach the role to your EC2 instance:
   - Go to **EC2 > Instances**.
   - Select the instance, choose **Actions > Security > Modify IAM Role**, and attach the role.
4. install aws cli
 ```
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   sudo apt install unzip
   unzip awscliv2.zip
   sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
  


### 5. Create an ECR Repository
If the ECR repository does not already exist, create it:

```
aws ecr create-repository --repository-name <repository-name>
```

#. Authenticate Docker with AWS ECR
Run the following command to authenticate Docker with the ECR registry:

```
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```

#. Build and Tag Your Docker Image
1. Build the Docker image:

   ```
   docker build -t <image-name> .
   ```

2. Tag the Docker image for ECR:

   ```
   docker tag <image-name>:<tag> <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
   ```


3. Push the Docker Image to ECR
Push the image to ECR:

```
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>
```


## Verify the Push
To verify the image is in ECR:
1. Go to the AWS Management Console.
2. Navigate to **ECR > Repositories > <repository-name>**.
3. Ensure the image is listed.


