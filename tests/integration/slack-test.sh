#!/bin/bash
#Ubuntu 16.04.2 LTS
#Linux 4.4.0-72-generic x86_64


if [ ! -f build.gradle ]; then
  echo "Not being run from repository root." 1>&2
  exit 1
fi

if [ -z "$(type -p jenkins-call-url)" ]; then
  {
    #do not subshell but group command output to stderr
    #See Compound Commands in bash man page.
    echo "Missing jenkins-call-url script."
    echo 'Download and add to $PATH:'
    echo 'https://github.com/samrocketman/home/blob/master/bin/jenkins-call-url'
  } 1>&2
  exit 1
fi

function waitForJenkins() (
  export JENKINS_CALL_ARGS='-m POST http://localhost:8080/scriptText --data-string script= -d'
  echo -n 'Waiting for jobs to finish.'
  while [ "$(jenkins-call-url ./tests/integration/isJenkinsBuilding.groovy)" = 'true' ]; do
    echo -n '.'
    sleep 3
  done
  echo
  echo 'Done.'
)

#set up Jenkins env vars
source scripts/upgrade/env.sh
unset JENKINS_CALL_ARGS
export JENKINS_CALL_ARGS='-m POST'

#do connection test
echo -n "Test Slack Connection: "
jenkins-call-url http://localhost:8080/descriptorByName/jenkins.plugins.slack.SlackNotifier/testConnection | sed -r 's/<[^>]+><[^>]+>([^<]+).*/\1\n/'

#test different status messages
echo 'Scheduling three test jobs.'
jenkins-call-url --data-string 'json=' -d tests/integration/data-fail.json http://localhost:8080/job/Test/build?delay=0sec
jenkins-call-url --data-string 'json=' -d tests/integration/data-unstable.json http://localhost:8080/job/Test/build?delay=0sec
jenkins-call-url --data-string 'json=' -d tests/integration/data-success.json http://localhost:8080/job/Test/build?delay=0sec

waitForJenkins &> /dev/null

echo 'Scheduling Slack Plugin freestyle job.'
jenkins-call-url http://localhost:8080/job/slack-plugin/build?delay=0sec

echo 'Scheduling Jervis freestyle job.'
jenkins-call-url http://localhost:8080/job/jervis/build?delay=0sec

echo 'Scheduling Jervis Pipeline.'
jenkins-call-url http://localhost:8080/job/JervisPipeline/build?delay=0sec

waitForJenkins
