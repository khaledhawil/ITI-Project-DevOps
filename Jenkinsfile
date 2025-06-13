#!/usr/bin/env groovy
library 'identifier' : 'jenkins-shared-library@master','retriever': modernSCM(
    [
        $class: 'GitSCMSource',
        remote: 'https://gitlab.com/AbdelrahmanElshahat/jenkins-shared-library.git',
        // credentials: 'gitlab-credentials'
    ]
)
pipeline{
    agent any 
    tools {
        nodejs 'my-nodejs'
    }
    environment {
       DISCORD_WEBHOOK_URL = credentials('discord')
    }
    stages{
        stage("Detect Changes"){
            steps{
                script {
                    def changes = sh(script: 'git diff --name-only HEAD~1', returnStdout: true).trim()
                    env.BUILD_FRONTEND = changes.contains('frontend/') ? 'true' : 'false'
                    env.BUILD_BACKEND = changes.contains('backend/') ? 'true' : 'false'
                }
            }
        }
        stage("build frontend"){
            when {
                anyOf {
                    environment name: 'BUILD_FRONTEND', value: 'true'
                }
            }
            steps{
                script {
                    dir('frontend'){
                        buildNodejs()
                        incrementNodejsVersion()
                    }
                }
            }
        }
        stage("build backend"){
            when {
                anyOf {
                    environment name: 'BUILD_BACKEND', value: 'true'
                }
            }
            steps{
                script {
                    dir('backend'){
                        buildNodejs()
                        incrementNodejsVersion()
                    }
                }
            }
        }
        stage("push version"){
            steps{
                echo "========executing push version stage========"
                script {
                    pushVersionToGit()
                }
            }
        }
        stage("build backend image"){
            when {
                anyOf {
                    environment name: 'BUILD_BACKEND', value: 'true'
                }
            }
            steps{
                echo "========executing build backend image stage========"
                script {
                    dir('backend'){
                    def version = getVersionFromPackageJson()
                    def buildTag = "${version}-build.${env.BUILD_NUMBER}"
                    echo "Building backend image with tag: ${buildTag}"
                    buildImage "khaledhawil/my-app:itiBack-${buildTag}"
                    env.BACKEND_IMAGE_TAG = buildTag
                    }
                }
            }
        }
        stage("build frontend image"){
            when {
                anyOf {
                    environment name: 'BUILD_FRONTEND', value: 'true'
                }
            }
            steps{
                echo "========executing build frontend image stage========"
                script {
                    dir('frontend') {
                        def version = getVersionFromPackageJson()
                        def buildTag = "${version}-build.${env.BUILD_NUMBER}"
                        echo "Building frontend image with tag: ${buildTag}"
                        buildImage "khaledhawil/my-app:itiFront-${buildTag}"
                        env.FRONTEND_IMAGE_TAG = buildTag
                    }
                }
            }
        }
        stage("docker Login"){
            steps{
                echo "========executing docker login stage========"
                script {
                    dockerLogin()
                }
            }
        }
        stage("push Frontend Image"){
            when {
                anyOf {
                    environment name: 'BUILD_FRONTEND', value: 'true'
                }
            }
            steps{
                echo "========executing push frontend image stage========"
                script {
                    def buildTag = env.FRONTEND_IMAGE_TAG
                    echo "Pushing frontend image with tag: ${buildTag}"
                    dockerPush "khaledhawil/my-app:itiFront-${buildTag}"
                }
            }
        }
        stage("push Backend Image"){
            when {
                anyOf {
                    environment name: 'BUILD_BACKEND', value: 'true'
                }
            }
            steps{
                echo "========executing push backend image stage========"
                script {
                    def buildTag = env.BACKEND_IMAGE_TAG
                    echo "Pushing backend image with tag: ${buildTag}"
                    dockerPush "khaledhawil/my-app:itiBack-${buildTag}"
                }
            }
        }
        stage("Update K8s Manifests"){
            when {
                anyOf {
                    environment name: 'BUILD_FRONTEND', value: 'true'
                    environment name: 'BUILD_BACKEND', value: 'true'
                }
            }
            steps{
                echo "========executing update k8s manifests stage========"
                script {
                    // Debug: Show current environment values
                    echo "BUILD_FRONTEND: ${env.BUILD_FRONTEND}"
                    echo "BUILD_BACKEND: ${env.BUILD_BACKEND}"
                    
                    // Update frontend image tag if frontend was built
                    if (env.BUILD_FRONTEND == 'true') {
                        def frontendBuildTag = env.FRONTEND_IMAGE_TAG
                        def newFrontendImage = "khaledhawil/my-app:itiFront-${frontendBuildTag}"
                        
                        echo "Frontend build tag: ${frontendBuildTag}"
                        echo "New frontend image: ${newFrontendImage}"
                        
                        // Show current content before update
                        sh "echo 'Current frontend.yaml content:' && grep 'image:' k8s/frontend.yaml"
                        
                        sh """
                            sed -i 's|image: khaledhawil/my-app:itiFront-.*|image: ${newFrontendImage}|g' k8s/frontend.yaml
                            echo "Updated frontend image to: ${newFrontendImage}"
                        """
                        
                        // Show content after update
                        sh "echo 'Updated frontend.yaml content:' && grep 'image:' k8s/frontend.yaml"
                    }
                    
                    // Update backend image tag if backend was built
                    if (env.BUILD_BACKEND == 'true') {
                        def backendBuildTag = env.BACKEND_IMAGE_TAG
                        def newBackendImage = "khaledhawil/my-app:itiBack-${backendBuildTag}"
                        
                        echo "Backend build tag: ${backendBuildTag}"
                        echo "New backend image: ${newBackendImage}"
                        
                        // Show current content before update
                        sh "echo 'Current backend.yaml content:' && grep 'image:' k8s/backend.yaml"
                        
                        sh """
                            sed -i 's|image: khaledhawil/my-app:itiBack-.*|image: ${newBackendImage}|g' k8s/backend.yaml
                            echo "Updated backend image to: ${newBackendImage}"
                        """
                        
                        // Show content after update
                        sh "echo 'Updated backend.yaml content:' && grep 'image:' k8s/backend.yaml"
                    }
                    
                    // Show git status
                    sh """
                        echo "Git status before commit:"
                        git status
                        echo "Git diff for k8s files:"
                        git diff k8s/frontend.yaml k8s/backend.yaml || true
                    """
                    
                    // Commit and push the updated K8s manifests for GitOps
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        sh """
                            git config --global user.email "jenkins@devops.local"
                            git config --global user.name "Jenkins"
                            git add k8s/frontend.yaml k8s/backend.yaml
                            
                            if git diff --staged --quiet; then
                                echo "No changes detected in K8s files"
                            else
                                git commit -m "Update K8s image tags - Build #${env.BUILD_NUMBER}"
                                echo "K8s manifests committed with new image tags"
                                
                                # Set up authentication for git push
                                git remote set-url origin https://\${GIT_USERNAME}:\${GIT_PASSWORD}@github.com/khaledhawil/ITI-Project-DevOps.git
                                
                                # Push changes to remote repository
                                echo "Pushing changes to remote repository..."
                                git push origin HEAD:master
                                echo "Successfully pushed K8s manifest updates to repository"
                            fi
                        """
                    }
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
            script {
                def changes = []
                if (env.BUILD_FRONTEND == 'true') {
                    changes.add('Frontend')
                }
                if (env.BUILD_BACKEND == 'true') {
                    changes.add('Backend')
                }
                def changesText = changes.size() > 0 ? changes.join(' & ') : 'No changes detected'
                
                def payload = """
                {
                    "embeds": [
                        {
                            "title": "✅ Pipeline Build Successful",
                            "description": "Build completed successfully for: ${changesText}",
                            "color": 65280,
                            "timestamp": "${new Date().format("yyyy-MM-dd'T'HH:mm:ss'Z'")}",
                            "fields": [
                                {
                                    "name": "Job Name",
                                    "value": "${env.JOB_NAME}",
                                    "inline": true
                                },
                                {
                                    "name": "Build Number",
                                    "value": "#${env.BUILD_NUMBER}",
                                    "inline": true
                                },
                                {
                                    "name": "Status",
                                    "value": "SUCCESS",
                                    "inline": true
                                },
                                {
                                    "name": "Duration",
                                    "value": "${currentBuild.durationString}",
                                    "inline": true
                                },
                                {
                                    "name": "Build URL",
                                    "value": "[View Build](${env.BUILD_URL})",
                                    "inline": false
                                }
                            ],
                            "footer": {
                                "text": "Jenkins CI/CD Pipeline",
                                "icon_url": "https://wiki.jenkins.io/download/attachments/2916393/logo.png"
                            }
                        }
                    ]
                }
                """
                
                sh """
                    curl -H "Content-Type: application/json" \\
                         -X POST \\
                         -d '${payload}' \\
                         "${env.DISCORD_WEBHOOK_URL}"
                """
            }
        }
        failure{
            echo "========pipeline execution failed========"
            script {
                def changes = []
                if (env.BUILD_FRONTEND == 'true') {
                    changes.add('Frontend')
                }
                if (env.BUILD_BACKEND == 'true') {
                    changes.add('Backend')
                }
                def changesText = changes.size() > 0 ? changes.join(' & ') : 'No changes detected'
                
                def payload = """
                {
                    "embeds": [
                        {
                            "title": "❌ Pipeline Build Failed",
                            "description": "Build failed for: ${changesText}",
                            "color": 16711680,
                            "timestamp": "${new Date().format("yyyy-MM-dd'T'HH:mm:ss'Z'")}",
                            "fields": [
                                {
                                    "name": "Job Name",
                                    "value": "${env.JOB_NAME}",
                                    "inline": true
                                },
                                {
                                    "name": "Build Number",
                                    "value": "#${env.BUILD_NUMBER}",
                                    "inline": true
                                },
                                {
                                    "name": "Status",
                                    "value": "FAILURE",
                                    "inline": true
                                },
                                {
                                    "name": "Duration",
                                    "value": "${currentBuild.durationString}",
                                    "inline": true
                                },
                                {
                                    "name": "Build URL",
                                    "value": "[View Build](${env.BUILD_URL})",
                                    "inline": false
                                }
                            ],
                            "footer": {
                                "text": "Jenkins CI/CD Pipeline",
                                "icon_url": "https://wiki.jenkins.io/download/attachments/2916393/logo.png"
                            }
                        }
                    ]
                }
                """
                
                sh """
                    curl -H "Content-Type: application/json" \\
                         -X POST \\
                         -d '${payload}' \\
                         "${env.DISCORD_WEBHOOK_URL}"
                """
            }
        }
        unstable{
            echo "========pipeline execution unstable========"
            script {
                def changes = []
                if (env.BUILD_FRONTEND == 'true') {
                    changes.add('Frontend')
                }
                if (env.BUILD_BACKEND == 'true') {
                    changes.add('Backend')
                }
                def changesText = changes.size() > 0 ? changes.join(' & ') : 'No changes detected'
                
                def payload = """
                {
                    "embeds": [
                        {
                            "title": "Pipeline Build Unstable",
                            "description": "Build completed with warnings for: ${changesText}",
                            "color": 16776960,
                            "timestamp": "${new Date().format("yyyy-MM-dd'T'HH:mm:ss'Z'")}",
                            "fields": [
                                {
                                    "name": "Job Name",
                                    "value": "${env.JOB_NAME}",
                                    "inline": true
                                },
                                {
                                    "name": "Build Number",
                                    "value": "#${env.BUILD_NUMBER}",
                                    "inline": true
                                },
                                {
                                    "name": "Status",
                                    "value": "UNSTABLE",
                                    "inline": true
                                },
                                {
                                    "name": "Duration",
                                    "value": "${currentBuild.durationString}",
                                    "inline": true
                                },
                                {
                                    "name": "Build URL",
                                    "value": "[View Build](${env.BUILD_URL})",
                                    "inline": false
                                }
                            ],
                            "footer": {
                                "text": "Jenkins CI/CD Pipeline",
                                "icon_url": "https://wiki.jenkins.io/download/attachments/2916393/logo.png"
                            }
                        }
                    ]
                }
                """
                
                sh """
                    curl -H "Content-Type: application/json" \\
                         -X POST \\
                         -d '${payload}' \\
                         "${env.DISCORD_WEBHOOK_URL}"
                """
            }
        }
    }
}

                    
