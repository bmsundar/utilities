if [ "$1" == "husky2" ]
then
  SJSIP=172.50.100.15
  PORT=30081
elif [ "$1" == "uber2" ]
then
  SJSIP=10.53.97.42
  PORT=30081
fi

echo "Contexts in SJS"
curl http://${SJSIP}:${PORT}/contexts

