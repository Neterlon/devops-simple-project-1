pipeline {
    tools {
        maven "mvn3.8.7"
        jdk "jdk17"
    }
    agent {label 'jenkins-node-1'}
    environment {
        DOCKERHUB_CREDENTIALS = credentials("dockerhub-creds")
        DOCKERHUB_REPOSITORY = "vladyslavteron/fff"
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
                    git branch: 'docker', url: 'git@github.com:Neterlon/devops-simple-project-1.git'
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
                sh 'docker build -t ${DOCKERHUB_REPOSITORY}:${BUILD_ID} .'
            }
        }
        stage("DockerHub Upload") {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push ${DOCKERHUB_REPOSITORY}:${BUILD_ID}'
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}