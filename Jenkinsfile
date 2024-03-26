pipeline {
    agent any
    
    environment {
        ECR_REGISTRY = "877540899436.dkr.ecr.us-east-1.amazonaws.com"
        APP_REPO_NAME = "hasan05/to-do-webapp"
        KUBECONFIG = "/path/to/kubeconfig"
    }
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image'
                    sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:latest" .'
                    sh 'docker image ls'
                }
            }
        }
        
        stage('Push Image to ECR Repo') {
            steps {
                script {
                    echo 'Pushing Docker image to ECR'
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                    sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:latest"'
                }
            }
        }
        
        stage('Create Infrastructure') {
            steps {
                echo 'Creating infrastructure using Terraform'
                dir('infrastructure') {
                    sh '''
                        sed -i "s/clarus/$ANS_KEYPAIR/g" main.tf
                        terraform init
                        terraform apply -auto-approve -no-color
                       
                    '''
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Deploying to Kubernetes'
                    withEnv(["KUBECONFIG=${KUBECONFIG}"]) {
                        sh 'kubectl apply -f deployment.yml'
                        sh 'kubectl apply -f service.yml'
                    }
                }
            }
        }
        
        stage('Configure HPA') {
            steps {
                script {
                    echo 'Configuring HPA'
                    withEnv(["KUBECONFIG=${KUBECONFIG}"]) {
                        sh 'kubectl apply -f hpa-web.yaml'
                    }
                }
            }
        }
        
        stage('Destroy Infrastructure') {
            steps {
                echo 'Destroying infrastructure using Terraform'
                dir('infrastructure') {
                    sh 'terraform destroy -auto-approve -no-color'
                }
            }
        }
    }
}
