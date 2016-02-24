#!/bin/bash

# Author: Jiri Havranek <havraji6@fit.cvut.cz>
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


# The purpose of this script is to show how to execute nemea module
# flow_meter and send it's output to another module (logger in this
# case). flow_meter is able to capture from interface (-I option) or
# file (-r option). In case of capture from interface it needs to be
# executed with root permission otherwise it will not be able to run.
# If you want to capture specific number of packets you can use -c
# option.

# Check if interface is specified.
if [ "$1" = "" ]; then
   echo "Specify the network interface."
   echo "Usage: $0 interface-name"
   exit 2
fi

if [ "$EUID" != 0 ]; then
   echo "You should run this script as root."
   exit 1
fi

flow_meter="../modules/flow_meter/flow_meter"
logger="../modules/logger/logger"

# Check if modules are compiled.
if [ ! -e "$flow_meter" ]; then
   echo "$flow_meter does not exist. Compile flow_meter first."
   exit 3
fi

if [ ! -e "$logger" ]; then
   echo "$logger does not exist. Compile logger first."
   exit 3
fi

# Start capture from given interface. Quit after 10 packets are captured.
./"$flow_meter" -i u:my_socket -I "$1" -c 10 >/dev/null &

# Start logger and quit when flow_meter exits.
./"$logger" -i u:my_socket -t

