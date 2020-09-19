#!/bin/bash

# Be used to check command exist.
# checkWget=$(command -v wget)
# checkUnzip=$(command -v unzip)
# checkGC=$(command -v google-chrome)
# checkPython=$(command -v python)
# checkPip=$(command -v pip)

# print install message.
echoInstallMsg() {
    local commandName=$1
    local msg=$2
    if [ ${#commandName} -lt 8 ]; then
        echo -e $commandName'\t\t'$msg>&2
    else
        echo -e $commandName'\t'$msg>&2
    fi
}

# check command be installed.
checkInstall() {
    local commandName=$1   # command name
    # "command -v $commandName >/dev/null" is used to check command exist.
    # if exist, commandExist will be not null
    if $(command -v $commandName >/dev/null); then
        echoInstallMsg $commandName '...installed.'
        exist=1 # 1 equal false.
    else
        echoInstallMsg $commandName '...not install.'
        exist=0 # 0 equal true.
    fi
    # echo $exist
    return $exist
}

# install wget, unzip, google-chrome and pip
installCommand() {
    # start check
    $(checkInstall "wget")
    installedWget=$?
    $(checkInstall "unzip")
    installedUnzip=$?
    $(checkInstall "google-chrome")
    installedGC=$?
    $(checkInstall "python")
    installedPython=$?
    $(checkInstall "pip")
    installedPip=$?
    # installedWget=$(checkInstall "wget")
    # $(checkInstall "unzip")
    # installedUnzip=$?
    # $(checkInstall "google-chrome")
    # installedGC=$?
    # $(checkInstall "python")
    # installedPython=$?
    # $(checkInstall "pip")
    # installedPip=$?
    # $(checkInstall "123")
    # installedWget=$?
    # echo $installedWget
    # echo $installedWget
    # echo $installedUnzip
    # echo $installedGC
    # echo $installedPython
    # echo $installedPip
    # test=0
    # echo $installedWget
    # if $(checkInstall "123"); then
    #     echo "True"
    # else
    #     echo "False"
    # fi
    # exit
    # if not install
    if [ $installedWget == 0  ] || [ installedUnzip == 0 ] || [ installedGC == 0 ] || [ installedPython == 0 ] || [ installedPip == 0 ]; then
        # update
        sudo apt-get update
        if [ $installedWget == 0 ]; then
            sudo apt-get install -y wget
        fi
        if [ $installedUnzip == 0 ]; then
            sudo apt-get install -y unzip
        fi
        if [ $installedGC == 0 ]; then
            wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i google-chrome-stable_current_amd64.deb
            sudo apt-get install
            sudo apt-get install -f
            rm -f google-chrome-stable_current_amd64.deb
        fi
        if [ $installedPython == 0 ]; then
            sudo apt-get install -y python
        fi
        if [ $installedPip == 0 ]; then
            wget https://raw.githubusercontent.com/pypa/get-pip/master/get-pip.py
            sudo python get-pip.py
            rm -f get-pip.py
        # else
            # python -m pip install --upgrade pip
        fi
    else
        echo "wget, unzip, google-chrome and pip installed already."
    fi
}

installCommand

# # install selenium
checkSelenium=$(pip list 2>/dev/null | grep "selenium")
if [ -z "$checkSelenium" ]; then
    sudo pip install -U selenium
fi

# # Get chrome version
v=$(google-chrome --version | sed "s/Google Chrome //g" | sed "s/\..*//g")
ver=$((v))


# # Set chromedriver version
if [ $ver -le 70 ] && [ $ver -ge 68 ]; then
    current_version="2.42"
elif [ $ver -le 67 ] && [ $ver -ge 69 ]; then
    current_version="2.41"
elif [ $ver -le 68 ] && [ $ver -ge 66 ]; then
    current_version="2.40"
elif [ $ver -le 67 ] && [ $ver -ge 65 ]; then
    current_version="2.38"
elif [ $ver -le 66 ] && [ $ver -ge 64 ]; then
    current_version="2.37"
elif [ $ver -le 65 ] && [ $ver -ge 63 ]; then
    current_version="2.36"
elif [ $ver -le 64 ] && [ $ver -ge 62 ]; then
    current_version="2.35"
elif [ $ver -le 63 ] && [ $ver -ge 61 ]; then
    current_version="2.34"
elif [ $ver -le 62 ] && [ $ver -ge 60 ]; then
    current_version="2.33"
elif [ $ver -le 61 ] && [ $ver -ge 59 ]; then
    current_version="2.32"
elif [ $ver -le 60 ] && [ $ver -ge 58 ]; then
    current_version="2.31"
elif [ $ver -le 58 ] && [ $ver -ge 56 ]; then
    current_version="2.29"
elif [ $ver == 70 ]; then
    current_version="70.0.3538.97"
elif [ $ver == 71 ]; then
    current_version="71.0.3578.137"
elif [ $ver == 72 ]; then
    current_version="72.0.3626.69"
elif [ $ver == 73 ]; then
    current_version="73.0.3683.68"
elif [ $ver == 74 ]; then
    current_version="74.0.3729.6"
elif [ $ver == 75 ]; then
    current_version="75.0.3770.140"
elif [ $ver == 76 ]; then
    current_version="76.0.3809.126"
elif [ $ver == 78 ]; then
    current_version="78.0.3904.105"
elif [ $ver == 79 ]; then
    current_version="79.0.3945.36"
elif [ $ver == 80 ]; then
    current_version="80.0.3987.106"
elif [ $ver == 81 ]; then
    current_version="81.0.4044.138"
elif [ $ver == 83 ]; then
    current_version="83.0.4103.39"
elif [ $ver == 84 ]; then
    current_version="84.0.4147.30"
elif [ $ver == 85 ]; then
    current_version="85.0.4183.87"
else
    current_version=$ver
    echo 'Unknown version '$ver', please go to http://chromedriver.storage.googleapis.com/ download manual.'
fi

if [ $ver -lt 70 ]; then
    checkCDV=$current_version
else
    checkCDV=$ver
fi
# echo $checkCDV

# echo $(chromedriver --version | grep -o $checkCDV)

if [ ! -e "./chromedriver" ]; then
    echo "Google Chrome version: "$v
    # system is x86 or x64
    a=$(uname -m)
    if [ $a == i686 ]; then 
        b=32; 
        echo "This system is 32 bits."
    elif [ $a == x86_64 ]; then 
        b=64; 
        echo "This system is 64 bits."
    fi

    # Get chromedriver
    chromeURL='http://chromedriver.storage.googleapis.com/'$current_version'/chromedriver_linux'$b'.zip' 
    echo 'Downloading chromedriver form '$chromeURL
    wget -O chromedriver.zip 'http://chromedriver.storage.googleapis.com/'$current_version'/chromedriver_linux'$b'.zip' 
    unzip chromedriver.zip chromedriver -d '.'
    chmod +x chromedriver
fi
