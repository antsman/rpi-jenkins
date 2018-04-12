#!/groovy

pipeline {
    agent any
    environment {
        DOCKER_CREDS = credentials('DOCKER_HUB_CREDS')
        IMAGE_NAME = 'antsman/rpi-jenkins'
        IMAGE_TAG = "ci-jenkins-$BRANCH_NAME"
        CONTAINER_NAME = "$BUILD_TAG"
    }
     stages {
        stage('GET JENKINS') {
            steps {
                sh './get-jenkins.sh'   // Get also Jenkins-Version from META-INF/MANIFEST.MF in jenkins.war
                load './env.properties'
                echo "JENKINS_VERSION=$JENKINS_VERSION"
            }
        }
        stage('BUILD') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }
        stage('TEST') {
            steps {
                sh "docker run -d --rm --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG"
                sh "docker exec -t --user root $CONTAINER_NAME sh -c 'apt-get -qq update && apt-get -qq -y install wget'"
                sh 'date'
                sh "docker exec -t $CONTAINER_NAME wget --connect-timout=3600 --timout=3600 --spider http://localhost:8080"
                sh "time docker stop $CONTAINER_NAME"
            }
        }
        stage('DEPLOY') {
            when {
                branch 'master'
            }
            steps {
                echo 'Build succeeded, push image ..'
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION"
/*
                sh "docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW"
                sh "docker push $IMAGE_NAME:latest"
                sh "docker push $IMAGE_NAME:$JENKINS_VERSION"
*/
            }
        }
    }
    post {
        failure {
            sh "docker rm -f $CONTAINER_NAME"
        }
    }
}
