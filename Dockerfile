FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# 创建文件上传目录
RUN mkdir -p /tmp/images

# 暴露 8081 端口
EXPOSE 8081

# 使用环境变量启动
ENTRYPOINT ["java", "-jar", "/app.jar"]