pipeline {
    agent any
    
    environment {
        ECR_REGISTRY = "877540899436.dkr.ecr.us-east-1.amazonaws.com"
        DOCKERFILE_DIR = "/home/ec2-user/deneme"
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                sh "docker build -t $ECR_REGISTRY/microservice:latest $DOCKERFILE_DIR"
            }
        }
        
        stage('Push Image to ECR') {
            steps {
                echo 'Pushing Docker image to ECR'
                sh "docker push $ECR_REGISTRY/microservice:latest"
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes'
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
        
        stage('Setup Horizontal Pod Autoscaler') {
            steps {
                echo 'Setting up Horizontal Pod Autoscaler'
                sh 'kubectl apply -f hpa.yaml'
            }
        }
    }
}
