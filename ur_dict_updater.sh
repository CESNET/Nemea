#!/bin/bash

DEBUG=1
EXISTING_FILE="`mktemp`"
NEW_FILE="`mktemp`"
TARGET_FILE=unirec_fields.md
# check for md file
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
# find the head of the list
 sed -n "/^\# List of UniRec fields\s*$/,/^$/p" "$TARGET_FILE" | tail -n +3 | sed 's/| *\([^ ]*\) *| *\([^ ]*\) *| *\([^|]*\)|/\1 \2 \3/g' >"$EXISTING_FILE"

fi

if [ "$DEBUG" -eq 1 ]; then
   echo "Searching for files with UR_FIELDS..."
fi

find . \( -name '*.c' -o -name '*.h' -o -name '*.cpp' \) -exec grep -l "\s*UR_FIELDS\s*" {} \; | #tee /dev/stderr |
# remove line and block comments
   xargs -I{} sed 's,\s*//.*$,,;:a; s%\(.*\)/\*.*\*/%\1%; ta; /\/\*/ !b; N; ba' {} |
# print contents of UR_FIELDS
   sed -n '/^\s*UR_FIELDS\s*([^)]*$/,/)/p; /^\s*UR_FIELDS\s*([^)]*$/,/)/p' 2>/dev/null |
# clean output to get fields only
   sed 's/^\s*UR_FIELDS\s*(\s*//g; s/)//g; s/,/\n/g; /^\s*$/d; s/^\s*//; s/\s\s*/ /g; s/\s\s*$//' |
# sort by name
   sort -k2 -t' ' | uniq >> "$EXISTING_FILE" 

#merge temporary files together and sort them
cat "$EXISTING_FILE" |tail -n+2 |sort -bk2,2 -bk3,3r |
awk '
BEGIN {
   print "# List of UniRec fields"
   print "| Field name | Field data type | Description |"
   print "| ----- | ----- | ----- |"
}
/^..*$/ {

   if (name != $2) {
      type=$1
      name=$2
      desc=$3
   }
   else if (type != $1) {
	printf("Conflicting types (%s, %s) of UniRec field (%s)\n", type, $1, name);
   }
   for (i=4; i<=NF; i++) {
         desc=desc" "$i
   }
   print "| "type" | "name" | "desc" |"
}
END {
   print ""
}' > "$NEW_FILE" 

sed -i "/^\# List of UniRec fields\s*$/r $NEW_FILE
/^\# List of UniRec fields\s*$/,/^$/d;" "$TARGET_FILE"
# clear temporary data
echo "Removing temporary data.."
rm "$EXISTING_FILE" "$NEW_FILE" 2> /dev/null

exit 0;

