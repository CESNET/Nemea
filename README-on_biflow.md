This documents briefly explains "biflow" representation and how it is used in
[ipfixprobe](https://github.com/CESNET/ipfixprobe) and how it should be used in
NEMEA. Biflow is an abbreviation of bidirectional flow (record) which
represents both directions of one connection between two devices in form of one
"message"/flow record.

Interpretation of UniRec record (how to work with UniRec template and UniRec
message):

1. If the UniRec template contains both fields: `BYTES_REV` and `PACKETS_REV`,
   it is considered as biflow template. Otherwise, it is not (i.e., it is
   probably unidirectional flow record). Note: ipfixprobe ALWAYS export both
   fields for biflow.
2. If the UniRec template is not biflow (due to missing fields in 1.), the
   UniRec messages should be paired/aggregated "manually" to get biflow.
3. If a biflow message contains `PACKETS_REV == 0`, it is still a biflow
   record, however, it contains only one direction of the communication. This
   means one of the cases:
    1. the communication was really unidirectional (e.g., broadcast messages, UDP streams),
    2. the communication was bidirectional, but the flow exporter observed only
       one direction of it,
    3. the communication was bidirectional, but the flow exporter was not able
       to pair/aggregated both directions.

3.2 can happen in case of assymetric routing, where packets of different
directions might be routed via different links.
3.3 can happen in case of splitting flow records due to timeouts or limited
flow cache.

In any case, it is highly recommended to do pairing/aggregation of UniRec
message before processing.

