pipeline {
  agent {
          label 'fargate'    #Must match with the label value under ECS agent templete.
  }

  stages {
    stage('Test') {  
        steps {
            sh 'echo hello from shell'
            sh 'pwsh -c echo "hello from powershell"'
        }
    }
  }
}
