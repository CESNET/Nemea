#!/bin/bash
# Author: Tomas Cejka <cejkat@cesnet.cz>
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
#

if [ $# -eq 0 ]; then
  echo "$0 nfdump_file...

This script expects one or more NFDUMP files.  It replays the flows
and sends them into unirecfilter.  Unirecfilter has 4 output IFCs
that are connected with 4 flowcounters.

As a result, 4 statistics are computed:
  # of flows with src or dst port 25
  # of flows with src or dst port 80
  # of flows with src or dst port 22
  # of flows that don'ŧ have ports 22, 25, or 80
These numbers are summed.
"
  exit 0
fi

# Prepare files and filenames
services="ssh web smtp other"
conffile=`mktemp`

nfifc="u:cejkat2"
urifc=$nfifc
for i in $services; do
  urifc="$urifc,u:$i"
  flcnt="$flcnt $i"
done

cat > $conffile <<KONEC
:SRC_PORT == 25 OR DST_PORT == 25;
:SRC_PORT == 80 OR DST_PORT == 80;
:SRC_PORT == 22 OR DST_PORT == 22;
:SRC_PORT != 22 AND SRC_PORT != 80 AND SRC_PORT != 25 AND DST_PORT != 22 AND DST_PORT != 80 AND DST_PORT != 25;
KONEC

# Start modules to replay given files (arguments) and compute statistics
../modules/nfreader/nfdump_reader -i $nfifc $@ > /dev/null&
../modules/unirecfilter/unirecfilter -i $urifc -f $conffile > /dev/null&
for i in $services; do
  ( ../modules/flowcounter/flowcounter -i "u:$i" | sed -n 's/Flows:\s*\([0-1]*\)/\1/p' > ${i}; )&
  pids="$pids $!"
done

echo "Running, wait a moment please..."

# Wait until children die
for i in $pids; do
  wait $i
done

# Statistics:
awk '{s+=$1; sub(".cnt", "", FILENAME); print FILENAME":", $1;} END{print "Total:", s;}' $flcnt

# Cleanup
rm $flcnt $conffile

