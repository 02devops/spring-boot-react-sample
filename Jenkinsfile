pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "myapp"
        DOCKER_REGISTRY = "docker.io/dharam3030"  // Updated Docker registry URL with your username
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
                    // Build the Docker image using the multi-stage Dockerfile
                    sh 'docker build -t $DOCKER_IMAGE_NAME -f Dockerfile .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Tag and push the Docker image to Docker Hub
                    sh "docker tag $DOCKER_IMAGE_NAME $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME"
                    sh "docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME"
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                script {
                    // Pull the latest Docker image from the Docker registry
                    sh "docker pull $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME"

                    // Run the Docker container (adjust ports if necessary)
                    sh "docker run -d -p 8080:8080 -p 80:80 $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME"
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
