#/bin/bash


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------
# We already have a Jenkins crumb so lets use it to build our Dev Pipeline
#------------------------------------------------------------------------------------------------------------------------------------------------------------------

curl -X POST -u "user:APIKEY_OR_PASSWORD" -H ".crumb:YOUR_CRUMB" http://JENKINS_URL_OR_IP:8080/job/THE_JOB/build