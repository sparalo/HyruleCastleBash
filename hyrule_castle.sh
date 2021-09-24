#!/bin/bash

player="Link" #stats du joueur
hp_pm=60
hp_p=60
str_p=15

ennemi="Bokoblin" #stats du monstre
hp_em=30
hp_e=30
str_e=5

floor=1

function ecran() {
    echo ====== FIGHT $floor ======
    echo $ennemi
    echo "HP=" $hp_e
    echo ""
    echo $player
    echo "HP=" $hp_p
    echo ""
    echo ------ Option ------
    echo "1. attack"  "2. heal"
}

function combat() {
    ecran #appel de l'ecran
    while [[ ($hp_p -gt 0) && ($hp_e -gt 0) ]] #boucle du combat 
    do
	read action #choix de l'action
	if [[ $action == "attack" ]];then 
	    echo tu as attaqué et fais $str_p de dégats
	    hp_e=$(($hp_e - $str_p)) #diminution pv joueur 
	    echo $ennemi a attaqué et fait $str_e de dégats
	    hp_p=$(($hp_p - $str_e)) #diminution pv du monstre
	    echo""
	    ecran
	    
	elif [[ $action == "heal" ]];then
	    if [[ $hp_p -eq $hp_pm ]];then #si pv = pv max
		echo "Navi: Link tu n'en as pas besoin!"
	    else
		hp_p=$(($hp_p+$hp_pm/2)) #soin de moitié des pv max
		if [[ $hp_p -gt $hp_pm ]];then # ligne de sureté eviter triche 
		    hp_p=$hp_pm #pv ramené au max
		    echo "tu t'es soigné"
		    echo""
		    ecran
		else
		    echo "tu t'es soigné"
		    echo""
		    ecran
		fi
	    fi
	fi
    done
    if [[ $hp_p -le 0 ]];then #phrase de fin de combat
	echo "Navi: Link! Réveille toi tu ne peux pas echouer maintenant!"
    else
	echo $ennemi a été pourfendu
	echo""
    fi
    
    
	
}

while [[ $floor -le 10 ]]
do
    if [[ $floor -lt 10 ]];then
	combat
	hp_e=$hp_em
	floor=$(($floor + 1))
    elif [[ $floor -eq 10 ]];then
	ennemi="Ganon"
	hp_e=150
	str_e=20
	combat
	floor=$(($floor + 1))
    fi
done
if [[ $hp_e -le 0]];then
    echo "Princesse Zelda: Bien joué link! Tu as sauvé Hyrule! Tu es notre heros!"
elif [[ $hp_p -le 0 ]];then
    echo "Princesse Zelda: Tu n'as pas reussi à temps Link... notre monde est perdue..."
fi
