pipeline {
  agent any
  options {
    buildDiscarder logRotator(daysToKeepStr: '30', numToKeepStr: '50')
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
        env.AM64VERSION = sh(script: '. ./version.sh && echo $am64version', returnStdout: true).trim()
        echo "Pipeline succeeded with version ${env.AM64VERSION}"
        def artifactsItems = "build/${env.AM64VERSION}/*.wic.xz, logs/*.log"
        archiveArtifacts artifacts: artifactsItems, fingerprint: true
      }
    }
  }
}