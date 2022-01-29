echo -e "Enter 1 For Adding in Black List\n2 for Removing from Black List : \n"
echo -e "3 for Adding in WhiteList for SSH"
echo -e "4 for Block All SHH connection"
echo -e "5 for saving All Rules"
echo -e "6 for Reset All Rules"
echo -e "7 for Add Customer ip"
read choice

if [[ "$USER" != "root" ]]
then 
    echo -e "you must bo root user to use this script"
else    
    if [[ 1 == $choice ]]
    then 
        echo -e "enter Ip Address : "
        read ipadd
        iptables -I INPUT -s $ipadd -p tcp --dport 80 -j DROP
    elif [[ 2 == $choice ]]
    then 
        echo -e "enter Ip Address : "
        read ipadd
        iptables -D INPUT -s $ipadd -p tcp --dport 80 -j DROP
    elif [[ 3 == $choice ]]
    then 
        echo -e "enter Ip Address : "
        read ipadd
        iptables -I INPUT -s $ipadd -p tcp --dport 22 -j ACCEPT 
    elif [[ 4 == $choice ]]
    then 
        echo -e "Blocking All SSH\n"
        if [ -z $(iptables -C INPUT -p tcp --dport 22 -j DROP) ]
        then
            echo -e "Adding Blocking SHH rule\n"
            iptables -A INPUT -p tcp --dport 22 -j DROP    
        else
            echo -e "Rule Already Exist\n"
        fi

    elif [[ 5 == $choice ]]
    then 
        echo -e "Saving All Changes\n"
        sudo /sbin/iptables-save
    elif [[ 6 == $choice ]]
    then 
        echo -e "Reset All Rules\n"
        iptables -F
    elif [[ 7 == $choice ]]
    then 
        echo -e "Adding Client Ip : "
        echo -e "enter Client Ip Address : "
        firewallIp=192.168.1.66
        read clientIp
        iptables --table nat --append PREROUTING --protocol tcp --destination $firewallIp --dport 80 --jump DNAT --to-destination $clientIp
        iptables --table nat --append POSTROUTING --protocol tcp --destination $clientIp --dport 80 --jump SNAT --to-source $firewallIp

    elif [[ 7 == $choice ]]
    then 
        echo -e "Remove Client Ip : "
        echo -e "enter Client Ip Address : "
        firewallIp=192.168.1.66
        read clientIp
        iptables --table nat -D PREROUTING --protocol tcp --destination $firewallIp --dport 80 --jump DNAT --to-destination $clientIp
        iptables --table nat -D POSTROUTING --protocol tcp --destination $clientIp --dport 80 --jump SNAT --to-source $firewallIp


    fi
fi