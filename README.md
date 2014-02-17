Urban-Data-Hack--IoT
====================

Prompt parking code+data from Feb 14 Hackathon

To create the parking bay availability data follow the following steps

mkdir street.txt
mkdir street.sum

cd street.sum
awk -f get-street-park.awk < ../cashlessparkingdata.csv
cd ..

Execute combine-street.R using R

Execute combine-date.R using R

The directory street.txt should now contain a file for every parking bay, each file containing quarter hour availability data by "day of week"

Merge this data into one file and upload to database.
