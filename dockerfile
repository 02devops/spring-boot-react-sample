# -----------------------------
# Stage 1: Build React App
# -----------------------------
FROM node:16 AS react-build

# Set working directory for frontend
WORKDIR /frontend

# Copy package files
COPY frontend/package*.json ./

# Install dependencies
RUN npm install

# Copy source files and build the React app
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

# Copy backend source files and build the Spring Boot application
COPY backend/src ./src
RUN mvn clean package -DskipTests

# -----------------------------
# Stage 3: Serve both with Nginx
# -----------------------------
FROM openjdk:11-jdk-slim AS final

# Set working directory for final stage
WORKDIR /app

# Copy the Spring Boot jar file to final stage
COPY --from=springboot-build /backend/target/*.jar /app/backend.jar

# Copy the built React app to final stage and serve it with Nginx
COPY --from=react-build /frontend/build /usr/share/nginx/html

# Expose port for backend and frontend
EXPOSE 8080
EXPOSE 80

# Start both React (Nginx) and Spring Boot (Java) apps in parallel
CMD java -jar /app/backend.jar & nginx -g 'daemon off;'
