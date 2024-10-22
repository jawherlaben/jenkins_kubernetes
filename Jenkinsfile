pipeline {
    agent any
    tools {
        maven 'maven_3_5_0'
    }
    stages {
        stage('Build Maven') {
    steps {
        checkout scm: [
            $class: 'GitSCM', 
            branches: [[name: '*/main']], 
            userRemoteConfigs: [[
                url: 'https://github.com/jawherlaben/devops-integration',
                credentialsId: 'github-token'
            ]]
        ]
    }
        }
        stage('Build docker image') {
            steps {
                script {
                    sh 'docker build -t /devops-integration .'
                }
            }
        }
        stage('Push image to Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                        sh 'docker login -u jawherlabben -p ${dockerhubpwd}'
                    }
                    sh 'docker push jawherlabben/devops-integration'
                }
            }
        }
        stage('Deploy to k8s') {
            steps {
                script {
                    kubernetesDeploy(configs: 'deploymentservice.yaml', kubeconfigId: 'k8sconfigpwd')
                }
            }
        }
    }
}
