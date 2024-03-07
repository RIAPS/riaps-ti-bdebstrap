pipeline {
  agent any
  options {
    buildDiscarder logRotator(daysToKeepStr: '30', numToKeepStr: '10')
  }
  stages {
    stage('build') {
      steps {
        sh 'source version.sh'
        sh 'chmod +x build.sh'
        sh 'sudo ./build.sh $am64version'
      }
    }
  }
  post {
    success {
      archiveArtifacts artifacts: '*.tar.xz', fingerprint: true
    }
  }
}