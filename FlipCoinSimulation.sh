#!/bin/bash -x

echo " ****************************** WELCOME TO FLIP COIN SIMULATION ****************************** "

#CONSTANT
IS_FLIP=0
NUMBER_OF_COIN=3

#DECLARE DICTIONARY TO STORE TRIPLET COMBINATION OF FLIP COIN
declare -A tripletFlip

#TAKE USER INPUT FOR NUMBER OF COIN FLIPS
read -p "Enter the Number of Coin Flip : " numberOfCoinFlip

#STORE TRIPLET COMBINATION IN DICTIONARY
function triplet()
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
		((tripletFlip[$coinSide]++))
		coinSide=""
	done
}

#CALCULATE PERCENTAGE OF TRIPLET COMBINATION
function calculatePercentage()
{
	for i in ${!tripletFlip[@]}
	do
		tripletFlip[$i]=`echo "scale=2; ${tripletFlip[$i]} * 100 / $numberOfCoinFlip" | bc`
	done
}

#FUNCTION CALL TO FIND TRIPLET COMBINATION
triplet

#FUNCTION CALL TO CALCULATE PERCENTAGE OF TRIPLET COMBINATION
calculatePercentage
