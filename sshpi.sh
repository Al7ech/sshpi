#written by danielee99@tistory.com
#mail danielee99@naver.com if you have any questions!
#!/bin/bash
myip=$(sudo ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{print $2}')
IFS=' ' read -r -a myip <<< "$myip"
myip=${myip%.*}
arpcache=$(sudo arp -a | grep b8:27:eb )

if [ -n "$arpcache" ]
	then
		ip=$(echo $arpcache | cut -f2 -d"(" | cut -f1 -d")")
		echo "RPi caught on arp cache"
		echo "Connecting to pi@${ip}..."
		sshpass -p "PASSWORD" ssh -o StrictHostKeyChecking=no pi@$ip
		exit
else
	printf "RPi not found on arp cache...\narping local network...\n"
	fi
for i in {1..254}
do	
	sudo arping -c1 192.168.25.${i} &> /dev/null &
	sleep 0.05
	echo -en "\rarp-scan $myip.$i"

done

array[1]='\'
array[2]='-'
array[3]='/'
array[4]='|'
array[5]='\'
array[6]='-'
array[7]='/'
array[8]='|'
for name in ${array[@]}
do
	echo -en "\rWaiting for response...$name"
	sleep 0.5
done

echo -en "\b\n"

arpcache=$(sudo arp -a | grep b8:27:eb )
if [ -n "$arpcache" ]
	then
		ip=$(echo $arpcache | cut -f2 -d"(" | cut -f1 -d")")
		echo "Connecting to pi@${ip}..."
		sshpass -p "PASSWORD" ssh -o StrictHostKeyChecking=no pi@$ip
		exit
	fi
echo""
printf "No RPi devices found!\nQuiting...\n"
exit
