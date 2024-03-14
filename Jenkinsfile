pipeline {
  agent any
  options {
    buildDiscarder logRotator(daysToKeepStr: '30', numToKeepStr: '10')
  }
  stages {
    stage('build') {
      steps {
        sh 'chmod +x package.sh'
        sh './package.sh'
      }
    }
  }
  post {
    success {
      archiveArtifacts artifacts: '*.tar.xz', fingerprint: true
    }
  }
}