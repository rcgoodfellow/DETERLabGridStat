o "Starting orbd (nameserver) at 10000" 
killall orbd &>/dev/null
killall orbd &>/dev/null
killall -9 orbd &>/dev/null
rm -rf orb.db/
orbd -ORBInitialPort 10000 -ORBInitialHost bpans & 
