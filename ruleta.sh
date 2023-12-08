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
        random_number=$(($RANDOM % 37))

        if [ ! "$money" -lt 0 ];then
            if [ "$par_impar" == "par" ];then
                if [ "$(($random_number % 2))" -eq 0 ];then
                    if [ "$random_number" -eq 0 ];then
                        initial_bet=$(($initial_bet*2))
                        jugadas_malas+="$random_number "
                    else
                        reward=$(($initial_bet*2))
                        money=$(($money+$reward))
                        initial_bet=$backup_bet
                        jugadas_malas=""
                    fi
                else
                    initial_bet=$(($initial_bet*2))
                    jugadas_malas+="$random_number "
                fi
            else
                if [ "$(($random_number % 2))" -eq 1 ];then

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

    jugadas_totales=0
    bet_to_renew=$(($money+50)) #Dinero el cual una vez alcanzado hara que renovemos nuestra secuencia 1 2 3 4

    echo -e "${yellowColour}[+]${endColour}${grayColour} El tope a renovar la secuencia esta establecido por encima de los ${endColour}${yellowColour} $bet_to_renew€${endColour}"

    # sleep 10

    echo $bet_to_renew
    # sleep 10

    tput civis
    while true;do
        let jugadas_totales+=1
        random_number=$(($RANDOM % 37))
        money=$(($money - $bet))
        if [ ! "$money" -lt 0 ];then
            
            echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet€${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money€${endColour}"


            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"

            if [ "$par_impar" == "par" ];then
                if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ];then
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El numero es par, ganas${endColour}"
                    reward=$(($bet*2))
                    let money+=$reward
                    echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money€${endColour}"

                    if [ $money -gt $bet_to_renew ];then
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope establecido de${endColour}${yellowColour} $bet_to_renew€${endColour}${grayColour} para renovar nuestra secuencia${endColour}"
                        bet_to_renew=$(($bet_to_renew + 50))
                        echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tope se ha establecido${endColour}${yellowColour} $bet_to_renew€${endColour}"
                        my_sequence=(1 2 3 4)
                        bet=$((${my_sequence[0]}+${my_sequence[-1]}))        
                        echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a${endColour}${yellowColour} [${my_sequence[@]}]${endColour}"
                    else

                        my_sequence+=($bet)
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva secuencia es${endColour}${greenColour} [${my_sequence[@]}] ${endColour}"
                        if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ];then
                            bet=$((${my_sequence[0]}+${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ];then
                            bet=${my_sequence[0]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
                            bet=$((${my_sequence[0]}+${my_sequence[-1]}))
                        fi
                fi
                elif [ "$(($random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ];then
                    if [ "$(($random_number % 2))" -eq 1 ];then
                        echo -e "${redColour}[!] El numero es impar, pierdes${endColour}"
                    else
                        echo -e "${redColour}[!] Ha salido el numero cero, pierdes${endColour}"
                    fi
                    unset my_sequence[0]
                    unset my_sequence[-1] 2>/dev/null

                    my_sequence=(${my_sequence[@]})

                    echo -e "${yellowColour}[+]${endColour}${grayColour} La sequencia se nos queda de la siguiente forma:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

                    if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ];then
                        bet=$((${my_sequence[0]}+${my_sequence[-1]}))
                    elif [ "${#my_sequence[@]}" -eq 1 ];then
                        bet=${my_sequence[0]}
                    else
                        echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                        my_sequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]}+${my_sequence[-1]}))
                    fi
                fi
            fi
        else
            echo -e "\n${redColour} Te has quedado sin pasta!${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} En total han habido${endColour}${yellowColour} $jugadas_totales${endColour}${grayColour} jugadas totales${endColour}\n"
            tput cnorm; exit 1
        fi

        # sleep 1
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