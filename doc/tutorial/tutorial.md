# 1. CSV files

See files:

    less virtual-sensor.csv

    less zwave-sensor.csv

## Replay CSV files

    /usr/bin/nemea/logreplay -i f:outputfile.trapcap -f zwave-sensor.csv

## Translate UniRec into CSV

Logger will wait for data at `mysocket` IFC and translate it to CSV

    /usr/bin/nemea/logger -i u:mysocket -t

We can use `traffic_repeater` to replay UniRec stored in the file:

    /usr/bin/nemea/traffic_repeater -i f:outputfile.trapcap,u:mysocket:buffer=off

# 2. Generate own data

Have a look into `zwave-generator.py`:

    less zwave-generator.py

Generate data and show it using `logger` (ideally in 2 terminals):

    ./zwave-generator.py
    /usr/bin/nemea/logger -i u:mysocket -t


# 3. Store data into binary UniRec file(s)

`:w` rewrite

`:a` append (creates new file with suffix, e.g. data.trapcap.0, data.trapcap.1)

`:size=` in MB

`:time=` in minutes

    /usr/bin/nemea/traffic_repeater -i u:mysocket,f:soubor:a

    /usr/bin/nemea/traffic_repeater -i u:mysocket,f:soubor:time=2

Result:

    $ ls -lh soubor*
    -rw-rw-r--. 1 tomas tomas 929 26. Oct 23.38 soubor.201710262336
    -rw-rw-r--. 1 tomas tomas  47 26. Oct 23.38 soubor.201710262338
    $

