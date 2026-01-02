pipeline {
  agent any

  environment {
    EC2_HOST = "ubuntu@100.48.76.244"
    APP_DIR = "flask-mysql-ci-cd"
    DB_NAME = "appdb"
    DB_USER = "appuser"
  }

  stages {
    stage('Test') {
     steps {
        sh '''
          #!/bin/bash
          python3 -m venv venv
          . venv/bin/activate
          pip install --upgrade pip
          pip install -r requirements.txt
          export PYTHONPATH=$(pwd)
          pytest tests/
        '''
      }
    }


    stage('Build Docker Image') {
      steps {
        sh 'docker build -t flask-app .'
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent(['EC2_SSH_KEY']) {
          withCredentials([
            string(credentialsId: 'DB_PASSWORD', variable: 'DB_PASSWORD'),
            string(credentialsId: 'DB_ROOT_PASSWORD', variable: 'DB_ROOT_PASSWORD')
          ]) {
            sh '''
              rsync -avz . ${EC2_HOST}:${APP_DIR}
              ssh ${EC2_HOST} "
                export DB_NAME=${DB_NAME}
                export DB_USER=${DB_USER}
                export DB_PASSWORD=${DB_PASSWORD}
                export DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
                cd ${APP_DIR} && ./deploy.sh
              "
            '''
          }
        }
      }
    }
  }
}
