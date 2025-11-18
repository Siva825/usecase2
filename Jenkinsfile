pipeline {  
    agent any  
    environment {  
        DOCKERHUB_CREDENTIALS = credentials('docker-creds')  
    }  
    stages {  
        stage('checkout') {  
            steps {  
                echo "*********** cloning the code **********"  
                sh 'rm -rf usecase2 || true'  
                sh 'git clone https://github.com/Siva825/usecase2.git' 
            }  
        }   
        stage('Docker image build') {  
            steps {  
                echo "********** building is done ************"  
                dir('usecase2') {  
                    sh 'docker build -t siva2626/flask2:v1 .'  
                }  
            }  
        }
        stage('Push to Docker Hub') {  
            steps {  
                sh """  
                docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}  
                docker push siva2626/flask2:v1  
                """  
            }  
        }
        stage('vm creation using Terraform') {
            steps {
                echo "********** VM creation is done ************"
                dir('usecase2') {
                    sh 'terraform init'
                    sh 'terraform apply --auto-approve'  
                }
            }
        }
    }  
}
