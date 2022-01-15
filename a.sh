#/bin/bash

string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32 | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4=$string4-$string12"
header='Connection: "close", "Accept": "*/*", "Content-type": "applicaltion/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720*1280; HM 1SW; armani; qcom; en_US)"'
var=$(curl -i -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"

login(){

if [[ $user == "" ]]; then
printf "login"
read -p $'username: ' user
fi

read -s $'password: ' pass
printf "/n"
data='{"phone_id":"'$phone'", "_csrtoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'

IFS=$'\n'

hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
var=$(curl -c cookie.$user -d "ig_sig_key_version=48signed_body=$hmac.$data" -s --user-agent)

}
