pipeline {
    agent any 
    currentBuild.result = "SUCCESS"
    epoch = System.currentTimeMillis()

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
              sh 'sudo ./build.sh compile --epoch='+epoch
              sh 'sudo chown -R ec2-user:ec2-user *'
            }
        }
        stage('Release') {
          sh echo 'nothing implemented'
        }
    }
}
