TotNumOfTS=$(( (10 * 1) )) #number of times the while should run. Should be calculated. It depends on the expected duration of report and offset.
StartDate="Jan 23 2017 12:00AM"

CurrTS=1
From=$StartDate
SPARK_JOB_SERVER=10.53.97.72
PORT=8090
APP_NAME=leaderboard_app

while [ $CurrTS -le $TotNumOfTS ]
do
### Cleanup ###
	To=$(date -d "$From +24hours" '+%h %d %Y %l:%M%p') #1day indicates the offset duration
	startfrom=$(date -d "$From" '+%Y-%m-%dT%H:%M:%S')
	endtill=$(date -d "$To" '+%Y-%m-%dT%H:%M:%S')
	echo "$startfrom to $endtill"
	From=$To
	CurrTS=$(( CurrTS + 1 ))
	classname=ApDailySummarization #hourly or daily summarizations
        sed -e "s/START_DATE/$startfrom/g" -e "s/END_DATE/$endtill/g" -e "s/CLASS_NAME/$classname/g" template.json > ${classname}.json
	echo "Submitting $classname"
	curl -d @${classname}.json "$SPARK_JOB_SERVER:$PORT/jobs?appName=$APP_NAME&classPath=com.aruba.central.leaderboard.spark.batch.${classname}" 
	classname=ClientDailySummarization
	echo "Submitting $classname"
        sed -e "s/START_DATE/$startfrom/g" -e "s/END_DATE/$endtill/g" -e "s/CLASS_NAME/$classname/g" template.json > ${classname}.json
	curl -d @${classname}.json "$SPARK_JOB_SERVER:$PORT/jobs?appName=$APP_NAME&classPath=com.aruba.central.leaderboard.spark.batch.${classname}"
	echo "Sleeping"
	sleep 20
done
