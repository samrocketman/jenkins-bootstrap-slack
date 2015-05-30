def slack = Jenkins.instance.getExtensionList(
  jenkins.plugins.slack.SlackNotifier.DescriptorImpl.class
)[0]
//valid tokens for testing in the jenkins-slack-plugin-test instance of slack.com
def params = [
  slackTeamDomain: 'jenkins-slack-plugin',
  slackToken: 'jfG4cs9hT6QsRON2ocwXx980',
  slackRoom: '#slack-plugin-testing #random',
  slackBuildServerUrl: 'http://localhost:8080/',
  slackSendAs: ''
]
def req = [
  getParameter: { name -> params[name] }
] as org.kohsuke.stapler.StaplerRequest
slack.configure(req, null)

slack.save()
println 'Slack global settings configured.'
