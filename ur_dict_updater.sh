#!/bin/bash

DEBUG=1
EXISTING_FILE="`mktemp`"
NEW_FILE="`mktemp`"
TARGET_FILE=unirec_fields.md
# Check for md file
if ! [ -s "$TARGET_FILE" ]; then
    echo "Target MD file does not exist or its empty."
	echo "Generating new one.."
	echo "# About this file
This file contains a list of UniRec fields collected from all parts of project (including git submodules).
The part of this file is generated automatically, so be careful during any editing.
# List of UniRec fields

" >"$TARGET_FILE"
fi

if fgrep -q "# List of UniRec fields" "$TARGET_FILE"; then
   existing=1
else
   existing=0
fi


if [ "$existing" -eq 1 ]; then
   # we need to retrieve the list of fields before any updates
   if [ "$DEBUG" -eq 1 ]; then
      echo "Existing section, loading..."
   fi
 # Find the head of the list
 sed -n "/^\# List of UniRec fields\s*$/,/^$/p" "$TARGET_FILE" >"$EXISTING_FILE"

fi


if [ "$DEBUG" -eq 1 ]; then
   echo "Searching for files with UR_FIELDS..."
fi

find . \( -name '*.c' -o -name '*.h' -o -name '*.cpp' \) -exec grep -l "\s*UR_FIELDS\s*" {} \; | #tee /dev/stderr |
# remove line and block comments
   xargs -I{} sed 's,\s*//.*$,,;:a; s%\(.*\)/\*.*\*/%\1%; ta; /\/\*/ !b; N; ba'  {} |
# print contents of UR_FIELDS
   sed -n '/^\s*UR_FIELDS\s*([^)]*$/,/)/p; /^\s*UR_FIELDS\s*([^)]*$/,/)/p' 2>/dev/null |
# clean output to get fields only
   sed 's/^\s*UR_FIELDS\s*(\s*//g; s/)//g; s/,/\n/g; /^\s*$/d; s/^\s*//; s/\s\s*/ /g; s/\s\s*$//' |
# sort by name
   sort -k2 -t' ' | uniq |
# check for conflicting types and print type, name, size of fields
   awk -F' ' 'BEGIN{
'"$sizetable"'
}
{
   print $1, $2;
}' | sort -k2 >"$NEW_FILE" 

#merge temporary files together and sort them
echo "|	Field name	|	Field data type	|	Description	|"
cat "$EXISTING_FILE" "$NEW_FILE" |tail -n+2 |sort -buk2,2 | #>/dev/stderr
awk '
{
	type=$1
	name=$2
	if ( $3=="" ) {
		desc="#TODO DESCRIPTION"	
	}
	else { 
		desc=$3
	}
	print "|"$2"|"$1"|"$3"|"
}'
exit 1;       
