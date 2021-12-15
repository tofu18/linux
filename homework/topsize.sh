#!/usr/bin/bash

dir="$(pwd)"
minsize=1
unset optionsEnded
unset h

while [[ $# > 0 ]]
do
	if [[ -z "$optionsEnded" ]]
	then
		case $1 in
			"--help")
				echo "$0 [--help] [-h] [-N] [-s minsize] [--] [dir]"
				exit 0
				;;
			"-s")
				minsize=$2
				shift
				shift
				;;
			"-h")
				h=True
				shift
				;;
			"--")
				optionsEnded=True
				shift
				;;
			"-"*)
				if [[ $1 =~ '-'[0-9]+ ]]
				then
					N=${1:1}
					shift
				else
					echo Error No such option "$1" >&2
					exit 1
				fi
				;;
			*)
				dir=$1
				shift
				;;
		esac
	else
		dir=$1
		shift
	fi
done
result="$(find "$dir" -type f -size +"$minsize"c  -printf '%p %s\n' | sort -nk2 -r | head -"$N")"
readarray -t array <<< $result
echo ${#array[@]}
for i in ${!array[@]}
do
	if [[ -z "$h" ]]
	then
		du -b "${array[$i]% *}"
	else
		du -b -h "${array[$i]% *}"
	fi
done