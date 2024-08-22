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
      def am64version = sh(script: '. ./version.sh && echo $version', returnStdout: true).trim()
      archiveArtifacts artifacts: 'build/${am64version}/*.wic.xz, logs/*.log', fingerprint: true
    }
  }
}