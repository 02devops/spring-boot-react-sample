pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "myapp"  // The name of your Docker image
        GIT_URL = "https://github.com/02devops/spring-boot-react-sample.git"  // GitHub URL
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout code from the GitHub repository
                git url: "$GIT_URL", branch: 'main'  // You can change the branch as needed
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image locally using the Dockerfile
                    sh 'docker build -t $DOCKER_IMAGE_NAME .'
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                script {
                    // Run the Docker container (adjust ports if necessary)
                    sh "docker run -d -p 8080:8080 -p 80:80 $DOCKER_IMAGE_NAME"
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after the build
        }
    }
}
