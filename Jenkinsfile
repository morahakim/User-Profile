pipeline {
    agent any

    environment {
        APP_NAME = "UserProfile"
        // tambahkan environment lain kalau perlu
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "Checked out branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Build') {
            steps {
                echo "Building ${env.APP_NAME} on branch ${env.BRANCH_NAME}"

                script {
                    if (env.BRANCH_NAME == 'develop') {
                        echo "Running build for development"
                        // sh 'build-dev.sh' atau langsung perintah build
                    } else if (env.BRANCH_NAME == 'staging') {
                        echo "Running build for staging"
                        // sh 'build-staging.sh'
                    } else if (env.BRANCH_NAME == 'main') {
                        echo "Running build for production"
                        // sh 'build-prod.sh'
                    } else {
                        echo "Build not configured for this branch"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo "Running tests on branch ${env.BRANCH_NAME}"

                script {
                    // Bisa pakai satu jenis test untuk semua, atau pisahkan
                    // sh './run_tests.sh'
                }
            }
        }

        stage('Deploy') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'staging'
                    branch 'main'
                }
            }
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        echo "Deploying to DEVELOPMENT environment"
                        // sh 'deploy-dev.sh'
                    } else if (env.BRANCH_NAME == 'staging') {
                        echo "Deploying to STAGING environment"
                        // sh 'deploy-staging.sh'
                    } else if (env.BRANCH_NAME == 'main') {
                        echo "Deploying to PRODUCTION environment"
                        // sh 'deploy-prod.sh'
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build & deploy success for ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Build failed for ${env.BRANCH_NAME}"
        }
    }
}
