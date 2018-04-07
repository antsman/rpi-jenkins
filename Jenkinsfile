pipeline {
    agent any
    environment {
        DOCKER_CREDS = credentials('DOCKER_HUB_CREDS')
        IMAGE_NAME = 'antsman/rpi-jenkins'
        IMAGE_TAG = 'jenkins-build'
    }
    stages {
        stage('BUILD') {
            steps {
                sh './get-jenkins.sh'   // Get also Jenkins-Version from META-INF/MANIFEST.MF in jenkins.war
                load "$WORKSPACE/env.properties"
                echo "JENKINS_VERSION=$JENKINS_VERSION"
/*
                sh 'ls -la'
                sh 'env'
*/
            }
        }
        stage('TEST') {
            steps {
                echo "JENKINS_VERSION=$JENKINS_VERSION"
            }
        }
        stage('DEPLOY') {
            when {
                branch 'master'
            }
            steps {
                echo 'Build succeeded, push image ..'
/*
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest"
                sh "docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW"
                sh "docker push $IMAGE_NAME:latest"
*/
            }
        }
    }
}
