file="/etc/group"
unset group
unset resultString
while [[ $# > 0 ]]
do
    case $1 in
    "-f")
        file=$2
        shift
        shift
        ;;
    "-"*)
        echo "No such option $1" >&2
        exit 2
        ;;
    *)
        if [[ -z $group ]]
        then
            group="$1"
            shift
        else
            echo Wrong format "$0 [-f file] groupname">&2
            exit 2
        fi
    ;;
    esac
done

resultString="$(grep "$group": "$file")"
if [[ -z "$resultString" || -z "$group" ]]
then
    echo No group \""$group"\" found >&2
    exit 1
fi
array=("$(echo "${resultString##*:}" | tr "," "\n")")
for user in $array
do
    echo "$user"
done
exit 0