#!groovy

node('ops') {

  currentBuild.result = "SUCCESS"
  epoch = System.currentTimeMillis()

  stage 'Clean'
    sh 'sudo rm -f *.tar.gz'
    sh 'sudo rm -rf httpd-*'
    
  stage 'Checkout'
    checkout scm
      
  stage 'Build'
    sh 'pwd'
    sh 'ls -lah'
    sh 'sudo ./build.sh compile --epoch='+epoch
    sh 'sudo chown -R ec2-user:ec2-user *'

  stage 'Release'  
    sh echo 'nothing implemented'

}