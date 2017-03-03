# Bootstrap Jenkins to test Slack Plugin

The [Jenkins][jenkins] [Slack plugin][slack-plugin] publishes build information
to [Slack][slack] teams.   This project is meant to bootstrap Jenkins from
scratch and pre-configure it to use the Slack plugin for testing.

If you're not already a member of `jenkins-slack-plugin.slack.com` then [please
join][join-slack] before bootstrapping this code so you can see messages posted
to it.

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

Clean up everything:

    ./gradlew clean

Clean your `${JENKINS_HOME}` but don't delete `jenkins.war` or
`jenkins-cli.jar`.

    provision_jenkins.sh clean

Alternative way to clean up everything.

    provision_jenkins.sh purge

# Updating this repository

Script console script to generate `sed` expressions to update plugin versions in
`build.gradle`.

```
Jenkins.instance.pluginManager.plugins.each { p ->
  println "s/^( +getplugins[^:]+:${p.shortName}):[^@]+@(.+)/\\1:${p.version}@\\2/"
}
null
```

[gh-token]: https://help.github.com/articles/creating-an-access-token-for-command-line-use/
[jenkins]: http://jenkins-ci.org/
[join-slack]: https://jenkins-slack-testing-signup.herokuapp.com/
[slack-plugin]: https://github.com/jenkinsci/slack-plugin
[slack]: https://slack.com/
