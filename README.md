# Bootstrap Jenkins to test Slack Plugin

The Jenkins [Slack plugin][slack-plugin] generates Jenkins jobs using Travis CI YAML.

# Instructions

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

Clean your `${JENKINS_HOME}` but don't delete `jenkins.war` or
`jenkins-cli.jar`.

    provision_jenkins.sh clean

Completely purge your Jenkins instance by deleting all files and folders created
by the bootstrap.

    provision_jenkins.sh purge

[gh-token]: https://help.github.com/articles/creating-an-access-token-for-command-line-use/
[slack-plugin]: https://github.com/jenkinsci/slack-plugin
[slack]: https://slack.com/
[jenkins]: http://jenkins-ci.org/
