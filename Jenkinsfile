pipeline {
    agent any
    tools {
        maven 'maven_3_5_0'
    }
    stages {
        stage('Build Maven') {
            steps {
                // Cloner et construire le projet Maven
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/jawherlaben/jenkins_kubernetes']]])
                sh 'mvn clean install'
            }
        }
        

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(
                    caCertificate: '', 
                    clusterName: 'minikube', 
                    contextName: 'minikube', 
                    credentialsId: 'minikube-jenkins-secret', 
                    namespace: '', 
                    restrictKubeConfigAccess: false, 
                    serverUrl: 'https://192.168.49.2:8443'  
                ) {
                    sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"'  
                    sh 'chmod u+x ./kubectl' 
                    sh "./kubectl version --client" 
                    sh './kubectl apply -f deploymentservice.yaml'
                }
            }
        }
        
 

    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

