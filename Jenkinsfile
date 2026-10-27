
pipeline {
    agent any

    environment {
        DOCKERHUB_USER = '15deepika'
        IMAGE_NAME = '15deepika/jenkins-static-app:latest'
    }

    stages {
        stage('Pull Code from GitHub') {
            steps {
                echo 'Getting latest source code from GitHub'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_TOKEN'
                    )
                ]) {
                    bat 'echo %DH_TOKEN% | docker login -u %DH_USER% --password-stdin'
                    bat 'docker push %IMAGE_NAME%'
                    bat 'docker logout'
                }
            }
        }

        stage('Deploy on Localhost') {
            steps {
                bat 'docker pull %IMAGE_NAME%'
                bat 'docker rm -f jenkins-static-app || exit /b 0'
                bat 'docker run -d --name jenkins-static-app -p 8081:80 %IMAGE_NAME%'
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Application deployed at http://localhost:8081'
        }
        failure {
            echo 'Pipeline failed. Check Console Output for errors.'
        }
    }
}
