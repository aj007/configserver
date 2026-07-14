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
                    echo "Pulling latest code from Git branch: ${env.GIT_BRANCH}..."
                    git branch: "${env.GIT_BRANCH}",
                        url: "${env.GIT_REPO_URL}"
                }
            }

            stage('Maven Build') {
                steps {
                    echo 'Building application with Maven...'
                    // Using 'bat' since Jenkins is running on Windows
                    bat 'mvn clean install -DskipTests'
                }
            }

            stage('Build Docker Image') {
                steps {
                    echo 'Building Docker image...'
                    bat "docker build -t ${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
                    bat "docker tag ${env.IMAGE_NAME}:${env.IMAGE_TAG} ${env.IMAGE_NAME}:latest"
                }
            }

            stage('Deploy to Kubernetes (Docker Desktop)') {
                steps {
                    echo 'Deploying to local Kubernetes cluster...'
                    // Applies the deployment manifest
                    bat "kubectl --kubeconfig=${env.KUBECONFIG_PATH} apply -f k8s/deployment.yaml"

                    // Forces the deployment to pull the newly built local image tag
                    bat "kubectl --kubeconfig=${env.KUBECONFIG_PATH} set image deployment/${env.IMAGE_NAME} ${env.IMAGE_NAME}=${env.IMAGE_NAME}:${env.IMAGE_TAG}"
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