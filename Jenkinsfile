pipeline {
    tools {
        maven "mvn3.8.7"
        jdk "jdk17"
    }
    agent {label 'jenkins-node-1'}
    environment {
        DOCKERHUB_CREDENTIALS = credentials("dockerhub-creds")  // DockerHub credentials
        DOCKERHUB_REPOSITORY = "DOCKERHUB_REPOSITORY"     // Where to deploy docker image
        MYSQL_SERVER = "localhost"        // Address of a MySQL server to run some unit tests
        AWS_DEFAULT_REGION = "us-east-1"  // AWS Region where an EKS cluster is deployed
    }
    stages {
        stage("Clone GIT") {
            steps {
                sh "mkdir -p app-repo"
                dir("app-repo") {
                    git branch: 'main', url: 'https://github.com/Neterlon/spring-petclinic.git'
                }
                sh "mkdir -p devops-repo"
                dir("devops-repo") {
                    git branch: 'main', url: 'https://github.com/Neterlon/spring-petclinic-devops.git'
                }
            }
        }
        stage("Build") {
            steps {
                sh "mkdir -p artifact"
                dir("app-repo") {
                    sh 'mvn package -Dmaven.test.skip=true'
                }
                sh "cp app-repo/target/*.war artifact/ROOT.war"
            }
        }
        stage("Unit Testing") {
            steps {
                dir("app-repo") {
                    sh 'mvn test'
                }
            }
        }
        stage("Application containerization") {
            steps {
                sh "rm -f Dockerfile && ln -s devops-repo/Dockerfile ./Dockerfile"
                sh 'docker build -t ${DOCKERHUB_REPOSITORY}:${BUILD_ID} -t ${DOCKERHUB_REPOSITORY}:latest .'
            }
        }
        stage("DockerHub Upload") {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push ${DOCKERHUB_REPOSITORY}:${BUILD_ID}'
                sh 'docker push ${DOCKERHUB_REPOSITORY}:latest'
            }
        }
        stage("Deployment") {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'aws-jenkins-access', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID'), 
                    file(credentialsId: 'eks-cluster-access', variable: 'KUBECONFIG')]) {
                        sh 'kubectl rollout restart deployment app-deployment'
                }
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}