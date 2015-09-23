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
  echo "$0 file.csv
or
$0 generate

This script executes logreplay and logger modules to show how two
Nemea modules communicate.  The script can be run with a CSV file
as an argument or using \"generate\" argument.  \"generate\" tells
the script to create a temporary CSV file that is replayed."
  exit 0
fi

if [ "$1" = "generate" ]; then
  file=`mktemp`
  cat > $file <<KONEC
ipaddr DST_IP,ipaddr SRC_IP,uint16 SRC_PORT,uint16 DST_PORT
192.168.0.1,192.168.0.2,1234,80
192.168.0.2,192.168.0.1,80,1234
1.2.3.4,8.8.8.8,6853,53
KONEC
else
  file="$1"
fi

if [ ! -r "$file" ]; then
  echo "File \"$file\" cannot be opened. Exiting..."
  exit 1
fi

# Start replaying
../modules/logreplay/logreplay -i "u:my_socket" -f "$file"&

../modules/logger/logger -i "u:my_socket" -t `head -1 "$file"`

# Cleanup
if [ "$1" = "generate" ]; then
  rm "$file"
fi

