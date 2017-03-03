def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful
    buildStatus =  buildStatus ?: 'SUCCESSFUL'

    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"
    def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p><p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

    // Override default values based on build status
    if (buildStatus == 'STARTED') {
        color = 'YELLOW'
        colorCode = '#FFFF00'
    }
    else if (buildStatus == 'SUCCESSFUL') {
        color = 'GREEN'
        colorCode = '#00FF00'
    }
    else {
        color = 'RED'
        colorCode = '#FF0000'
    }

    // Send notifications
    slackSend (color: colorCode, message: summary)
}

@NonCPS
def getTestSummary = { ->
    def testResultAction = currentBuild.rawBuild.getAction(hudson.tasks.test.AbstractTestResultAction.class)
    def summary = ''

    if (testResultAction != null) {
        def total = testResultAction.getTotalCount()
        def failed = testResultAction.getFailCount()
        def skipped = testResultAction.getSkipCount()

        summary = '''Pipeline Test results:\n\t'''
        summary = summary + ('Passed: ' + (total - failed - skipped))
        summary = summary + (', Failed: ' + failed)
        summary = summary + (', Skipped: ' + skipped)
    }
    else {
        summary = 'Pipeline: No tests found.'
    }
    return summary
}

node {
    try {
        notifyBuild()
        stage('Preparation') {
            git 'https://github.com/samrocketman/jervis'
        }
        stage('Build') {
            sh './gradlew cobertura'
            sh './gradlew groovydoc'
        }
        stage('Results') {
            junit 'build/test-results/*.xml'
            publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'build/docs/groovydoc', reportFiles: 'index.html', reportName: 'Jervis API Documentation'])
        }
    } catch (e) {
        currentBuild.result = 'FAILED'
        throw e
    } finally {
        slackSend getTestSummary()
        notifyBuild(currentBuild.result)
    }
}
