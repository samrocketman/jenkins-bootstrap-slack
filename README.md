# Bootstrap Jenkins to test Slack Plugin

This project helps to automate a stable means of testing pull requests for the
Jenkins [slack-plugin][slack-plugin].

# Test sequence for PRs

> Note: Prerequisites include: Java 1.8, Vagrant, VirtualBox, and Ubuntu Linux
> 16.04 as a host.

For testing [`slack-plugin` pull requests][slack-pulls], I run through a manual
test sequence in addition to depending on the automated tests.  In general, I
feel comfortable merging a change when:

- :white_check_mark: The plugin smoothly upgrades to SNAPSHOT build of the PR
  from the stable version of the slack plugin without breaking existing
  configurations.
- :white_check_mark: The code integrates well with existing configurations.
- :white_check_mark: You have included tests!

The following outlines a more detailed test sequence.

### Testing slack.com

1. Bootstrap fresh Jenkins.  `./slack_bootstrap.sh`.
2. Once Jenkins is up and running, execute the following automation script to
   run through building jobs.

   ```
   ./tests/integration/slack-test.sh
   ```

3. Once the script finishes running, manually verify all of the output messages
   at https://jenkins-slack-plugin.slack.com/.

### Testing mattermost

Configure Mattermost

1. Bootstrap Mattermost with `vagrant up`.  Log into http://localhost:8065/ when
   it finishes.
2. Sign up with a dummy account.  This first account will be an admin.
3. Create a new team named `slack-plugin`.
4. Enable integrations.  Visit _System Console > Integrations > Custom
   Integrations_ and be sure to _Enable Incoming Webhooks_.  Switch back to the
   `slack-plugin` team when finished.
5. Under `slack-plugin` menu click _Integrations_.  Add an incomming web hook.
   Give it any name.  When you're finished you'll be presented with an
   integration URL like
   `http://localhost:8065/hooks/zsj3k4e3qbyq7qxpoqndruyoqy`.

   * `http://localhost:8065/hooks/` is your base URL.
   * `zsj3k4e3qbyq7qxpoqndruyoqy` is your integration token.

Configure slack plugin to use Mattermost.

1. Go to Manage Jenkins > Configure System.
2. Under the _Global Slack Notifier Settings_ you'll need to configure:

   * Base URL: `http://localhost:8065/hooks/`
   * Team Subdomain: `slack-plugin`
   * Integration Token: `zsj3k4e3qbyq7qxpoqndruyoqy` (this will be different
     each time)
   * Channel: `Off-Topic`
3. Test the connection to be sure it's good.
4. Execute the following automation script to run through building jobs.

   ```
   ./tests/integration/slack-test.sh
   ```
5. Once the script finishes running, manually verify all of the output messages
   at `http://localhost:8065/slack-plugin/channels/off-topic`.

# Usage Instructions

For usage instructions related to scripts in this repository see
[USAGE.md](USAGE.md).

# More about this project

The [Jenkins][jenkins] [Slack plugin][slack-plugin] publishes build information
to [Slack][slack] teams.   This project is meant to bootstrap Jenkins from
scratch and pre-configure it to use the Slack plugin for testing.

If you're not already a member of `jenkins-slack-plugin.slack.com` then [please
join][join-slack] before bootstrapping this code so you can see messages posted
to it.

# Upgrading this project

Keeping up with updates can be a challenge if it's not automated.  The following
process keeps upgrading simple.

    ./scripts/upgrade/upgrade_build_gradle.sh

See the more detailed [upgrade process](scripts/upgrade/README.md).


# License

    Copyright (c) 2015-2017 Sam Gleske - https://github.com/samrocketman/jenkins-bootstrap-slack

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

For the full license see [LICENSE](LICENSE).

[gh-token]: https://help.github.com/articles/creating-an-access-token-for-command-line-use/
[jenkins]: http://jenkins-ci.org/
[join-slack]: https://jenkins-slack-testing-signup.herokuapp.com/
[slack-plugin]: https://github.com/jenkinsci/slack-plugin
[slack-pulls]: https://github.com/jenkinsci/slack-plugin/pulls
[slack]: https://slack.com/
