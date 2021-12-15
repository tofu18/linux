#!/usr/bin/bash
unset h
unset d
unset v
unset sfx 
unset dir
unset argsEnded
masks=(find)
for arg in "$@"
do
    if [[ -z "$argsEnded" ]]
    then
        case "$arg" in
            "-h")
                echo "$0 [-h] [-d|-v] [--] sfx dir mask1 [mask2...]" 
                exit 0
            ;;
            "-d")
                d=-d
                v=-v
            ;;
            "-v")
                v=-v
            ;;
            "--")
                argsEnded=True
            ;;
            "-"*)
                echo "No such option $arg" >&2
                exit 1 
            ;;
            *)
                if [[ -z "$sfx" ]]
                then
                    sfx="$arg"
                else
                    if [[ -z "$dir" ]]
                    then
                        dir=1
                        masks+=("$arg")
                    else
                        masks+=("-name")
                        masks+=("$arg")
                        masks+=("-o")
                    fi
                fi
        esac
    else
        if [[ -z "$sfx" ]]
        then
            sfx="$arg"
        else
            if [[ -z "$dir" ]]
            then
                dir=1
                masks+=("$arg")
            else
                masks+=("-name")
                masks+=("$arg")
                masks+=("-o")
            fi
        fi
    fi
done

unset masks[-1]
if [[ ${#masks[@]} < 3 ]]
then    
    echo Wrong format, try "$0 [-h] [-d|-v] [--] sfx dir mask1 [mask2...]" 
    exit 1
fi
echo $("${masks[@]}") | xargs ./addsfx.sh $d $v -- $sfx
