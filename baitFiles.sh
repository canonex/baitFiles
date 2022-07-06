#!/bin/bash

#Copyright (c) 2015 Riccardo Gagliarducci <riccardo@brixel.it>
#https://github.com/canonex/baitFiles

#This is free software. You may redistribute copies of it under the terms of the GNU General Public License.
#There is NO WARRANTY, to the extent permitted by law.

# @author: Brixel - Riccardo Gagliarducci <riccardo@brixel.it>
# @license: GNU v3
# @date: July 4, 2021
#
# Version 0.3


#Check if commands are installed
command -v sha256sum >/dev/null 2>&1 || { echo "$(tput setaf 1)Command sha256sum not found. Exiting. $(tput sgr 0)"; exit 1; }


#Current script dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

LIST="$DIR/list"
HASHES="$DIR/hashes"




#Check if hashes file exists
if [ -f "$HASHES" ]; then


	#Exists: check hashes
	if sha256sum --check "$HASHES"; then
		#perform operation
		echo "$(tput setaf 2)"; echo  "Check successful finished..."; echo "$(tput sgr 0)"
		exit 0
		
	else
		echo "$(tput setaf 1)  * "; echo  "  Check failed, stopping all operations"; echo "  * $(tput sgr 0)"
		logger "baitFiles.sh | Check failed, stopping all operations $?"
		exit 1
	fi


else


	#Does not exists: let's try to create it
	logger "baitFiles.sh | WARNING | Cannot find hashes: let's try to create one based on a file list..."
	echo "$(tput setaf 3)  * "; echo  "  Cannot find hashes: let's try to create one based on a file list..."; echo "  * $(tput sgr 0)"

	
	#Check if list file exists and is not empty
	if [ -f "$LIST" ] && [ -s "$LIST" ]; then
	
	
		#Line by line execution
		while read -r line ; do
		
			#If the list file contains the demo halt...
			if [[ "$line"  =~ "Use your files" ]]; then
				echo "$(tput setaf 1)  * "; echo  "  File list not compiled: please compile list file with your own files"; echo "  * $(tput sgr 0)"
    		exit 4
			fi
		
			sha256sum "$line" >> "$HASHES"
		done < "$LIST"
		
		logger "baitFiles.sh | WARNING | List file generated from list file. You should execute again the software to check if everything is correct"
		echo "$(tput setaf 2)  * "; echo  "  List file generated from list file";
		echo "$(tput setaf 3)  * "; echo "You can generate more complex list by using find, ex. from files named donottouchme.jpg, donottouchme.docx, ecc..."
		echo "You can generate more complex list by using find, ex. to protect files on your home directory "
		echo "    find /home/myuser/ -iname donottouchme* 2>/dev/null -exec bash -c 'sha256sum \"$0\" >> \"$HASHES\"' {} \;"
		echo "or manually using the sha256sum utility ex."
		echo "    sha256sum \"myfile\" >> \"$HASHES\""
		echo "  * $(tput sgr 0)";
		
		exit 2

	else

		logger "baitFiles.sh | ERROR | Cannot find file list: please compile list file with your own files"
		echo "$(tput setaf 1)  * "; echo  "  Cannot find file list: please compile list file with your own files"; echo "  * $(tput sgr 0)"
		

		echo 'Write here the list of files on which you want an equality test done. Of course, the test will fail if even one file changes.
For using these files in any circumstances it is good to use the absolute paths (starting with /). 
Delete everything else, only the list of files should remain! And leave no blank line at the end!
/myfolder/myexamplefile1.doc
/myfolder/myexamplefile2.jpg
/myfolder/myexamplefile3.avi
...' > "$LIST"

		chown "$OWNER":"$OWNER" "$LIST"

		exit 3
	fi
fi


logger "baitFiles.sh | End"

exit 5

