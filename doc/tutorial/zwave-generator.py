#!/usr/bin/env python


import pytrap
import time
import signal
import sys

def signal_h(signal, f):
    global trap
    trap.terminate()

trap = pytrap.TrapCtx()
fmt = "uint32 GW_ID,int32 SOAFCount,int32 TIME"
tmplt = pytrap.UnirecTemplate(fmt)
tmplt.createMessage()

tmplt.GW_ID = 101

trap.init(["-i", "u:mysocket"], 0, 1)
trap.setDataFmt(0, pytrap.FMT_UNIREC, fmt)

signal.signal(signal.SIGINT, signal_h)

i = 0

while True:
    i += 1
    tmplt.SOAFCount = i
    tmplt.TIME = i * 100
    trap.send(tmplt.getData())
    time.sleep(2)



