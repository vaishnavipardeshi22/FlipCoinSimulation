#!/bin/bash -x

echo " ****************************** WELCOME TO FLIP COIN SIMULATION ****************************** "

#CONSTANT
IS_FLIP=0
SINGLET=1
DOUBLET=2
TRIPLET=3

#DECLARE DICTIONARY TO STORE SINGLET, DOUBLET AND TRIPLET COMBINATION OF FLIP COIN
declare -A singletFlip
declare -A doubletFlip
declare -A tripletFlip

#TAKE USER INPUT FOR NUMBER OF COIN FLIPS
read -p "Enter the Number of Coin Flip : " numberOfCoinFlip

#STORE COMBINATIONS IN DICTIONARY
function coinFlip()
{
	local NUMBER_OF_COIN=$1

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

		if [ $NUMBER_OF_COIN -eq $SINGLET ]
		then
			((singletFlip[$coinSide]++))
		elif [ $NUMBER_OF_COIN -eq $DOUBLET ]
		then
			((doubletFlip[$coinSide]++))
		else
			((tripletFlip[$coinSide]++))
		fi
		coinSide=""
	done
}

#CALCULATE PERCENTAGE OF COMBINATIONS
function calculatePercentage()
{
	local NUMBER_OF_COIN=$1
	array=("$@")

	for index in ${!array[@]}
	do
		key=$(echo ${array[index]} | awk -F: '{print $1}')
		value=$(echo ${array[index]} | awk -F: '{print $2}')
		array[$index]=$key:`echo "scale=2; $value * 100 / $numberOfCoinFlip" | bc`
	done
	echo ${array[@]}
}

#FUNCTION TO CONVERT DICTIONARY TO ARRAY
function dictionaryConvert()
{
	arrayKeyValue=("$@")
	local NO_OF_COMBINATIONS=$((${#arrayKeyValue[@]}/2))

	for(( index=0; index<$NO_OF_COMBINATIONS; index++))
	do
		resultArray[$index]=${arrayKeyValue[$index]}:${arrayKeyValue[$NO_OF_COMBINATIONS+$index]}
	done
	echo ${resultArray[@]}
}

#FUNCTION FOR SORTING SINGLET, DOUBLET AND TRIPLET COMBINATION
function sortCombination()
{
	arrayKeyValues=("$@")
	local NO_OF_COMBINATIONS=${#arrayKeyValues[@]}

	for(( i=0; i<$NO_OF_COMBINATIONS; i++ ))
	do
		for(( j=0; j<$(($NO_OF_COMBINATIONS-1)); j++ ))
		do
			firstCombination=$(echo ${arrayKeyValues[j]} | awk -F: '{print $2}')
			secondCombination=$(echo ${arrayKeyValues[j+1]} | awk -F: '{print $2}')

			if (( $(echo "$firstCombination < $secondCombination" | bc -l) ))
			then
				temp=${arrayKeyValues[j]}
				arrayKeyValues[j]=${arrayKeyValues[j+1]}
				arrayKeyValues[j+1]=$temp
			fi
		done
	done
	echo ${arrayKeyValues[@]}
}

echo "Enter 1 For Singlet Combination"
echo "Enter 2 For Doublet Combination"
echo "Enter 3 For Triplet Combination"

read -p "Enter Your Choice: " choice

#USING CASE STATEMENT GET SINGLET, DOUBLET AND TRIPLET COMBINATION
case $choice in
	$SINGLET)
		coinFlip $SINGLET
		arraySinglet="$(dictionaryConvert ${!singletFlip[@]} ${singletFlip[@]})"
		arraySinglet=($(calculatePercentage ${arraySinglet[@]}))
		arraySinglet=($(sortCombination ${arraySinglet[@]}))
		singletWinningCombination=${arraySinglet[0]}
		;;
	$DOUBLET)
		coinFlip $DOUBLET
		arrayDoublet="$(dictionaryConvert ${!doubletFlip[@]} ${doubletFlip[@]})"
		arrayDoublet=($(calculatePercentage ${arrayDoublet[@]}))
		arrayDoublet=($(sortCombination ${arrayDoublet[@]}))
		doubletWinningCombination=${arrayDoublet[0]}
		;;
	$TRIPLET)
		coinFlip $TRIPLET
		arrayTriplet="$(dictionaryConvert ${!tripletFlip[@]} ${tripletFlip[@]})"
		arrayTriplet=($(calculatePercentage ${arrayTriplet[@]}))
		arrayTriplet=($(sortCombination ${arrayTriplet[@]}))
		tripletWinningCombination=${arrayTriplet[0]}
		;;
	*)
		echo "Enter the value between 1 to 3"
		;;
esac

