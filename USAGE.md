# Usage Instructions

### Provision Jenkins with slack configured

To provision Jenkins and create jobs useful for plugin testing.

    unset JENKINS_HOME
    ./slack_bootstrap.sh

Visit `http://localhost:8080/` to see Jenkins running with Slack configured.

### Control Jenkins

The [`provision_jenkins.sh`](scripts/provision_jenkins.sh) script is what
controls slack running on localhost.  It has a few helper commands associated
with it.  Before running any commands it is recommended to add the `scripts`
directory to your local `PATH` environment variable.

    PATH="./scripts:$PATH"
    unset JENKINS_HOME

Now control the Jenkins service.

    provision_jenkins.sh stop
    provision_jenkins.sh start
    provision_jenkins.sh restart


See other options.

    provision_jenkins.sh --help

### Delete Jenkins

Clean up everything:

    ./gradlew clean

Clean your `${JENKINS_HOME}` but don't delete `jenkins.war` or
`jenkins-cli.jar`.

    provision_jenkins.sh clean

Alternative way to clean up everything.

    provision_jenkins.sh purge

# Upgrading Jenkins and plugins

Jenkins is a fast moving development target.  In order to ensure this repository
stays up to date with development in Jenkins these instructions are provided.

To upgrade the stable Jenkins and plugins versions used for testing PRs follow
the [upgrade instructions](scripts/upgrade/README.md).
