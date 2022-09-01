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

function prompt()
{
   read -p "$1" -n 1 p
   echo ""
   if [ "$p" != "y" -a "$p" != "Y" ]; then
      return 1
   else
      return 0
   fi
}

function cont_prompt()
{
   if prompt "Continue? [y/n] "; then
      return 0
   else
      exit 1
   fi
}


# Look up commit of last releasing
lastreleased=$(git log -n 1 --grep="released\? \(RPM \)\?package" --format=%h -- ./configure.ac)

if [ -z "$lastreleased" ]; then
   echo "I didn't find the last commit that released new package."
   exit 1
else
   echo "The package was lastly released by $lastreleased."
   git show -q $lastreleased
   echo ""

   echo "I found these changes since the last release:"
   git shortlog $lastreleased..HEAD -- ./
   cont_prompt
fi

# Look up version of the latest package and the current version
lastversion=$(git show $lastreleased:./configure.ac | sed -n 's/AC_INIT([^,]*, \?\([^,]*\),.*/\1/p;' |tr -d '[]')
currversion=$(sed -n 's/AC_INIT([^,]*, \?\([^,]*\),.*/\1/p;' configure.ac |tr -d '[]')
name=$(sed -n 's/AC_INIT(\([^,]*\),.*/\1/p;' configure.ac |tr -d '[]')

echo "Version is changing from $lastversion to $currversion."

if [ "$lastversion" = "$currversion" ]; then
   if prompt "Should I increase version? [y/n] "; then
      echo ""
      read -p "Write a new version in x.y.z format, please: " currversion
      sed -i '/AC_INIT/ s/'"$lastversion"'/'"$currversion"'/;' configure.ac
      echo "Version was replaced."
   fi
fi

cont_prompt

echo "Analysing Makefiles..."
for makefile in $(grep -Rl --include=*am -e '-version-info [0-9]\+:[0-9]\+:[0-9]\+' .); do
   echo -e "\t$makefile"
   lastlibvers="$(git show $lastreleased:$makefile |
                  sed -n 's/^\(.*\)_la_LDFLAGS\s*=.*-version-info \([0-9]\+\):\([0-9]\+\):\([0-9]\+\).*/\1:\2:\3:\4/pg')"

   currlibvers="$(sed -n 's/^\(.*\)_la_LDFLAGS\s*=.*-version-info \([0-9]\+\):\([0-9]\+\):\([0-9]\+\).*/\1:\2:\3:\4/pg' $makefile)"

   tmplist=$(mktemp)
   paste -d: <(echo "$lastlibvers" | sort) <(echo "$currlibvers" | sort) > $tmplist
   while read -u 3 line; do
      IFS=":" read -r -a cols <<< "$line"
      if [ "${cols[0]}" = "${cols[4]}" -a "${cols[1]}" = "${cols[5]}" -a \
           "${cols[2]}" = "${cols[6]}" -a "${cols[3]}" = "${cols[7]}" ]; then

          if prompt "Do You want to increase version of ${cols[0]}? [y/n]"; then
            current="${cols[1]}"
            release="${cols[2]}"
            age="${cols[3]}"
            echo "FYI: Old version was: $current:$release:$age"
            echo ""
            if prompt "2. Was the library source code changed at all since the last update? [y/n] "; then
               ((release++))
            fi
            if prompt "3. Was any interface added, removed, or changed since the last update? [y/n] "; then
               ((current++))
               revision=0
            fi
            if prompt "4. Was any interface added since the last public release? [y/n] "; then
               ((age++))
            fi
            if prompt "5. Was any interfaces removed or changed since the last public release (INcompatibility)? [y/n] "; then
               age=0
            fi
            echo "New version for ${cols[0]} is $current:$release:$age."
            echo ""
            if prompt "Should I update $makefile? [y/n] "; then
               sed -i "s/\(${cols[0]}_la_LDFLAGS.*-version-info \)\([0-9]\+:[0-9]\+:[0-9]\+\)\(.*\))/\1$current:$release:$age\3/" $makefile
            fi
          fi
      fi
   done 3< $tmplist
   rm $tmplist
done

changelog="$(date "+%F $name-$currversion"
git log --pretty='subject:%s%nbody:%b' $lastreleased..master -- .| sed -n 's/subject:\([^:]*\):.*/\t* \1:/p; s/\(body:\)\?\s*changelog: \(.*\)/\t\t\2/p;'
echo ""
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
echo "" >> NEWS.tmp
$EDITOR NEWS.tmp

echo "I will Insert this NEWS..."
cont_prompt

cat NEWS >> NEWS.tmp
mv NEWS.tmp NEWS

echo "I will prepare a commit about released package..."
cont_prompt

git commit -a -m "$name: increased version, updated ChangeLog, released RPM package" -e

echo "I will build the new RPM to get source package (SRPM)"
if [ "$name" = ipfixprobe ]; then
# ipfixprobe has no bootstrap.sh
autoreconf -i &&./configure -q --enable-coprrpm && make rpm
else
./bootstrap.sh &&./configure -q && make rpm
fi

echo "I will upload the new RPM to copr"
cont_prompt

copr build @CESNET/NEMEA RPMBUILD/SRPMS/$name-$currversion-1.src.rpm

echo "Last commit:"
git log -1

if prompt "Push to git origin? [y/n] "; then
   git push
fi

