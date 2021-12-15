#!/usr/bin/bash

verbose=False
dryrun=False
optionsEnded=False
unset suffix
unset flag

echo add "$@"
for par in "$@"
do
case "$par" in
"-h")
	echo "$0" ["-h|-v|-d"] ['--'] suffix file...
	exit 0
	;; 
"-v")
	verbose=True
	;;
"-d")
	dryrun=True
	verbose=True

	;;
"--")
	break
	;;
"-"*)
	echo Error: "$par" not found >&2
	exit 2
	;;
esac
done

for par in "$@"
do
	if [[ $optionsEnded = False ]]
	then
		case "$par" in
		[^"-"]*)
			if [[ -z "$suffix" ]]
			then
				suffix="$par"
			else
				echo "${par##.*}""$suffix""${par%.*}"
			fi
			;;
		"--")
			optionsEnded=True
		;;
		esac
	else
		if [[ -z "$suffix" ]]
		then
			suffix="$par"
		else
			flag=True
			if [[ -e "$par" ]]
			then

				if [[ $dryrun = False ]]
				then
					mv ./"$par" ./"${par%.*}""$suffix""${par#${par%.*}}" 2>&2
				fi
				if [[ $verbose = True ]]
				then
					echo "$par" "->" "${par%.*}""$suffix""${par#${par%.*}}"
		
				fi
			else
				echo No "$par" file found >&2
				fileerr=1
			fi
			
		fi
	fi
done

if [[ -z "$suffix" ]]
then
	echo No suffix entered >&2
	exit 2
fi

if [[ -z "$flag" ]]
then
	echo No files are given >&2
	exit 2
fi

if [[ "$fileerr = 1" ]]
then
	exit 1
fi
