pipeline {
  agent any

  environment {
    EC2_HOST = "ubuntu@3.237.41.230"
    APP_DIR = "flask-mysql-ci-cd"
    DB_NAME = "appdb"
    DB_USER = "appuser"
  }

  stages {
    stage('Test') {
      steps {
       sh '''
        cd ~/flask-mysql-devops-pipeline

        sudo apt update
        sudo apt install -y python3-venv python3-pip
        python3 -m venv venv
        source venv/bin/activate
        pip install --upgrade pip
        pip install pytest
        PYTHONPATH=$(pwd) pytest tests/

        pytest tests/

      '''
      }
    }


    stage('Build Docker Image') {
      steps {
        sh 'docker build -t flask-app ./app'
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
