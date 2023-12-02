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

    backup_bet=$initial_bet

    tput civis
    while true; do
        money=$(($money-$initial_bet))
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} y tienes${endColour}${yellowColour} $money€${endColour}"
        random_number=$(($RANDOM % 37))
        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${yellowColour} $random_number${endColour}"

        if [ ! "$money" -le 0 ];then
            if [ "$par_impar" == "par" ];then
                if [ "$(($random_number % 2))" -eq 0 ];then
                    if [ "$random_number" -eq 0 ];then
                        echo -e "${yellowColour}[!] Ha salido el 0, por tanto perdemos${endColour}"
                        initial_bet=$(($initial_bet*2))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${yellowColour} $money€${endColour}"
                    else
                        echo -e "\n${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par, ganas!${endColour}"
                        reward=$(($initial_bet*2))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
                        money=$(($money+$reward))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money€${endColour}"
                        initial_bet=$backup_bet
                    fi
                else
                    echo -e "\n${yellowColour}[+]${endColour}${redColour} El numero que ha salido es impar, pierdes!${endColour}"
                    initial_bet=$(($initial_bet*2))
                    echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${yellowColour} $money€${endColour}"
                fi
            fi
    else
        echo -e "\n${redColour}[!] Te has quedado sin pasta${endColour}"
        tput cnorm;exit 0
    fi
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


