#!/bin/bash

# new echo (print)
print() {
    local str=$1
    echo -e $str>&2
}

# print install message.
echoInstallMsg() {
    local commandName=$1
    local msg=$2
    if [ ${#commandName} -lt 8 ]; then
        fullMsg=$commandName'\t\t'$msg
        print $fullMsg
    else
        fullMsg=$commandName'\t'$msg>&2
        print $fullMsg
    fi
}

# check command be installed.
checkInstall() {
    local commandName=$1   # command name
    exist=""               # return value
    # "command -v $commandName >/dev/null" is used to check command exist.
    # if exist, commandExist will be not null
    if $(command -v $commandName >/dev/null); then
        echoInstallMsg $commandName '...installed.'
        exist="True"
    else
        echoInstallMsg $commandName '...not install.'
        exist="False" 
    fi
    echo $exist
    # return $exist
}

# Get system bits
getSystemVersion() {
    # system is x86 or x64
    local a=$(uname -m)
    if [ $a == i686 ]; then 
        b=32; 
        print "This system is 32 bits."
    elif [ $a == x86_64 ]; then 
        b=64; 
        print "This system is 64 bits."
    fi
    return $b
}

# Get chrome version
getChromeVersion() {
    v=$(google-chrome --version | sed "s/Google Chrome //g" | sed "s/\..*//g")
    ver=$((v)) # chrome version
    print "Google Chrome version: "$v
    return $ver
}

# Get chromedriver version
getCDVersion() {
    getChromeVersion
    local ver=$?

    # Set chromedriver version
    if [ $ver -le 70 ] && [ $ver -ge 68 ]; then
        currentVersion="2.42"
    elif [ $ver -le 67 ] && [ $ver -ge 69 ]; then
        currentVersion="2.41"
    elif [ $ver -le 68 ] && [ $ver -ge 66 ]; then
        currentVersion="2.40"
    elif [ $ver -le 67 ] && [ $ver -ge 65 ]; then
        currentVersion="2.38"
    elif [ $ver -le 66 ] && [ $ver -ge 64 ]; then
        currentVersion="2.37"
    elif [ $ver -le 65 ] && [ $ver -ge 63 ]; then
        currentVersion="2.36"
    elif [ $ver -le 64 ] && [ $ver -ge 62 ]; then
        currentVersion="2.35"
    elif [ $ver -le 63 ] && [ $ver -ge 61 ]; then
        currentVersion="2.34"
    elif [ $ver -le 62 ] && [ $ver -ge 60 ]; then
        currentVersion="2.33"
    elif [ $ver -le 61 ] && [ $ver -ge 59 ]; then
        currentVersion="2.32"
    elif [ $ver -le 60 ] && [ $ver -ge 58 ]; then
        currentVersion="2.31"
    elif [ $ver -le 58 ] && [ $ver -ge 56 ]; then
        currentVersion="2.29"
    elif [ $ver == 70 ]; then
        currentVersion="70.0.3538.97"
    elif [ $ver == 71 ]; then
        currentVersion="71.0.3578.137"
    elif [ $ver == 72 ]; then
        currentVersion="72.0.3626.69"
    elif [ $ver == 73 ]; then
        currentVersion="73.0.3683.68"
    elif [ $ver == 74 ]; then
        currentVersion="74.0.3729.6"
    elif [ $ver == 75 ]; then
        currentVersion="75.0.3770.140"
    elif [ $ver == 76 ]; then
        currentVersion="76.0.3809.126"
    elif [ $ver == 78 ]; then
        currentVersion="78.0.3904.105"
    elif [ $ver == 79 ]; then
        currentVersion="79.0.3945.36"
    elif [ $ver == 80 ]; then
        currentVersion="80.0.3987.106"
    elif [ $ver == 81 ]; then
        currentVersion="81.0.4044.138"
    elif [ $ver == 83 ]; then
        currentVersion="83.0.4103.39"
    elif [ $ver == 84 ]; then
        currentVersion="84.0.4147.30"
    elif [ $ver == 85 ]; then
        currentVersion="85.0.4183.87"
    else
        # currentVersion=$ver
        print 'Unknown version '$ver', please go to "http://chromedriver.storage.googleapis.com/" download manual.'
    fi
    echo $currentVersion
}

# install wget, unzip, google-chrome and pip
installCommand() {

    # start check
    installedWget=$(checkInstall "wget")
    installedUnzip=$(checkInstall "unzip")
    installedGC=$(checkInstall "google-chrome")
    installedPython=$(checkInstall "python")
    installedPip=$(checkInstall "pip")
   
    # if not install
    if [ $installedWget == "False"  ] || [ $installedUnzip == "False" ] || [ $installedGC == "False" ] || [ $installedPython == "False" ] || [ $installedPip == "False" ]; then
        
        # update
        sudo apt-get update

        # install wget or not
        if [ $installedWget == "False" ]; then
            sudo apt-get install -y wget
        fi

        # install unzip or not
        if [ $installedUnzip == "False" ]; then
            sudo apt-get install -y unzip
        fi

        # install google-chrome or not
        if [ $installedGC == "False" ]; then
            wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i google-chrome-stable_current_amd64.deb
            sudo apt-get install
            sudo apt-get install -f
            rm google-chrome-stable_current_amd64.deb
        fi

        # install python or not
        if [ $installedPython == "False" ]; then
            sudo apt-get install -y python
        fi

        # install pip or not
        if [ $installedPip == "False" ]; then
            wget https://raw.githubusercontent.com/pypa/get-pip/master/get-pip.py
            sudo python get-pip.py
            rm -f get-pip.py
        else
            # install selenium or not
            checkSelenium=$(pip list 2>/dev/null | grep "selenium")
            if [ -z "$checkSelenium" ]; then
                python -m pip install --upgrade pip
                sudo pip install -U selenium
            fi
        fi
    else
        echo "wget, unzip, google-chrome, python and pip installed already."
    fi

    
}

# get chromedriver
getCD() {
    # if chromedriver not exist
    if [ ! -e "./chromedriver" ]; then

        # get chrome version
        CDVer=$(getCDVersion)
        if ! $CDVer; then
            # get system bits
            getSystemVersion
            bits=$?

            # Get chromedriver
            chromeURL='http://chromedriver.storage.googleapis.com/'$CDVer'/chromedriver_linux'$bits'.zip' 
            echo 'Downloading chromedriver form '$chromeURL
            wget -O chromedriver.zip $chromeURL 
            unzip chromedriver.zip chromedriver -d '.'
            chmod +x chromedriver
            rm chromedriver.zip
        fi
    fi
}

# main function
main() {
    installCommand
    getCD
}

main
