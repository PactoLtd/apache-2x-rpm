#!groovy

pipeline {
    agent any 

    environment {
      currentBuild.result = "SUCCESS"
      EPOCH = System.currentTimeMillis()
    }
    
    stages {
        stage('Clean') { 
            steps { 
              sh 'sudo rm -f *.tar.gz'
              sh 'sudo rm -rf httpd-*'
            }
        }
        stage('Checkout'){
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
              sh 'pwd'
              sh 'ls -lah'
              sh 'sudo ./build.sh compile --epoch=${EPOCH}'
            }
        }
        stage('Release') {
          steps{
            sh echo 'nothing implemented'
          }
        }
    }
}
