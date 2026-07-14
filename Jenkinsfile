pipeline {
    agent any

    tools {
        // Automatically installs and configures the Maven tool named 'Maven3' in Jenkins
        maven 'Maven3'
        // Automatically installs and configures the JDK tool named 'JDK17' in Jenkins
        jdk 'JDK17'
    }

    environment {
        // Defines the app name for easier organization later
        APP_NAME = 'configserver'
    }

    stages {
        stage('Checkout') {
            steps {
                // Fetches code from your repository. 
                // Jenkins automatically handles this stage if you use a Pipeline from SCM job.
                checkout scm
            }
        }

        stage('Clean & Compile') {
            steps {
                echo 'Compiling the application...'
                sh 'mvn clean compile'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running unit tests...'
                sh 'mvn test'
            }
            post {
                always {
                    // Captures and displays unit test results in the Jenkins UI
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package Application') {
            steps {
                echo 'Packaging application into a JAR file...'
                // Skips tests here since they ran in the previous stage
                sh 'mvn package -DskipTests'
            }
        }
    }

    post {
        success {
            echo "Archiving build artifacts..."
            // Saves the generated JAR file in Jenkins so you can download it later
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            echo "🎉 Build completed successfully!"
        }
        failure {
            echo "❌ Build failed. Please check the console logs."
        }
    }
}