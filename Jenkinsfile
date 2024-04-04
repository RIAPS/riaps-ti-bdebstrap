pipeline {
  agent any
  options {
    buildDiscarder logRotator(daysToKeepStr: '30', numToKeepStr: '10')
  }
  stages {
    stage('build') {
      steps {
        sh 'sudo rm -rf tools/'
        sh 'chmod +x package.sh'
        sh './package.sh'
      }
    }
  }
  post {
    success {
      archiveArtifacts artifacts: 'build/riaps-am64-bookworm-*/*.wic.xz, logs/*.log', fingerprint: true
    }
  }
}