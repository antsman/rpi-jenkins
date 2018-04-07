node {
    sh './get-jenkins.sh'
    sh 'ls -la'
    sh 'env'
    echo "$WORKSPACE/env.properties"
    load "$WORKSPACE/env.properties"
    echo "$JENKINS_VERSION"
    sh 'env'
}
