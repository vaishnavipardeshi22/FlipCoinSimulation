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

	if [ $NUMBER_OF_COIN -eq $SINGLET ]
	then
		for index in ${!singletFlip[@]}
		do
			singletFlip[$index]=`echo "scale=2; ${singletFlip[$index]} * 100 / $numberOfCoinFlip" | bc`
		done
	elif [ $NUMBER_OF_COIN -eq $DOUBLET ]
	then
		for index in ${!doubletFlip[@]}
		do
			doubletFlip[$index]=`echo "scale=2; ${doubletFlip[$index]} * 100 / $numberOfCoinFlip" | bc`
		done
	else
		for index in ${!tripletFlip[@]}
		do
			tripletFlip[$index]=`echo "scale=2; ${tripletFlip[$index]} * 100 / $numberOfCoinFlip" | bc`
		done
	fi
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

#FUNCTION CALL TO FIND SINGLET, DOUBLET AND TRIPLET COMBINATION
coinFlip $SINGLET
coinFlip $DOUBLET
coinFlip $TRIPLET

#FUNCTION CALL TO CALCULATE PERCENTAGE OF SINGLET, DOUBLET AND TRIPLET COMBINATION
calculatePercentage $SINGLET
calculatePercentage $DOUBLET
calculatePercentage $TRIPLET

#FUNCTION CALL TO SORT AND GET WINNING COMBINATION FOR SINGLET, DOUBLET AND TRIPLET
arraySinglet="$(dictionaryConvert ${!singletFlip[@]} ${singletFlip[@]})"
arraySinglet=($(sortCombination $arraySinglet))
singletWinningCombination=${arraySinglet[0]}

arrayDoublet="$(dictionaryConvert ${!doubletFlip[@]} ${doubletFlip[@]}})"
arrayDoublet=($(sortCombination $arrayDoublet))
doubletWinningCombination=${arrayDoublet[0]}

arrayTriplet="$(dictionaryConvert ${!tripletFlip[@]} ${tripletFlip[@]})"
arrayTriplet=($(sortCombination $arrayTriplet))
tripletWinningCombination=${arrayTriplet[0]}
