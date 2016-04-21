#!/usr/bin/bash
# Description: Homegrown script to download pictures posted on Tadpoles.
######################################################################
# Usage: tadpoles_downloader.sh <input_file>
#   Where <input_file> contains URL of tadpoles for particular day
######################################################################
#wget syntax        
#wget <url> -O <new_file_name> 
#wget https://www.tadpoles.com/m/p/ZfShwgoKAxpCEC8NkTuctE?d=t -O filename.jpg
######################################################################

declare -i count
count=1
######################################################################
# Logic
# read each line from inputfile (arg1)
# expect inputfile name to be <child>-<yyyymmdd>
# wget to pull each file from tadpoles website
# rename file to naming convention:
#   Kiddie_Academy_<child><yyyymmdd><file#>.<jpg|mp4>
######################################################################
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "[CMD] wget $line?d=t -O $$.tmp"
    wget $line?d=t -O $$.tmp
    # Add case statement to check file= jpg or iso #file $$.tmp
    TYPE=`file $$.tmp | awk '{ print $2 }' `
    case "$TYPE" in
    JPEG)
        echo "TYPE is a jpg"
        echo "[CMD] mv $$.tmp Kiddie_Academy_$1_$count.jpg"
        mv $$.tmp Kiddie_Academy_$1_$count.jpg
        ;;
    ISO)
        echo "TYPE is a mp4"
        echo "[CMD] mv $$.tmp Kiddie_Academy_$1_$count.mp4"
        mv $$.tmp Kiddie_Academy_$1_$count.mp4
        ;;
    *)
        echo "[ERROR] file type is not JPEG/ISO"
        echo "[ERROR] will not act on this file: $$.tmp"
        echo "[ERROR] skipping"
        ;;
    esac
    count=$count+1
done < "$1"
