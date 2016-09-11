#!/bin/bash -e
#Created by Sam Gleske (https://github.com/samrocketman)
#Sat May 30 18:16:48 EDT 2015
#Ubuntu 14.04.2 LTS
#Linux 3.13.0-52-generic x86_64
#GNU bash, version 4.3.11(1)-release (x86_64-pc-linux-gnu)
#curl 7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1f zlib/1.2.8 libidn/1.28 librtmp/2.3

#A script which bootstraps a Jenkins installation for executing Jervis Job DSL scripts

#sane defaults
export BOOTSTRAP_HOME="${BOOTSTRAP_HOME:-.}"
export CURL="${CURL:-curl}"
export JENKINS_HOME="${JENKINS_HOME:-../my_jenkins_home}"
export JENKINS_WAR="${JENKINS_WAR:-jenkins.war}"
export JENKINS_WEB="${JENKINS_WEB:-http://localhost:8080}"
export jenkins_url="${jenkins_url:-http://mirrors.jenkins-ci.org/war/latest/jenkins.war}"
#variables depending on above variables
export JENKINS_START="${JENKINS_START:-java -Xms4g -Xmx4g -XX:MaxPermSize=512M -jar ${JENKINS_WAR}}"
export SCRIPT_LIBRARY_PATH="${SCRIPT_LIBRARY_PATH:-${BOOTSTRAP_HOME}/scripts}"

if [ -e "${SCRIPT_LIBRARY_PATH}/common.sh" ]; then
  source "${SCRIPT_LIBRARY_PATH}/common.sh"
else
  echo "ERROR could not find ${SCRIPT_LIBRARY_PATH}/common.sh"
  echo "Perhaps environment variable SCRIPT_LIBRARY_PATH is not set correctly."
  exit 1
fi

#provision jenkins and plugins
echo 'Downloading specific versions of Jenkins and plugins...'
./gradlew getjenkins getplugins

if [ -d "${BOOTSTRAP_HOME}/plugins" ]; then
  mkdir -p "${JENKINS_HOME}/plugins"
  ( cd "${BOOTSTRAP_HOME}/plugins/"; ls -1d * ) | while read x; do
    if [ ! -e "${JENKINS_HOME}/plugins/${x}" ]; then
      echo "Copying ${x} to JENKINS_HOME"
      cp -r "${BOOTSTRAP_HOME}/plugins/${x}" "${JENKINS_HOME}/plugins/"
      #pin plugin versions
      #https://wiki.jenkins-ci.org/display/JENKINS/Pinned+Plugins
      touch "${JENKINS_HOME}/plugins/${x}.pinned"
    fi
  done
fi

#download jenkins, start it up, and update the plugins
if [ ! -e "${JENKINS_WAR}" ]; then
  "${SCRIPT_LIBRARY_PATH}/provision_jenkins.sh" download-file "${jenkins_url}" "${JENKINS_WAR}"
fi
#check for running jenkins or try to start it
if ! "${SCRIPT_LIBRARY_PATH}/provision_jenkins.sh" status; then
  "${SCRIPT_LIBRARY_PATH}/provision_jenkins.sh" start
fi
#wait for jenkins to become available
"${SCRIPT_LIBRARY_PATH}/provision_jenkins.sh" url-ready "${JENKINS_WEB}/jnlpJars/jenkins-cli.jar"

#try enabling authentication
if is_auth_enabled; then
  export CURL="${CURL} -u admin:$(<${JENKINS_HOME}/secrets/initialAdminPassword)"
fi
#try enabling CSRF protection support
csrf_set_curl

jenkins_console --script "${SCRIPT_LIBRARY_PATH}/console-skip-2.0-wizard.groovy"
jenkins_console --script "${SCRIPT_LIBRARY_PATH}/configure-disable-usage-stats.groovy"

#update and install plugins
if [ "$1" = "update" ]; then
  echo "Bootstrap Jenkins via script console (may take a while without output)"
  echo "NOTE: you could open a new terminal and tail -f console.log"
  jenkins_console --script "${SCRIPT_LIBRARY_PATH}/bootstrap.groovy"
fi
#conditional restart jenkins
if $(CURL="${CURL} -s" jenkins_console --script "${SCRIPT_LIBRARY_PATH}/console-needs-restart.groovy"); then
  "${SCRIPT_LIBRARY_PATH}/provision_jenkins.sh" restart
  #wait for jenkins to become available
  "${SCRIPT_LIBRARY_PATH}/provision_jenkins.sh" url-ready "${JENKINS_WEB}/jnlpJars/jenkins-cli.jar"
  #try enabling authentication
  if is_auth_enabled; then
    export CURL="${CURL} -u admin:$(<${JENKINS_HOME}/secrets/initialAdminPassword)"
  fi
  #try enabling CSRF protection support
  csrf_set_curl
fi
#create jobs for testing
create_job --job-name "Test" --xml-data "${BOOTSTRAP_HOME}/configs/job_Test_config.xml"
create_job --job-name "jervis" --xml-data "${BOOTSTRAP_HOME}/configs/job_jervis_config.xml"
create_job --job-name "slack-plugin" --xml-data "${BOOTSTRAP_HOME}/configs/job_slack-plugin_config.xml"
jenkins_console --script "${SCRIPT_LIBRARY_PATH}/configure-markup-formatter.groovy"
jenkins_console --script "${SCRIPT_LIBRARY_PATH}/configure-slack.groovy"

echo "Jenkins is ready.  Visit ${JENKINS_WEB}/"
if is_auth_enabled &> /dev/null; then
  echo "User: admin"
  echo "Password: $(<"${JENKINS_HOME}"/secrets/initialAdminPassword)"
fi
