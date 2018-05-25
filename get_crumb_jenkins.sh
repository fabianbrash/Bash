#!/bin/bash

curl -X POST -u "user:USER_TOKEN_OR_PASSWORD" 'http://JENKINS_URL:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
