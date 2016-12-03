#!/bin/bash

DEBUG=1
EXISTING_FILE="`mktemp`"
NEW_FILE="`mktemp`"
TARGET_FILE=unirec_fields.md

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
   if (NR == 1) {
      type=$1;
      iden=$2;
   }
   if ((iden == $2) && (type != $1)) {
      printf("Conflicting types (%s, %s) of UniRec field (%s)\n", type, $1, iden);
      exit 1;
   }
   type=$1;
   if (NR == 1) {
      type=$1;
      iden=$2;
   }
   if ((iden == $2) && (type != $1)) {
      printf("Conflicting types (%s, %s) of UniRec field (%s)\n", type, $1, iden);
  }
   type=$1;
   iden=$2;
   print $1, $2;
}' | sort -k2 >"$NEW_FILE"
#merge temporary files together and sort them
cat "$EXISTING_FILE" "$NEW_FILE" |tail -n+2  |sort -buk2,2 >/dev/stderr
exit 1;
