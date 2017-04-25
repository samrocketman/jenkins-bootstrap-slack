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

#set up Jenkins env vars
source scripts/upgrade/env.sh

jenkins-call-url ./tests/integration/configureJobsWithMatterMost.groovy
