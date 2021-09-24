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

rarete=$(( $RANDOM % 101 ))
csv=$1
declare -a choix
arr=0




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

function aleatoire(){ #accéder au fichier csv pour faire l'aleatoire
    while IFS="," read -r id name hp mp str int def res spd luck race class rarity
    do
	if [[ ($rarete -ge 0) && ($rarete -le 50) ]];then #pour une rareté de 1
	    if [[ $rarity == 1 ]];then
		choix=$choix$name
		echo $name $rarity
	    fi
	elif [[ ($rarete -gt 50) && ($rarete -le 80) ]];then #pour une de 2 ...
	    if [[ $rarity == 2 ]];then
		choix=$choix" "$name
	        echo $name $rarity
	    fi
	elif [[ ($rarete -gt 80) && ($rarete -le 95) ]];then
	    if [[ $rarity == 3 ]];then
		choix+=$choix" "$name
 	        echo $name $rarity==3
	    fi
	elif [[ ($rarete -gt 95) && ($rarete -le 99) ]];then
	    if [[ $rarity == 4 ]];then
		choix=$choix" "$name
		echo $name $rarity==4
	    fi
	elif [[ ($rarete -gt 99) && ($rarete -le 100) ]];then
	    if [[ $rarity == 5 ]];then
		choix=$choix" "$name
		echo $name $rarity==5
	    fi
	    
	fi
    done < $1
}

aleatoire enemies.csv
echo $choix



while [[ $floor -le 10 ]] #le jeu durera jusqu'a l'etage 10 atteint
do
    if [[ $floor -lt 10 ]];then #les 9 étages avant le boss 
	combat #la fonction combat est appellé
	hp_e=$hp_em #soigné la variable vie du monstre pour ne pas sauter des etages
	floor=$(($floor + 1))#augmenter d'etages
    elif [[ $floor -eq 10 ]];then #le combat contre le boss
	ennemi="Ganon"
	hp_e=150 #changer la vie pour celle du boss
	str_e=20 #changer la force ...
	combat
	floor=$(($floor + 1))#monté d'un étage pour finir le jeu
    fi
done
if [[ $hp_e -le 0]];then #message de victoire
    echo "Princesse Zelda: Bien joué link! Tu as sauvé Hyrule! Tu es notre heros!"
elif [[ $hp_p -le 0 ]];then #message de defaite face a ganon
    echo "Princesse Zelda: Tu n'as pas reussi à temps Link... notre monde est perdue..."
    echo "Vous voyez Ganon s'emparer de la tri force et rire face a sa victoire pendant que vous perdez concience"
fi
