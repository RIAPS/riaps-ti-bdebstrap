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
      script {
        env.AM64VERSION = sh(script: '. ./version.sh && echo $version', returnStdout: true).trim()
        echo "Pipeline succeeded with version ${env.AM64VERSION}"
      }
      archiveArtifacts artifacts: 'build/${env.AM64VERSION}/*.wic.xz, logs/*.log', fingerprint: true
    }
  }
}