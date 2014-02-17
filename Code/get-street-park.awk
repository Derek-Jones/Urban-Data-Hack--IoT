#
# get-street-park.R, 15 Feb 14

BEGIN {
	FS=","
	dofw["monday"]=1
	dofw["tuesday"]=2
	dofw["wednesday"]=3
	dofw["thursday"]=4
	dofw["friday"]=5
	dofw["saturday"]=6
	dofw["sunday"]=7
	}

{
gsub(/"/, "", $0)

destfile="street/" $9

print $1 "," substr($3, 1, 10) "," dofw[tolower($4)] "," $7 "," $8  >> destfile
#print $1 "," substr($3, 1, 10) "," dofw[tolower($4)] "," $7 "," $8
}
