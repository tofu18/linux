#!/usr/bin/bash

file=/etc/passwd
user="$USER"

while [[ $# > 0 ]]
do
	case $1 in
		"-f")
			file="$2"
			shift
			shift
		;;
		*)
			user="$1"
			shift
		;;
	esac
done
if [[ ! -e "$file" ]]
then
	echo No file "$file" found >&2
	exit 2
fi

string=$(grep ^"$user:" "$file")

if [[ -z $string ]]
then
	echo No user "$user" found >&2
	exit 1
fi

array=($(echo "$string" | tr ":" "\n"))
echo "${array[5]}"
