TotNumOfTS=$(( 12 * 18 ))
StartDate="Dec 07 2016 12:00AM"
CurrTS=1
From=$StartDate

while [ $CurrTS -le $TotNumOfTS ]
do
### Cleanup ###
	To=$(date -d "$From +5mins" '+%h %d %Y %l:%M%p') #1day indicates the offset duration
	startfrom=$(date -d "$From" '+%Y-%m-%dT%H:%M:%S')
	filename=$(date -d "$From" '+%Y-%m-%d_%H-%M-%S')
	From=$To
	echo "$startfrom"
	cqlsh -u cassandra -p cassandra `hostname -I` -e "select message from analyticsdb.monitoring_clients where cust_sub_id = '10112136' and interval = '5minutes' and ts = '$startfrom' and chunk_id = 0" |grep '0x' > $filename
	CurrTS=$(( CurrTS + 1 ))
	sleep 2
done
