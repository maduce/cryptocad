#!/bin/sh

function grab_header() {
local file=$1
awk '/HEADER;/,/FILE_SCHEMA/' $file

}

function graball_Coordinate_Points() {
local file=$1

awk '/DATA/,/Failed/' $file |grep CARTESIAN_POINT | sed 's/[^ ]* //' | sed 's/[^ ]* //' | sed 's/[^ ]* //' | sed 's/[^ ]* //' | sed 's/[^ ]* //'

}

function Coordinate_Scramble() {

local scrambleopt=$1
local modulo_factor=$2
local filetemp=$3
local row_total=$(graball_Coordinate_Points $filetemp |wc -l)
local string1="CARTESIAN_POINT" 
rm -f $output

# check if user is scrambling or descrambling
case "$scrambleopt" in
    scramble)
            local output=$(echo output.step)
            local scramblesign=$(echo +)
            echo
            echo "* Scrambling $row_total lines in $filetemp. Saving as $output"
            ;;
         
    descramble)
            local output=$(echo original.step)
            local scramblesign=$(echo -)
            echo
            echo "* Descrambling $row_total lines in  $filetemp. Saving as $output..."

            ;;
    *)
            exit 1
            ;;
esac

while read line           
do           
    local string_temp=$(echo $line |awk '{print $3}');

case "$string_temp" in
    $string1)  
            #grabing coordinates
            local x_coordinate=$(echo $line |awk '{print $7}' | cut -d "," -f 1)
            local y_coordinate=$(echo $line |awk '{print $8}' | cut -d "," -f 1)
            local z_coordinate=$(echo $line |awk '{print $9}' | cut -d "," -f 1)
            local row_number=$(echo $line |awk '{print $1}' |cut -d "#" -f 2);
            #local sign_exponent=$(echo "$row_number % 2" |bc)
            local row_number_mod3=$(echo "$row_number % 3" |bc)
            local scramble_term=$(echo "$row_number % $modulo_factor" |bc)
            local progress=$(echo "scale = 2 ; $row_number*100/$row_total" |bc)

            case $row_number_mod3 in 
                0)
                 echo $line |sed "s/$x_coordinate/$(echo $x_coordinate $scramblesign $scramble_term | bc)/g" >>$output
                 echo -n "  [:)  ] $progress% finished."
                 echo -n R | tr 'R' '\r'
                 ;;

                1)
                 echo $line |sed "s/$y_coordinate/$(echo $y_coordinate $scramblesign $scramble_term | bc)/g" >>$output
                 echo -n "  [ :) ] $progress% finished."
                 echo -n R | tr 'R' '\r'
                 ;;

                2)
                 echo $line |sed "s/$z_coordinate/$(echo $z_coordinate $scramblesign $scramble_term | bc)/g" >>$output
                 echo -n "  [  :)] $progress% finished."
                 echo -n R | tr 'R' '\r'
                 ;;
            esac
            ;;
            
           *) 
            echo $line >> $output
            ;;
esac
done <$filetemp
}

## test - Note you must use same number to unscramble.
# Coordinate_Scramble <scramble|descramble> <number> file.step
Coordinate_Scramble $1 $2 $3
