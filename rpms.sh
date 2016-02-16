#!/bin/bash
#
# Copyright (C) 2015 CESNET
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

#set -x

if [ -x "`which dnf`" ]; then
   export pkginst=dnf
elif [ -x "`which yum`" ]; then
   export pkginst=yum
else
   echo "Unsupported package manager (dnf/yum)" >&2
   exit 1
fi

echo "Warning: You must have 'rpmbuild' in order to generate RPM package."
echo "If you want to abort this script, press CTRL+C (i.e. send SIGINT signal)"
sleep 5

if [ "x`whoami`" != xroot ]; then
   echo "Run this script as root, since it must install RPM packages continuously"
   exit 1
fi

read -p "Enter the name of user who will compile packages: " chuser

read -p "Are You sure You want to continue? [yn]" -n1 ans

if [ "x$ans" != xy ]; then
   exit 0
fi

echo "Remove previously installed packages"
$pkginst remove -q -y libtrap\* unirec\* nemea\*

export topdir=$PWD
export chuser

(
   cd nemea-framework
   (
      cd libtrap
      su $chuser -p -c "$topdir/generate-rpm.sh"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   (
      cd common
      su $chuser -p -c "$topdir/generate-rpm.sh"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   (
      cd unirec
      su $chuser -p -c "$topdir/generate-rpm.sh"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   su $chuser -p -c "./bootstrap.sh >/dev/null 2>/dev/null&& ./configure -q"
   
   (
      cd python
      su $chuser -p -c "make -j4 && make rpm"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
   (
      cd pycommon
      su $chuser -p -c "make -j4 && make rpm"
      $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
   )
)
(
   cd modules
   su $chuser -p -c "$topdir/generate-rpm.sh"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)
(
   cd detectors
   su $chuser -p -c "$topdir/generate-rpm.sh"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)
(
   cd nemea-supervisor
   su $chuser -p -c "$topdir/generate-rpm.sh"
   $pkginst install -y -q $(find \( -name '*noarch.rpm' -o -name '*64.rpm' \))
)

su $chuser -p -c "$topdir/bootstrap.sh >/dev/null 2>/dev/null&& $topdir/configure -q"
mkdir -p "`pwd`/RPMBUILD"
rpmbuild  -ba nemea.spec --define "_topdir `pwd`/RPMBUILD"
mkdir -p "`pwd`/rpms"
find -name *.rpm -not -path "./rpms/*" -exec mv {} rpms/ \;

