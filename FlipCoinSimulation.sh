#!/bin/bash -x

echo " ****************************** WELCOME TO FLIP COIN SIMULATION ****************************** "

#CONSTANT
IS_FLIP=0
NUMBER_OF_COIN=2

#DECLARE DICTIONARY TO STORE DOUBLET COMBINATION OF FLIP COIN
declare -A doubletFlip

#TAKE USER INPUT FOR NUMBER OF COIN FLIPS
read -p "Enter the Number of Coin Flip : " numberOfCoinFlip

#STORE DOUBLET COMBINATION IN DICTIONARY
function doublet()
{
	for(( flip=0; flip<$numberOfCoinFlip; flip++ ))
	do
		for(( coin=0; coin<$NUMBER_OF_COIN; coin++ ))
		do
			randomFlip=$(( RANDOM % 2 ))

			if [ $randomFlip -eq $IS_FLIP ]
			then
				coinSide+=H
			else
				coinSide+=T
			fi
		done
		((doubletFlip[$coinSide]++))
		coinSide=""
	done
}

#CALCULATE PERCENTAGE OF DOUBLET COMBINATION
function calculatePercentage()
{
	for i in ${!doubletFlip[@]}
	do
		doubletFlip[$i]=`echo "scale=2; ${doubletFlip[$i]} * 100 / $numberOfCoinFlip" | bc`
	done
}

#FUNCTION CALL TO FIND DOUBLET COMBINATION
doublet

#FUNCTION CALL TO CALCULATE PERCENTAGE OF DOUBLET COMBINATION
calculatePercentage

