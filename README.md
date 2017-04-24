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

> Note: Log into https://jenkins-slack-plugin.slack.com/ to watch for output
> messages.

1. Bootstrap fresh Jenkins.  `./slack_bootstrap.sh`
2. Execute the following jobs

### Testing mattermost

> Note: Execute `vagrant up` to bring up Mattermost.  Log into
> http://localhost:8065/ to watch for output messages.

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

    source scripts/upgrade/env.sh

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
