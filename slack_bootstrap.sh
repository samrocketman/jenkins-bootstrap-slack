#!/bin/bash
#Created by Sam Gleske (https://github.com/samrocketman)
#Sat May 30 18:16:48 EDT 2015
#Ubuntu 14.04.2 LTS
#Linux 3.13.0-52-generic x86_64
#GNU bash, version 4.3.11(1)-release (x86_64-pc-linux-gnu)
#curl 7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1f zlib/1.2.8 libidn/1.28 librtmp/2.3

#A script which bootstraps a Jenkins installation for executing Jervis Job DSL scripts

export JENKINS_HOME="my_jenkins_home"

#download jenkins, start it up, and update the plugins
./scripts/provision_jenkins.sh bootstrap --skip-restart | grep -v 'Jenkins is ready'
#install required plugins
#cobertura is for code coverage reporting
#covcomplplot is for surfacing code complexity graphs
./scripts/provision_jenkins.sh install-plugins slack cobertura covcomplplot htmlpublisher
#restart jenkins
./scripts/provision_jenkins.sh restart
#create the jobs that are well configured for testing the slack plugin.
./scripts/provision_jenkins.sh cli create-job Test < ./configs/job_Test_config.xml
./scripts/provision_jenkins.sh cli create-job jervis < ./configs/job_jervis_config.xml
./scripts/provision_jenkins.sh cli create-job slack-plugin < ./configs/job_slack-plugin_config.xml
#configure global settings
sleep 5
curl -d "script=$(<./scripts/configure-markup-formatter.groovy)" http://localhost:8080/scriptText
curl -d "script=$(<./scripts/configure-slack.groovy)" http://localhost:8080/scriptText
echo 'Jenkins is ready.  Visit http://localhost:8080/'
