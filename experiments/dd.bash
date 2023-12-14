
LOG_FILE=/tmp/both.log

echo "This is stdout"
exec 3>&1 4>&2
exec 1>&sen
trap 'exec 3>&1 4>&2 ' 0 1 2 3 4


echo "New This is stdout"
echo "This is stderr" 1>&2
echo "This is the console (fd 3)" 
echo "This is both the log and the console"

# cat $LOGFILE
exec 2>&4 1>&3
cat log.out


exit