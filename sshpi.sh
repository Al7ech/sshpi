#mail al7ech@gmail.com if you have any questions!
#!/bin/bash
myip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2)
iprange=${myip%.*}
pw="PASSWORD"

arpcache=$(sudo arp -a | grep b8:27:eb )

if [ -n "$arpcache" ]
	then
		ip=$(echo $arpcache | cut -f2 -d"(" | cut -f1 -d")")
		echo "RPi caught on arp cache"
		echo "Connecting to pi@${ip}..."
		sshpass -p $pw ssh -o StrictHostKeyChecking=no pi@$ip
		exit
else
	printf "RPi not found on arp cache...\nScanning local network...\n"
	fi
for i in {1..254}
do
	ping -c 1 $iprange.$i > /dev/null &
	sleep 0.01
	echo -en "\rScaning ... $iprange.$i"

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
	echo -en "\rWaiting for response ... $name"
	sleep 0.5
done

echo -en "\r                       \r"

arpcache=$(sudo arp -a | grep b8:27:eb )
if [ -n "$arpcache" ]
	then
		ip=$(echo $arpcache | cut -f2 -d"(" | cut -f1 -d")")
		echo "Connecting to pi@${ip}..."
		sshpass -p $pw ssh -o StrictHostKeyChecking=no pi@$ip
		exit
	fi
printf "\r                      \rNo RPi devices found!\nQuiting...\n"
exit
