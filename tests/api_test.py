#!/usr/bin/env python
#Created by Sam Gleske
#Meant to read from stdin a JSON blob from Jenkins master root
import json
import sys
response = json.load(sys.stdin)
jobs = map(lambda x: x["name"], response["jobs"])
assert response["useSecurity"]
assert 'jervis' in jobs
assert 'slack-plugin' in jobs
assert 'Test' in jobs
