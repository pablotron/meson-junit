pipeline {
  agent none

  stages {
    stage('ruby') {
      parallel {
        stage('build') {
          agent {
            dockerfile {
              filename 'Dockerfile.test'
            }
          }

          steps {
            sh 'gem build meson-junit.gemspec || true'
          }

          post {
            always {
              archiveArtifacts artifacts: '*.gem', fingerprint: true
            }
          }
        }

        stage('test') {
          agent {
            dockerfile {
              filename 'Dockerfile.test'
            }
          }

          environment {
            TESTOPTS = '--junit --junit-jenkins'
          }

          steps {
            sh 'rake test || true'

            // TODO:
            // * rubocop
            //   https://github.com/rubocop-hq/rubocop
          }

          post {
            always {
              junit 'report.xml'
            }
          }
        }

        stage('docs') {
          agent {
            dockerfile {
              filename 'Dockerfile.test'
            }
          }

          steps {
            sh 'rake docs && zip -r docs.zip docs || true'
          }

          post {
            always {
              archiveArtifacts artifacts: 'docs.zip', fingerprint: true
            }
          }
        }
      }
    }
  }
}
