#!/bin/bash -x

echo " ****************************** WELCOME TO FLIP COIN SIMULATION ****************************** "

#CONSTANT
IS_FLIP=0

#VARIABLES
headCount=0
tailCount=0

#DECLARE DICTIONARY TO STORE SINGLET COMBINATION OF FLIP COIN
declare -A singletFlip

#TAKE USER INPUT FOR NUMBER OF COIN FLIPS
read -p "Enter the Number of Coin Flip : " numberOfCoinFlip

#STORE HEAD COUNT AND TAIL COUNT IN DICTIONARY
for(( flip=0; flip<$numberOfCoinFlip; flip++ ))
do
	randomFlip=$(( RANDOM % 2 ))

	if [ $randomFlip -eq $IS_FLIP ]
	then
		singletFlip[HEAD]=$((++headCount))
	else
		singletFlip[TAIL]=$((++tailCount))
	fi
done

#PERCENTAGE OF SINGLET COMBINATION FOR HEAD AND TAIL
singletHeadPercentage=`echo " scale=2; $headCount / $numberOfCoinFlip * 100" | bc`
singletTailPercentage=`echo " scale=2; $tailCount / $numberOfCoinFlip * 100" | bc`
