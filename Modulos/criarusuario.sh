#!/bin/bash
#====================================================
#	SCRIPT:         KH-VPN FREE SCRIPT
#	DEVELOPED BY:	OVPN-PRO
#	FACEBOOK:	https://m.me/freenetvpndtac
#	WEBSITE:	https://fastnetvpn.pw
#====================================================
IP=$(cat /etc/IP)
cor1='\033[41;1;37m'
cor2='\033[44;1;37m'
scor='\033[0m'
# Gerar client.ovpn
newclient() {
    cp /etc/openvpn/client-common.txt ~/$1.ovpn
    echo "<ca>" >>~/$1.ovpn
    cat /etc/openvpn/easy-rsa/pki/ca.crt >>~/$1.ovpn
    echo "</ca>" >>~/$1.ovpn
    echo "<cert>" >>~/$1.ovpn
    cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >>~/$1.ovpn
    echo "</cert>" >>~/$1.ovpn
    echo "<key>" >>~/$1.ovpn
    cat /etc/openvpn/easy-rsa/pki/private/$1.key >>~/$1.ovpn
    echo "</key>" >>~/$1.ovpn
    echo "<tls-auth>" >>~/$1.ovpn
    cat /etc/openvpn/ta.key >>~/$1.ovpn
    echo "</tls-auth>" >>~/$1.ovpn
}
fun_geraovpn() {
    [[ "$respost" = @(s|S) ]] && {
        cd /etc/openvpn/easy-rsa/
        ./easyrsa build-client-full $username nopass
        newclient "$username"
        sed -e "s;auth-user-pass;<auth-user-pass>\n$username\n$password\n</auth-user-pass>;g" /root/$username.ovpn >/root/tmp.ovpn && mv -f /root/tmp.ovpn /root/$username.ovpn
    } || {
        cd /etc/openvpn/easy-rsa/
        ./easyrsa build-client-full $username nopass
        newclient "$username"
    }
} >/dev/null 2>&1
[[ -e /etc/openvpn/server.conf ]] && {
    _Port=$(grep -w 'port' /etc/openvpn/server.conf | awk {'print $2'})
    hst=$(sed -n '8 p' /etc/openvpn/client-common.txt | awk {'print $4'})
    rmt=$(sed -n '7 p' /etc/openvpn/client-common.txt)
    hedr=$(sed -n '8 p' /etc/openvpn/client-common.txt)
    prxy=$(sed -n '9 p' /etc/openvpn/client-common.txt)
    rmt2='/SSHPLUS?'
    rmt3='www.vivo.com.br 8088'
    prx='200.142.130.104'
    payload1='#payload "HTTP/1.0 [crlf]Host: m.youtube.com[crlf]CONNECT HTTP/1.0[crlf][crlf]|[crlf]"'
    payload2='#payload "CONNECT 127.0.0.1:1194[split][crlf] HTTP/1.0 [crlf][crlf]#"'
    vivo1="portalrecarga.vivo.com.br/recarga"
    vivo2="portalrecarga.vivo.com.br/controle/"
    vivo3="navegue.vivo.com.br/pre/"
    vivo4="navegue.vivo.com.br/controle/"
    vivo5="www.vivo.com.br"
    oi="d1n212ccp6ldpw.cloudfront.net"
    bypass="net_gateway"
    cert01="/etc/openvpn/client-common.txt"
    if [[ "$hst" == "$vivo1" ]]; then
        Host="Portal Recarga"
    elif [[ "$hst" == "$vivo2" ]]; then
        Host="Recarga contole"
    elif [[ "$hst" == "$vivo3" ]]; then
        Host="Portal Navegue"
    elif [[ "$hst" == "$vivo4" ]]; then
        Host="Nav controle"
    elif [[ "$hst" == "$IP:$_Port" ]]; then
        Host="Vivo MMS"
    elif [[ "$hst" == "$oi" ]]; then
        Host="Oi"
    elif [[ "$hst" == "$bypass" ]]; then
        Host="Modo Bypass"
    elif [[ "$hedr" == "$payload1" ]]; then
        Host="OPEN SOCKS"
    elif [[ "$hedr" == "$payload2" ]]; then
        Host="OPEN SQUID"
    else
        Host="Customizado"
    fi
}
fun_bar() {
    comando[0]="$1"
    comando[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${comando[0]} >/dev/null 2>&1
        ${comando[1]} >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "\033[1;33mโปรดรอสักครู่... \033[1;37m- \033[1;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[1;31m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[1;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "\033[1;33mโปรดรอสักครู่... \033[1;37m- \033[1;33m["
    done
    echo -e "\033[1;33m]\033[1;37m -\033[1;32m สำเร็จ !\033[1;37m"
    tput cnorm
}
fun_edithost() {
    clear
    echo -e "\E[44;1;37m          เปลี่ยน โฮสต์ OVPN            \E[0m"
    echo ""
    echo -e "\033[1;33mHOST ที่ใช้งาน\033[1;37m: \033[1;32m$Host"
    echo ""
    echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;33mVIVO RECARGA"
    echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;33mVIVO NAVEGUE PRE"
    echo -e "\033[1;31m[\033[1;36m3\033[1;31m] \033[1;33mOPEN SOCKS \033[1;31m[\033[1;32mAPP MOD\033[1;31m]"
    echo -e "\033[1;31m[\033[1;36m4\033[1;31m] \033[1;33mOPEN SQUID \033[1;31m[\033[1;32mAPP MOD\033[1;31m]"
    echo -e "\033[1;31m[\033[1;36m5\033[1;31m] \033[1;33mVIVO MMS \033[1;31m[\033[1;37mAPN: \033[1;32mmms.vivo.com.br\033[1;31m]"
    echo -e "\033[1;31m[\033[1;36m6\033[1;31m] \033[1;33mMODO BYPASS \033[1;31m[\033[1;32mOPEN + INJECTOR\033[1;31m]"
    echo -e "\033[1;31m[\033[1;36m7\033[1;31m] \033[1;33mTODOS HOSTS \033[1;31m[\033[1;32m1 OVPN DE CADA\033[1;31m]"
    echo -e "\033[1;31m[\033[1;36m8\033[1;31m] \033[1;33mแก้ไขด้วยตนเอง"
    echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;33mกลับ"
    echo ""
    echo -ne "\033[1;32mChoose A Host \033[1;33m?\033[1;37m "
    read respo
    [[ -z "$respo" ]] && {
        echo -e "\n\033[1;31mไม่ถูกต้อง!"
        sleep 2
        fun_edithost
    }
    if [[ "$respo" = '1' ]]; then
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_althost() {
            sed -i "s;$rmt;remote $rmt2 $_Port;" $cert01
            sed -i "s;$hedr;http-proxy-option CUSTOM-HEADER Host $vivo1;" $cert01
            sed -i "s;$prxy;http-proxy $IP 80;" $cert01
        }
        fun_bar 'fun_althost'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '2' ]]; then
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_althost2() {
            sed -i "s;$rmt;remote $rmt2 $_Port;" $cert01
            sed -i "s;$hedr;http-proxy-option CUSTOM-HEADER Host $vivo3;" $cert01
            sed -i "s;$prxy;http-proxy $IP 80;" $cert01
        }
        fun_bar 'fun_althost2'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '3' ]]; then
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_althostpay1() {
            sed -i "s;$rmt;remote $rmt2 $_Port;" $cert01
            sed -i "s;$hedr;$payload1;" $cert01
            sed -i "s;$prxy;http-proxy $IP 8080;" $cert01
        }
        fun_bar 'fun_althostpay1'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '4' ]]; then
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_althostpay2() {
            sed -i "s;$rmt;remote $rmt2 $_Port;" $cert01
            sed -i "s;$hedr;$payload2;" $cert01
            sed -i "s;$prxy;http-proxy $IP 80;" $cert01
        }
        fun_bar 'fun_althostpay2'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '5' ]]; then
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_althost5() {
            sed -i "s;$rmt;remote $rmt3;" $cert01
            sed -i "s;$hedr;http-proxy-option CUSTOM-HEADER Host $IP:$_Port;" $cert01
            sed -i "s;$prxy;http-proxy $prx 80;" $cert01
        }
        fun_bar 'fun_althost5'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '6' ]]; then
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_althost6() {
            sed -i "s;$rmt;remote $IP $_Port;" $cert01
            sed -i "s;$hedr;route $IP 255.255.255.255 net_gateway;" $cert01
            sed -i "s;$prxy;http-proxy 127.0.0.1 8989;" $cert01
        }
        fun_bar 'fun_althost6'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '7' ]]; then
        [[ ! -e "$HOME/$username.ovpn" ]] && fun_geraovpn
        echo -e "\n\033[1;32mเปลี่ยน HOST!\033[0m\n"
        fun_packhost() {
            [[ ! -d "$HOME/OVPN" ]] && mkdir $HOME/OVPN
            sed -i "7,9"d $HOME/$username.ovpn
            sleep 0.5
            sed -i "7i\remote $rmt2 $_Port\nhttp-proxy-option CUSTOM-HEADER Host $vivo1\nhttp-proxy $IP 80" $HOME/$username.ovpn
            cp $HOME/$username.ovpn /root/OVPN/$username-vivo1.ovpn
            sed -i "8"d $HOME/$username.ovpn
            sleep 0.5
            sed -i "8i\http-proxy-option CUSTOM-HEADER Host $vivo3" $HOME/$username.ovpn
            cp $HOME/$username.ovpn /root/OVPN/$username-vivo2.ovpn
            sed -i "7,9"d $HOME/$username.ovpn
            sleep 0.5
            sed -i "7i\remote $rmt3\nhttp-proxy-option CUSTOM-HEADER Host $IP:$_Port\nhttp-proxy $prx 80" $HOME/$username.ovpn
            cp $HOME/$username.ovpn /root/OVPN/$username-vivo3.ovpn
            sed -i "7,9"d $HOME/$username.ovpn
            sleep 0.5
            sed -i "7i\remote $IP $_Port\nroute $IP 255.255.255.255 net_gateway\nhttp-proxy 127.0.0.1 8989" $HOME/$username.ovpn
            cp $HOME/$username.ovpn /root/OVPN/$username-bypass.ovpn
			sed -i "7,9"d $HOME/$username.ovpn
			sleep 0.5
			sed -i "7i\remote $rmt2 $_Port\n$payload1\nhttp-proxy $IP 8080" $HOME/$username.ovpn
            cp $HOME/$username.ovpn /root/OVPN/$username-socks.ovpn
			sed -i "7,9"d $HOME/$username.ovpn
			sleep 0.5
			sed -i "7i\remote $rmt2 $_Port\n$payload2\nhttp-proxy $IP 80" $HOME/$username.ovpn
            cp $HOME/$username.ovpn /root/OVPN/$username-squid.ovpn
            cd $HOME/OVPN && zip $username.zip *.ovpn >/dev/null 2>&1 && cp $username.zip $HOME/$username.zip
            cd $HOME && rm -rf /root/OVPN >/dev/null 2>&1
        }
        fun_bar 'fun_packhost'
        echo -e "\n\033[1;32mเปลี่ยนโฮสต์สำเร็จแล้ว!\033[0m"
        sleep 1.5
    elif [[ "$respo" = '8' ]]; then
        echo ""
        echo -e "\033[1;32mเปลี่ยนไฟล์ OVPN!\033[0m"
        echo ""
        echo -e "\033[1;31mคำเตื่อน!\033[0m"
        echo ""
        echo -e "\033[1;33mเพื่อประหยัดการใช้งาน \033[1;32mctrl x y\033[0m"
        sleep 4
        clear
        nano /etc/openvpn/client-common.txt
        echo ""
        echo -e "\033[1;32mเพื่อประหยัดการใช้งาน!\033[0m"
        fun_geraovpn
        sleep 1.5
    elif [[ "$respo" = '0' ]]; then
        echo ""
        echo -e "\033[1;31mกลับ...\033[0m"
        sleep 2
    else
        echo ""
        echo -e "\033[1;31mไม่ถูกต้อง !\033[0m"
        sleep 2
        fun_edithost
    fi
}
[[ ! -e /usr/lib/sshplus ]] && exit 0
tput setaf 7;tput setab 4;tput bold;printf '%30s%s%-15s\n' "Criar Usuário SSH";tput sgr0
echo ""
echo -ne "\033[1;32mUsername:\033[1;37m ";read username
[[ -z $username ]] && {
	echo -e "\n${cor1}ชื่อผู้ใช้ว่างเปล่าหรือไม่ถูกต้อง!${scor}\n"
	exit 1
}
[[ "$(grep -wc $username /etc/passwd)" != '0' ]] && {
	echo -e "\n${cor1}มีผู้ใช้รายนี้อยู่แล้ว  ลองชื่ออื่น!${scor}\n"
	exit 1
}
[[ ${username} != ?(+|-)+([a-zA-Z0-9]) ]] && {
	echo -e "\n${cor1}คุณป้อนชื่อผู้ใช้ที่ไม่ถูกต้อง!${scor}"
	echo -e "${cor1}อย่าเว้นวรรค หรืออักขระพิเศษ!${scor}\n"
	exit 1
}
sizemin=$(echo ${#username})
[[ $sizemin -lt 2 ]] && {
	echo -e "\n${cor1}คุณป้อนชื่อผู้ใช้ที่สั้นมาก${scor}"
	echo -e "${cor1}ใช้อักขระอย่างน้อยสองตัว!${scor}\n"
	exit 1
}
sizemax=$(echo ${#username})
[[ $sizemax -gt 10 ]] && {
	echo -e "\n${cor1}คุณป้อนชื่อผู้ใช้ที่ยาวมาก"
	echo -e "${cor1}ใช้อักขระสูงสุด 10 ตัว!${scor}\n"
	exit 1
}
echo -ne "\033[1;32mPassword:\033[1;37m ";read password
[[ -z $password ]] && {
	echo -e "\n${cor1}รหัสผ่านว่างเปล่าหรือไม่ถูกต้อง!${scor}\n"
	exit 1
}
sizepass=$(echo ${#password})
[[ $sizepass -lt 4 ]] && {
	echo -e "\n${cor1}รหัสผ่านสั้น ! ใช้อักขระอย่างน้อย 4 ตัว${scor}\n"
	exit 1
}
echo -ne "\033[1;32mDate Expired:\033[1;37m ";read dias
[[ -z $dias ]] && {
	echo -e "\n${cor1}จำนวนวันที่ว่าง!${scor}\n"
	exit 1
}
[[ ${dias} != ?(+|-)+([0-9]) ]] && {
	echo -e "\n${cor1}คุณป้อนจำนวนวันที่ไม่ถูกต้อง!${scor}\n"
	exit 1
}
[[ $dias -lt 1 ]] && {
	echo -e "\n${cor1}ตัวเลขต้องมากกว่าศูนย์!${scor}\n"
	exit 1
}
echo -ne "\033[1;32mUser Limited:\033[1;37m ";read sshlimiter
[[ -z $sshlimiter ]] && {
	echo -e "\n${cor1}คุณเว้นขีดจำกัดการเชื่อมต่อว่างไว้!${scor}\n"
	exit 1
}
[[ ${sshlimiter} != ?(+|-)+([0-9]) ]] && {
	echo -e "\n${cor1}คุณป้อนจำนวนการเชื่อมต่อที่ไม่ถูกต้อง!${scor}\n"
	exit 1
}
[[ $sshlimiter -lt 1 ]] && {
	echo -e "\n${cor1}จำนวนการเชื่อมต่อพร้อมกันต้องมากกว่าศูนย์!${scor}\n"
	exit 1
}
final=$(date "+%Y-%m-%d" -d "+$dias days")
gui=$(date "+%d/%m/%Y" -d "+$dias days")
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -e $final -M -s /bin/false -p $pass $username >/dev/null 2>&1 &
echo "$password" >/etc/SSHPlus/senha/$username
echo "$username $sshlimiter" >>/root/usuarios.db
[[ -e /etc/openvpn/server.conf ]] && {
	echo -ne "\033[1;32mGenerate Ovpn File \033[1;31m? \033[1;33m[Y/N]:\033[1;37m "; read resp
	[[ "$resp" = @(y|Y) ]] && {
		rm $username.zip $username.ovpn >/dev/null 2>&1
		echo -ne "\033[1;32mGenerate with username and password \033[1;31m? \033[1;33m[y/N]:\033[1;37m "
		read respost
		echo -ne "\033[1;32mCurrent Host\033[1;37m: \033[1;31m(\033[1;37m$Host\033[1;31m) \033[1;37m- \033[1;32mChange \033[1;31m? \033[1;33m[y/N]:\033[1;37m "; read oprc
		[[ "$oprc" = @(s|S) ]] && {
			fun_edithost
		} || {
			fun_geraovpn
		}
		gerarovpn() {
			[[ ! -e "/root/$username.zip" ]] && {
				zip /root/$username.zip /root/$username.ovpn
				sleep 1.5
			}
		}
		clear
		echo -e "\E[44;1;37m       สร้างบัญชี SSH แล้ว !      \E[0m"
		echo -e "\n\033[1;32mIP: \033[1;37m$IP"
		echo -e "\033[1;32mUsername: \033[1;37m$username"
		echo -e "\033[1;32mPassword: \033[1;37m$password"
		echo -e "\033[1;32mDate Expired: \033[1;37m$gui"
		echo -e "\033[1;32mUser Limited: \033[1;37m$sshlimiter"
		sleep 1
		function aguarde() {
			helice() {
				gerarovpn >/dev/null 2>&1 &
				tput civis
				while [ -d /proc/$! ]; do
					for i in / - \\ \|; do
						sleep .1
						echo -ne "\e[1D$i"
					done
				done
				tput cnorm
			}
			echo ""
			echo -ne "\033[1;31mกำลังสร้าง OVPN...\033[1;33m.\033[1;31m. \033[1;32m"
			helice
			echo -e "\e[1DOK"
		}
		aguarde
		VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
		echo ""
		[[ -d /var/www/html/openvpn ]] && {
			mv $HOME/$username.zip /var/www/html/openvpn/$username.zip >/dev/null 2>&1
			[[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]] && {
				echo -e "\033[1;32mLINK\033[1;37m: \033[1;36m$IP:81/html/openvpn/$username.zip"
			} || {
				echo -e "\033[1;32mLINK\033[1;37m: \033[1;36m$IP:81/openvpn/$username.zip"
			}
		} || {
			echo -e "\033[1;32mDownload \033[1;31m" ~/"$username.zip\033[0m"
			sleep 1
		}
	} || {
		clear
		echo -e "\E[44;1;37m       สร้างบัญชี SSH แล้ว !      \E[0m"
		echo -e "\n\033[1;32mIP: \033[1;37m$IP"
		echo -e "\033[1;32mUsername: \033[1;37m$username"
		echo -e "\033[1;32mPassword: \033[1;37m$password"
		echo -e "\033[1;32mDate Expired: \033[1;37m$gui"
		echo -e "\033[1;32mUser Limited: \033[1;37m$sshlimiter"
	}
} || {
	clear
	echo -e "\E[44;1;37m       สร้างบัญชี SSH แล้ว !      \E[0m"
	echo -e "\n\033[1;32mIP: \033[1;37m$IP"
	echo -e "\033[1;32mUsername: \033[1;37m$username"
	echo -e "\033[1;32mPassword: \033[1;37m$password"
	echo -e "\033[1;32mDate Expired: \033[1;37m$gui"
	echo -e "\033[1;32mUser Limited: \033[1;37m$sshlimiter"
}
