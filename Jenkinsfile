versions = ['12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22']

pipeline {

    agent { label 'docker-agent' }

    stages {
        stage ( "Building") {
            steps {
                script {
                    versions.each { version ->
                        docker.withRegistry('', 'docker-hub-credentials') {
                            stage("version ${version}") {
                                sh "make build v=${version}"
                                sh "make push v=${version}"
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'make remove'
            }
        }
        cleanup {
            cleanWs()
        }
    }
}
