pipeline {
    agent any
    tools {
        maven 'maven_3_5_0'
    }
    stages {
        stage('Build Maven') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/jawherlaben/devops-automation-main']]])
                sh 'mvn clean install'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t jawherlabben/pipeline:latest .'
                }
            }
        }
        stage('Push Docker Image to Hub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                        sh """
                            echo ${dockerhubpwd} | docker login -u jawherlabben --password-stdin
                            docker push jawherlabben/pipeline:latest
                        """
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
}
