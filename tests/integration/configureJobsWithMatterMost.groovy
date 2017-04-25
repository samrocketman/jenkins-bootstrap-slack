/*
   Copyright 2015-2017 Sam Gleske - https://github.com/samrocketman/jenkins-bootstrap-slack

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   */
/*
   Configures each FreeStyle job with empty settings so that it uses the global
   mattermost configuration.
 */
import jenkins.model.Jenkins
import hudson.model.FreeStyleProject
import jenkins.plugins.slack.SlackNotifier

Jenkins.instance.getAllItems(FreeStyleProject.class).each { project ->
    SlackNotifier slack = project.publishersList.find { it.class.simpleName == 'SlackNotifier' }
    if(slack) {
        slack.teamDomain = ''
        slack.authToken = ''
        slack.room = ''
    }
    project.save()
}
null
