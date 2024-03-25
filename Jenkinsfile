pipeline {
    agent any
    environment {
        ECR_REGISTRY = "877540899436.dkr.ecr.us-east-1.amazonaws.com"
        APP_REPO_NAME= "hasan05/to-do-webapp"
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:latest" .'
                sh 'docker image ls'
            }
        }
        stage('Push Image to ECR Repo') {
            steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Kubernetes Deployment ve Service YAML dosyalarını uygula
                    withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://54.242.69.228']) {
                        sh 'kubectl apply -f deployment.yml -f service.yml'
                    }
                }
            }
        }   
        stage('Configure HPA') {
            steps {
                script {
                    // HorizontalPodAutoscaler YAML dosyasını uygula
                    withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://54.242.69.228']) {
                        sh 'kubectl apply -f hpa.yml'
                    }
                }
            }
        }
    }
}
