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
    play_counter=1
    jugadas_malas=""

    tput civis
    while true; do
        money=$(($money-$initial_bet))
#        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} y tienes${endColour}${yellowColour} $money€${endColour}"
        random_number=$(($RANDOM % 37))
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${yellowColour} $random_number${endColour}"

        if [ ! "$money" -lt 0 ];then
            if [ "$par_impar" == "par" ];then
                #Toda esta definicion es para cuando apostamos por numeros pares
                if [ "$(($random_number % 2))" -eq 0 ];then
                    if [ "$random_number" -eq 0 ];then
#                        echo -e "${yellowColour}[!] Ha salido el 0, por tanto perdemos${endColour}"
                        initial_bet=$(($initial_bet*2))
                        jugadas_malas+="$random_number "
#                        echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${yellowColour} $money€${endColour}"
                    else
#                        echo -e "\n${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par, ganas!${endColour}"
                        reward=$(($initial_bet*2))
#                        echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
                        money=$(($money+$reward))
#                        echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money€${endColour}"
                        initial_bet=$backup_bet
                        jugadas_malas=""
                    fi
                else
#                    echo -e "\n${yellowColour}[+]${endColour}${redColour} El numero que ha salido es impar, pierdes!${endColour}"
                    initial_bet=$(($initial_bet*2))
                    jugadas_malas+="$random_number "
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour}${yellowColour} $money€${endColour}"
                fi
            else
                #Toda esta definicion es para cuando apostamos por numeros impares
                if [ "$(($random_number % 2))" -eq 1 ];then

#                    echo -e "${yellowColour}[+]${endColour} ${grayColour}El numero que ha salido es impar, ganas!${endColour}"
                    reward=$(($initial_bet*2))
                    money=$(($money+$reward))
                    initial_bet=$backup_bet
                    jugadas_malas=""
                else
                    initial_bet=$(($initial_bet*2))
                    jugadas_malas+="$random_number "
            fi
        fi
    else
        #Nos quedamos sin pasta
        echo -e "\n${redColour}[!] Te has quedado sin pasta${endColour}\n"
        echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $(($play_counter-1))${endColour} ${grayColour}jugadas${enColour}"

        echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuacion se van a representar las malas jugadas consecutivas que han salido${endColour}\n"
        echo -e "${blueColour}[ $jugadas_malas]${endColour}"
        tput cnorm;exit 0
    fi

    let play_counter+=1
    done
    tput cnorm
}


function inverseLabrouchere(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual${endColour} ${yellowColour}$money€${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour} A que deseas apostar continuamente (par/impar)? ${endColour}-> " && read par_impar 

    declare -a my_sequence=(1 2 3 4)

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} ${my_sequence[@]}${endColour}"

    bet=$((${my_sequence[0]}+${my_sequence[-1]}))

    unset my_sequence[0]
    unset my_sequence[-1]

    my_sequence=(${my_sequence[@]})
    echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet€${endColour}${grayColour} y nuestra secuencia se queda en${endColour}${greenColour} ${my_sequence[@]}${endColour}"

    tput civis
    while true;do
        random_number=$(($RANDOM % 37))

        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"

        if [ "$par_impar" == "par" ];then
            if [ "$(($random_number % 2))" -eq 0 ];then
                echo -e "${yellowColour}[+]${endColour}${grayColour} El numero es par, ganas${endColour}"
            else
                echo -e "${redColour}[!] El numero es impar, pierdes${endColour}"
            fi
        else
            echo -e "por el momento nada"
        fi

        sleep 10
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
    elif [ "$technique" == "inverseLabrouchere" ];then
        inverseLabrouchere
    else
        echo -e "\n${redColour}[!] La tecnica utilizada no existe${endColour}\n"
    fi
else
    helpPanel
fi