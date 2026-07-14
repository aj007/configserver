pipeline {
    agent any

    tools {
        // Automatically adds the Maven bin directory to the PATH
        maven 'LocalMaven'
    }

    environment {
        // Replace with your repository and image details
        GIT_REPO_URL    = 'https://github.com/aj007/configserver.git'
        GIT_BRANCH      = 'master'
        IMAGE_NAME      = 'configserver'
        IMAGE_TAG       = "${BUILD_NUMBER}"
        // REGISTRY_USER   = 'your-dockerhub-username' // Leave empty if deploying locally only

        // Path to your kubeconfig if Jenkins cannot find it automatically
        KUBECONFIG_PATH = 'C:\\ProgramData\\Jenkins\\.kube\\config'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Pulling latest code from Git...'
                git branch: "${ENVIRONMENT.GIT_BRANCH}",
                    url: "${ENVIRONMENT.GIT_REPO_URL}"
            }
        }

        stage('Maven Build') {
            steps {
                echo 'Building application with Maven...'
                // Using 'bat' since your Jenkins is running on Windows
                bat 'mvn clean install -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                bat "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy to Kubernetes (Docker Desktop)') {
            steps {
                echo 'Deploying to local Kubernetes cluster...'
                // Points kubectl to your Docker Desktop cluster config
                bat "kubectl --kubeconfig=${KUBECONFIG_PATH} apply -f k8s/deployment.yaml"

                // Force the deployment to pick up the newly built local image
                bat "kubectl --kubeconfig=${KUBECONFIG_PATH} set image deployment/${IMAGE_NAME} ${IMAGE_NAME}=${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs above for errors.'
        }
    }
}