pipeline {
    agent any
    
    parameters {
        string(name: 'strVersao',
            defaultValue: 'stable',
            description: 'Número da Versão')
    }    
    
    environment{
        def dockerHome = "/usr" //tool name: 'dockerTool', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
        def dockerExec = "${dockerHome}/bin/docker"  
        def awsExec = "/usr/local/bin/aws"
        def hadolintExec = "/bin/hadolint"
    }
    
    stages {
        stage('SCM Checkout'){
            steps{
                sh "echo Realizando checkout"
                git credentialsId: 'git-credential', url: 'https://github.com/Waelson/Python-Application-Containerization'
            }
        }
        
        stage('Lint'){
            steps{
                sh "echo Lint Dockerfile"
                sh "${hadolintExec} Dockerfile"
            }
        }
        
        stage('Build Image'){
            steps{
                sh "echo Construindo imagem Docker"
                sh "${dockerExec} build --tag=thedevices/app-python-demo:${params.strVersao} ."
            }
        }
        
        stage('Push Image to DockerHub'){
            steps{
                withCredentials([string(credentialsId: 'dockerhub-credential', variable: 'dockerHubPassword')]) {
                    sh "echo Realizando login no DockerHub"
                    sh "${dockerExec} login -u thedevices -p ${dockerHubPassword}"
                    sh "echo Enviando imagem para o DockerHub"
                    sh "${dockerExec} push thedevices/app-python-demo:${params.strVersao}"
                    sh "echo Push realiado com sucesso!!!"
                }
            }
        }
        
        stage('Push Image to ECS'){
            steps{
                sh "echo Realizando login no ECR"
                sh "${awsExec} ecr get-login-password --region us-west-2 | ${dockerExec} login --username AWS --password-stdin 053455162894.dkr.ecr.us-west-2.amazonaws.com/app-python-demo"
                sh "${dockerExec} build --tag=app-python-demo:${params.strVersao} ."
                sh "${dockerExec} tag app-python-demo:${params.strVersao} 053455162894.dkr.ecr.us-west-2.amazonaws.com/app-python-demo:${params.strVersao}"
                sh "${dockerExec} push xxxxxxxxx.dkr.ecr.us-west-2.amazonaws.com/app-python-demo:${params.strVersao}"                
            }
        }
    }    
    
    /*
    post{
        success{
            mail to: 'xxxxxx@gmail.com', subject: '[Pipeline] Python - SUCESSO',
                body: 'A execução do pipeline PYTHON foi executado com sucesso.'
        }
    }
    */
}
