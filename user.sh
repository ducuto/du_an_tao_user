#!/bin/bash

#khai bao ma mau
xanh='\033[0;32m'
do='\033[0;31m'
macdinh='\e[0m'
#check xem user la root hay la user
if [[ ${UID} -ne 0 ]]; then
	echo "vii long dang nhap voi account root de thuc hien"
	exit 1
fi
#check tham so
if [[ "${#}" -lt 1  ]]; then
	echo "check tham so"
	echo "username_${0}"
	exit 1 
fi

#them dau vao
input_file=$1
log_file="$HOME/thong_tin_nhan_vien"

#check xem file truyen vao ton tai khoong
if [[ ! -f "$input_file" ]] ;then
	echo "FILE $input_file not found !"
	exit 1
fi

#cach dong de nhin + create file log de xem lai
echo "-----$(date)--------" | tee -a "$log_file"

# vong lap nham kiem tra neu co khong trang thi van chay
while   read -r user_name ; do
	user_name=$(echo "$user_name"| xargs)
	[[ -z "$user_name" ]] && continue
	user_name=$(echo "$user_name" | cut -d "," -f 2 )
	useradd  "$user_name"

	if [[ $? -eq 0  ]]; then

	#tao passwd ngau nhien ,dung md5sum de ma hoa
password=$(echo $RANDOM$RANDOM | md5sum | head -c 8)

	echo "$password" | passwd --stdin "$user_name" &> /dev/null
	echo -e ""${xanh}" Tạo user thành cong✅ :${macdinh}  $user_name | password:$password." | tee -a  "$log_file"
else
	echo -e ""${do}" Tạo thất bại❌:${macdinh}  $user_name"
fi
done < "$input_file" 

echo "-------END-------------"
