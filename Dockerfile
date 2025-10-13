# 1. Giai đoạn Build (Optional, nếu muốn image nhỏ hơn)
# FROM maven:3.8.7-openjdk-17 AS build
# WORKDIR /app
# COPY . .
# RUN mvn package -DskipTests

# 2. Giai đoạn Runtime
FROM eclipse-temurin:17-jdk-focal
WORKDIR /app

# Sao chép file JAR đã build từ máy host vào image
# Thay thế tên file JAR nếu cần
COPY target/securing-web-complete-0.0.1-SNAPSHOT.jar app.jar

# Cấu hình biến môi trường DATABASE_HOST trỏ đến tên service của MySQL
# Tên service 'mysql-db' sẽ được Docker Compose tự động giải quyết (resolve)
ENV DATABASE_HOST=mysql-db
ENV DATABASE_PORT=3306

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]