#!/bin/bash -x

echo " ****************************** WELCOME TO FLIP COIN SIMULATION ****************************** "

#CONSTANT
IS_FLIP=0

#STORE RANDOM VALUES 1 OR 0 FOR COIN FLIP
randomFlip=$(( RANDOM % 2 ))

#CHECK COIN FLIP IS HEADS OR TAILS
if [ $randomFlip -eq $IS_FLIP ]
then
	echo Heads
else
	echo Tails
fi
