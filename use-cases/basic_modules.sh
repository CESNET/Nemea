#!/bin/bash
# Author: Marek Svepes <svepemar@fit.cvut.cz>
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

if [ $# -eq 0 ] || [ $# -gt 1 ]; then
  printf " Usage:
  \t\"$0 netflow_input_file\"
  \tor
  \t\"$0 default\" default input file with 6000 flows is used

 This script shows connection of the basic Nemea modules
 (nfreader, merger, logger, logreplay and flowcounter). Three nfreader
 modules read netflow data from input file (specified by program argument)
 and send them in unirec format to merger module which sends incoming
 data from all input interfaces to one output interface. The data from merger
 are stored into csv file by logger module. The csv file can be read by logreplay
 module which sends them again in unirec format to flowcounter module.
 Result of this module is number of received flows (it should be
 number of flows from nfreader input file x 3).

 Step 1:
                     ----------
  netflow_file ---> | nfreader | ----------
                     ----------           |
                                          v
                     ----------        --------        --------
  netflow_file ---> | nfreader | ---> | merger | ---> | logger | ---> file.csv
                     ----------        --------        --------
                                          ^
                     ----------           |
  netflow_file ---> | nfreader | ----------
                     ----------

 Step 2:
                 -----------        -------------
  file.csv ---> | logreplay | ---> | flowcounter | ---> Result (number of flows)
                 -----------        -------------\n"

  exit 0
fi

# INPUT_FILE - Input file for nfreader modules (netflow data)
if [ "$1" = "default" ]; then
  INPUT_FILE="./nfcap_6000_gener_flows.dat"
else
  INPUT_FILE="$1"
fi

if [ ! -r "$INPUT_FILE" ]; then
  echo "Input file \"$INPUT_FILE\" cannot be opened. Exiting..."
  exit 1
fi

# Logger output file (csv format)
LOGGER_OUTPUT_FILE="./logger_test_out"

printf ">>> Starting 3 nfreaders, merger and logger...\n>Nfreaders sent:\n"
../modules/nfreader/nfdump_reader -i u:nfr1_test_out $INPUT_FILE &
../modules/nfreader/nfdump_reader -i u:nfr2_test_out $INPUT_FILE &
../modules/nfreader/nfdump_reader -i u:nfr3_test_out $INPUT_FILE &
../modules/merger/merger -n 3 -i u:nfr1_test_out,u:nfr2_test_out,u:nfr3_test_out,u:merger_test_out &
../modules/logger/logger -i u:merger_test_out -w $LOGGER_OUTPUT_FILE -t

printf ">>> Starting logreplay and flowcounter...\n>Flowcounter received:\n"
../modules/logreplay/logreplay -i u:logrep_test_out -f $LOGGER_OUTPUT_FILE &
../modules/flowcounter/flowcounter -i u:logrep_test_out

# Cleanup
rm -f $LOGGER_OUTPUT_FILE
