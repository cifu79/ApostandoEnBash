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
    tput cnorm;exit 1
}
#ctrl_c
trap ctrl_c INT

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}${purpleColour} ./$0${endColour}\n"
    echo -e "\t${blueColour}-m)${endColour} ${grayColour}Dinero con el que se deseas jugar${endColour}"
    echo -e "\t${blueColour}-t)${endColour} ${grayColour}Tecnica a utilizar${endColour} ${purpleColour}(${endColour}${yellowColour}martingala${endColour}${blueColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}"
}

function martingala(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual${endColour} ${yellowColour}$money€${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet
    echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continuamente (par/impar)? ${endColour}-> " && read par_impar 

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} a ${endColour}${yellowColour} $par_impar${endColour}"

    tput civis
    while true; do
        random_number=$(($RANDOM % 37))
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"

        if [ "$(($random_number % 2))" -eq 0 ];then
            if [ "$random_number" -eq 0 ];then
                echo -e "[+] Ha salido el 0, por tanto perdemos"
            else
                echo -e "\n[+] El numero que ha salido es par"
            fi
        else
            echo -e "\n[+] El numero que ha salido es impar"
        fi
        sleep 2
    done
    tput cnorm
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


