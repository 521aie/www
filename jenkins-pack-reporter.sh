#!/bin/bash

#source $HOME/.bash_profile
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

for token in $(echo $REPORTER_ACCESS_TOKEN | tr ";" "\n")
do
	url="https://oapi.dingtalk.com/robot/send?access_token=${token}"

	if [ $1 == "SUCCESS" ]
	then
		curl "${url}" \
		   -H 'Content-Type: application/json' \
		   -d "
		  {\"msgtype\": \"markdown\", 
		    \"markdown\": {
		    	\"title\":\"${JOB_NAME}\",
		        \"text\":\"iOS ${JOB_NAME}-${BUILD_NUMBER} 打包成功 [去下载](https://10.1.80.6:2222)\"
		     }
		  }"
	else
		curl "${url}" \
		   -H 'Content-Type: application/json' \
		   -d "
		  {\"msgtype\": \"markdown\", 
		    \"markdown\": {
		    	\"title\":\"${JOB_NAME}\",
		        \"text\":\"iOS ${JOB_NAME}-${BUILD_NUMBER} 打包失败 [去查看](${BUILD_URL})\"
		     }
		  }"
	fi
done


