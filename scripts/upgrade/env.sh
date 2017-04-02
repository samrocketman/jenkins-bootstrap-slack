export JENKINS_USER=admin
export JENKINS_PASSWORD="$(<../my_jenkins_home/secrets/initialAdminPassword)"
export JENKINS_HEADERS_FILE=../my_jenkins_home/secrets/.http-headers.json
export JENKINS_CALL_ARGS='-m POST -v http://localhost:8080/scriptText --data-string script= -d'
