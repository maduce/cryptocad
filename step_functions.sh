#!/bin/sh

function grab_header() {
local file=$1
awk '/HEADER;/,/FILE_SCHEMA/' $file

}

function graball_Coordinate_Points () {
local file=$1

awk '/DATA/,/Failed/' $file |grep CARTESIAN_POINT | sed 's/[^ ]* //' | sed 's/[^ ]* //' | sed 's/[^ ]* //' | sed 's/[^ ]* //' | sed 's/[^ ]* //'

}

function Coordinate_xyz_Scramble() {

local filetemp=$1
local modulo_factor=$2
local string1="CARTESIAN_POINT" 
local output=$(echo output.step)
rm -f $output

while read line           
do           
    # echo $line |awk '{print $3}'           
    local string_temp=$(echo $line |awk '{print $3}');

case "$string_temp" in
    $string1)  
            #changing coordinates
            local x_coordinate=$(echo $line |awk '{print $7}' | cut -d "," -f 1)
            local y_coordinate=$(echo $line |awk '{print $8}' | cut -d "," -f 1)
            local z_coordinate=$(echo $line |awk '{print $9}' | cut -d "," -f 1)
            local row_number=$(echo $line |awk '{print $1}' |cut -d "#" -f 2);
            #local sign_exponent=$(echo "$row_number % 2" |bc)
            local row_number_mod3=$(echo "$row_number % 3" |bc)
            local scramble_term=$(echo "$row_number % $modulo_factor" |bc)

            case $row_number_mod3 in 
                0)
                 echo "$row_number is 0"
                 echo $line |sed "s/$x_coordinate/$(echo $x_coordinate + $scramble_term | bc)/g" >>$output
                 ;;

                1)
                 echo "$row_number is 1"
                 echo $line |sed "s/$y_coordinate/$(echo $y_coordinate + $scramble_term | bc)/g" >>$output
                 ;;

                2)
                 echo "$row_number is 2"
                 echo $line |sed "s/$z_coordinate/$(echo $z_coordinate + $scramble_term | bc)/g" >>$output
                 ;;
            esac
            ;;
            
           *) 
            echo $line >> $output
            ;;
esac
done <$filetemp
}

function Coordinate_xyz_unScamble() {

local filetemp=$1
local modulo_factor=$2
local string1="CARTESIAN_POINT" 
local output=$(echo original	.step)
rm -f $output

while read line           
do           
    # echo $line |awk '{print $3}'           
    local string_temp=$(echo $line |awk '{print $3}');

case "$string_temp" in
    $string1)  
            #changing coordinates
            local x_coordinate=$(echo $line |awk '{print $7}' | cut -d "," -f 1)
            local y_coordinate=$(echo $line |awk '{print $8}' | cut -d "," -f 1)
            local z_coordinate=$(echo $line |awk '{print $9}' | cut -d "," -f 1)
            local row_number=$(echo $line |awk '{print $1}' |cut -d "#" -f 2);
            #local sign_exponent=$(echo "$row_number % 2" |bc)
            local row_number_mod3=$(echo "$row_number % 3" |bc)
            local scramble_term=$(echo "$row_number % $modulo_factor" |bc)

            case $row_number_mod3 in 
                0)
                 echo "$row_number is 0"
                 echo $line |sed "s/$x_coordinate/$(echo $x_coordinate - $scramble_term | bc)/g" >>$output
                 ;;

                1)
                 echo "$row_number is 1"
                 echo $line |sed "s/$y_coordinate/$(echo $y_coordinate - $scramble_term | bc)/g" >>$output
                 ;;

                2)
                 echo "$row_number is 2"
                 echo $line |sed "s/$z_coordinate/$(echo $z_coordinate - $scramble_term | bc)/g" >>$output
                 ;;
            esac
            ;;
            
           *) 
            echo $line >> $output
            ;;
esac
done <$filetemp
}

## test. You can change 3 to any integer you desire.
#Coordinate_xyz_Scramble $1 3
#Coordinate_xyz_unScramble $1 3
