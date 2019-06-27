#!/usr/bin/env python
#You need Python 3.x for this to work. It won't work on Python 2.x

import sys
import re
import csv
import os

print("Usage: sslparser.py inputfile.csv\nOutput file: modified.csv")

try:
	filename = sys.argv[1]
except:
	print ('\nYou failed to provide a filename as input on the command line, you fool!\n\nMake sure it is in CSV format')
	sys.exit(1)  # abort, no filename provided

if os.path.exists('modified.csv'):
		os.remove('modified.csv') #this deletes the file
else:
		print("\nProcessing...")#wrong filename
		
try:
	f = open(filename)
except:
	print ('Wrong filename provided! Focus, and try again')
	sys.exit(1)  # abort, wrong filename

try: # Doesn't crash if wrong Python version, gives back error to upgrade Python
	csv_f = csv.reader(f)

	newfile=open("modified.csv", "a+") # new created file is "modified.csv"
	newfile.write("IP, Port, Name, Ciphers & Keys\n")

	for row in csv_f:
	# "If" statement below reads SSL specific plugin IDs 
	# It then adds the (IP, Port, Name) to a new csv file
	# If any "issue" is missing in the file, just add its "ID" number below
		if (row[0]) in ("15901", "20007", "26928", "31705", "35291", "42873", "42880", "45411", "51192", "57582", "62565", "65821", "66848", "69551", "73412", "73639", "76345", "77200", "78479", "81606", "83738", "83875", "89058", "91572", "121009"):
			newfile.write(row[4])	#IP
			newfile.write(",")
			newfile.write(row[6])	#Port
			newfile.write(",")
			newfile.write(row[7])	#Issue Name
			newfile.write(",")
			text = row[12]

			for j in re.compile('\n').split(text):
				j = re.sub(' +', ' ', j.strip())
				match = re.search('(.*) Kx', j)
				if match:
					ciphers = match.group(1)
					newfile.write(ciphers)
					newfile.write(";             ")				
				
				match = re.search('Enc\=([A-Z]*[-]*)*[0-9]*\(*([0-9]*)*\)*\s*(hmac-)*(Mac=)*[A-Z]*[0-9]*(?!\{)', j)
				if match:
					keys = match.group(0)
					newfile.write(keys)
					newfile.write(";             ")
				
			newfile.write(",")
			newfile.write("\n")
			
		if (row[0]) == "": #Abort when all issues parsed
			break

	newfile.close
	print ("\n"
	"Completed successfully\n" 
	"Happy copy + pasta")
except:
	print("\nScript failed to load\nMake sure you have python 3.x")
		
	
'''
For tracking purposes, IDs captured in sequential order are:
15901
20007
26928
31705
35291
42873
42880
45411
51192
57582
62565
65821
66848
69551
73412
73639
76345
77200
78479
81606
83738
83875
89058
91572
121009
'''