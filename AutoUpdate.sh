#!/bin/bash
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}


LocalVersion=$(./GitAutoUpdate --version)
tag_name=$(curl -sS https://api.github.com/repos/aealtman1/GitAutoUpdate/releases/latest | jq .tag_name)
RemoteVersion=$(echo $tag_name | grep -Eo "[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}")

echo $LocalVersion $RemoteVersion

vercomp $LocalVersion $RemoteVersion

if [ $? -gt 1 ]
then
    echo "Update required, current version ${LocalVersion}, new version ${RemoteVersion}"
    export UpdateRequired=1;
    git pull https://github.com/aealtman1/GitAutoUpdate.git
    
else
    echo "Up to date"
fi