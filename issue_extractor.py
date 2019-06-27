# You need Python 3.x for this to work. It won't work on Python 2.x
# Needs 2 arguments when launched
# usage example: "issue_extractor.py inputfile.csv issueID"

import csv
import sys

try:
    filename = sys.argv[1]
except:
	print ('You failed to provide a filename as input on the command line, you fool!')
	sys.exit(1)  # abort, no filename provided

try:
	f = open(filename)
except:
	print ('Wrong filename provided! Focus, and try again')
	sys.exit(1)  # abort, wrong filename

csv_f = csv.reader(f)

newfile=open("issueinfo.csv", "a+") # new created file is "issueinfo.csv"
newfile.write("IP, Port, Name\n")

try:
	issue = sys.argv[2]
except:
	print ('Issue ID not provided! Come on already...')
	sys.exit(1) # abort, no issue ID provided
	
for row in csv_f:
# "If" statement below reads specific plugin ID provided (one only)
# It then adds the (IP, Port, Name) to a new csv file
	if (row[0]) == issue:
		newfile.write(row[4])	#IP
		newfile.write(",")
		newfile.write(row[6])	#Port
		newfile.write(",")
		newfile.write(row[7])	#Issue Name
		newfile.write("\n")
	if (row[0]) == "": #Abort when all issues parsed
		break

newfile.close

