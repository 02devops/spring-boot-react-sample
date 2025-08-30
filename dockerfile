# -----------------------------
# Stage 1: Build React App
# -----------------------------
FROM node:16 AS react-build

# Set working directory for frontend
WORKDIR /frontend

# Clone the React frontend code from GitHub (via the Jenkins build)
COPY frontend/package*.json ./
RUN npm install

# Copy React app files and build
COPY frontend/ ./
RUN npm run build

# -----------------------------
# Stage 2: Build Spring Boot App
# -----------------------------
FROM maven:3.8-openjdk-11-slim AS springboot-build

# Set working directory for backend
WORKDIR /backend

# Copy pom.xml and install dependencies
COPY backend/pom.xml ./
RUN mvn dependency:go-offline

# Copy Spring Boot source files and build the Spring Boot application
COPY backend/src ./src
RUN mvn clean package -DskipTests

# -----------------------------
# Stage 3: Final Image with Nginx + Spring Boot
# -----------------------------
FROM openjdk:11-jdk-slim AS final

# Set working directory for final stage
WORKDIR /app

# Copy the Spring Boot jar file from the build stage
COPY --from=springboot-build /backend/target/*.jar /app/backend.jar

# Copy the built React app from the build stage and serve it with Nginx
COPY --from=react-build /frontend/build /usr/share/nginx/html

# Expose ports for frontend and backend
EXPOSE 8080
EXPOSE 80

# Start both React (Nginx) and Spring Boot (Java) apps
CMD java -jar /app/backend.jar & nginx -g 'daemon off;'
