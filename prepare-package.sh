#!/bin/bash
#
# Copyright (C) 2018 CESNET
#
# LICENSE TERMS
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name of the Company nor the names of its contributors
#    may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# ALTERNATIVELY, provided that this notice is retained in full, this
# product may be distributed under the terms of the GNU General Public
# License (GPL) version 2 or later, in which case the provisions
# of the GPL apply INSTEAD OF those given above.
#
# This software is provided ``as is'', and any express or implied
# warranties, including, but not limited to, the implied warranties of
# merchantability and fitness for a particular purpose are disclaimed.
# In no event shall the company or contributors be liable for any
# direct, indirect, incidental, special, exemplary, or consequential
# damages (including, but not limited to, procurement of substitute
# goods or services; loss of use, data, or profits; or business
# interruption) however caused and on any theory of liability, whether
# in contract, strict liability, or tort (including negligence or
# otherwise) arising in any way out of the use of this software, even
# if advised of the possibility of such damage.
#


function cont_prompt()
{
   read -p "Continue? [y/n] " -n 1 prompt
   echo ""
   if [ "$prompt" != "y" -a "$prompt" != "Y" ]; then
      exit 1
   fi
}

lastreleased=$(git log -n 1 --grep="released\? \(RPM \)\?package" --format=%h -- ./configure.ac)

if [ -z "$lastreleased" ]; then
   echo "I didn't find the last commit that released new package."
   exit 1
else
   echo "The package was lastly released by $lastreleased."
   git show -q $lastreleased
   echo ""

   echo "I found these changes since the last release:"
   git shortlog --no-merges $lastreleased..HEAD -- ./
   cont_prompt
fi

lastversion=$(git show $lastreleased:./configure.ac | sed -n 's/AC_INIT([^,]*, \?\([^,]*\),.*/\1/p;' |tr -d '[]')
currversion=$(sed -n 's/AC_INIT([^,]*, \?\([^,]*\),.*/\1/p;' configure.ac |tr -d '[]')
name=$(sed -n 's/AC_INIT(\([^,]*\),.*/\1/p;' configure.ac |tr -d '[]')

echo "Version is changing from $lastversion to $currversion."

cont_prompt

changelog="$(date "+%F $name-$currversion"
git log --pretty='subject:%s%nbody:%b' $lastreleased..master -- .| sed -n 's/subject:\([^:]*\):.*/\t* \1:/p; s/\(body:\)\?\s*changelog: \(.*\)/\t\t\2/p;'
echo ""
)"

echo "$changelog" > ChangeLog.tmp
$EDITOR ChangeLog.tmp

cat ChangeLog.tmp

echo "I will update ChangeLog with Your entry..."
cont_prompt

cat ChangeLog >> ChangeLog.tmp
mv ChangeLog.tmp ChangeLog

git log --date=short --no-merges --format="%cd (%an): %s" $lastreleased..HEAD -- ./>> NEWS.tmp
$EDITOR NEWS.tmp

echo "I will Insert this NEWS..."
cont_prompt

cat NEWS >> NEWS.tmp
mv NEWS.tmp NEWS

echo "I will prepare a commit about released package..."
cont_prompt

git commit -a -m "$name: increased version, updated ChangeLog, released RPM package" -e


