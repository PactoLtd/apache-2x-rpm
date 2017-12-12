#!groovy

pipeline {
  agent {
    docker { image 'centos:latest' }
  }

  environment {
    EPOCH = System.currentTimeMillis()
  }
    
  stages {
    stage('Clean') { 
      steps { 
        sh 'rm -f *.tar.gz'
        sh 'rm -rf httpd-*'
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
        sh './build.sh compile --epoch=${EPOCH}'
      }
    }
  }
}
