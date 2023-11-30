#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
    echo -e "\n\n\t${redColour}[!] Saliendo....${endColour}\n"
    exit 1
}
#ctrl_c
trap ctrl_c INT

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} ./$0${endColour}\n"
    echo -e "\t${blueColour}-m)${endColour} ${grayColour}Dinero con el que se deseas jugar${endColour}"
    echo -e "\t${blueColour}-t)${endColour} ${grayColour}Tecnica a utilizar${endColour} ${purpleColour}(${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}"
}

function martingala(){
    echo -e "\n [+] Vamos a jugar con la tecnica martingala"
}


while getopts "m:t:h" args; do
    case $args in
        m) money=$OPTARG;;
        t) technique=$OPTARG;;
        h) ;;
    esac
done

if [ $money ] && [ $technique ];then
    if [ "$technique" == "martingala" ];then
        martingala
    else
        echo -e "\n${redColour}[!] La tecnica utilizada no existe${endColour}\n"
    fi
else
    helpPanel
fi


