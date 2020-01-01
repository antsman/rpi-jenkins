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
        stage('GET JENKINS & DOCKER') {
            steps {
                sh './get-jenkins-docker.sh'
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
                echo 'Sleep to allow Jenkins to start'
                sh 'date'
                sleep 120
                sh "./get-versions.sh $CONTAINER_NAME"	// Get jenkins, java, docker version in started container, store in version.properties
                load './version.properties'
                echo "$JENKINS_VERSION"
                echo "$JAVA_VERSION"
                echo "$DOCKER_VERSION"
                sh 'date'
                sh "docker exec -t $CONTAINER_NAME wget --spider http://localhost:8080 | grep -e connected -e Forbidden"
                sh "time docker stop $CONTAINER_NAME"
            }
        }
        stage('PUSH') {
            when {
                branch 'master'
            }
            steps {
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION-$JAVA_VERSION"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION-$JAVA_VERSION-$DOCKER_VERSION"

                sh "docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW"

                sh "docker push $IMAGE_NAME:latest"
                sh "docker push $IMAGE_NAME:$JENKINS_VERSION"
                sh "docker push $IMAGE_NAME:$JENKINS_VERSION-$JAVA_VERSION"
                sh "docker push $IMAGE_NAME:$JENKINS_VERSION-$JAVA_VERSION-$DOCKER_VERSION"
            }
        }
    }
    post {
        failure {
            sh "docker rm -f $CONTAINER_NAME"
        }
    }
}
