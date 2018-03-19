---
layout: page
title: Aggregation module
menuentry: AGGREGATION
public: false
permalink: /aggregation/
---

## Description
Universal aggregation module (aggregator) for UniRec records. The main goal of this module is to aggregate receiving UniRec records due to rules specified by user. Rules can be combination of any implemented function with **only one** restriction, that **only one** aggregation function can be assigned to a field. This restriction is a result of module in place processing design.

User has to specify parameters for processing including aggregation key fields and other with aggregation function which will be applied to it. [There](./index.md#aggregation-functions) you can find list currently available functions.

Module work with 4 different timeout types, which describe how records should be handled and where should be send out from module.
- **Active** (Default)
  Every received record is compared with the stored one of the equal aggregation key (if exists). If the TIME_FIRST field value of received record is greater than TIME_FIRST field value + TIMEOUT of stored record, the stored record is sent out from module and replaced with the new one. Otherwise the record fields values are updated due to specified rules. 
- **Passive**
  Every stored record is periodically checked every TIMEOUT second. In case that TIME_LAST field value is TIMEOUT seconds old (untouched) or older, the record is sent out and removed from storage. No action is taken otherwise.
- **Global**
  Each stored records are periodically sent out every TIMEOUT second.
- **Mixed**
  This type presents combination of *Active* and *Passive* timeout types. Both can have different TIMEOUT length value and both values are used separately for given type. When specifying ordered values need to be used in form `-t M:Active,Passive`.

Module receives UniRec and sends UniRec containing fields which take part in aggregation process (TIME_FIRST, TIME_LAST, COUNT, key fields and all with aggregation function assigned), other fields are discarded by module. 

## Interfaces
- Input: One input interface represented by *libtrap*.

  Used UniRec template **always has to** contain fields TIME_FIRST and TIME_LAST.
- Output: One output interface represented by *libtrap*.
  Output UniRec template is generated from module configuration specified by user (TIME_FIRST, TIME_LAST, COUNT are always included).
  
## Aggregation key specification
Key is specified the same way as other aggregation function.
`-k FIELD_NAME` or `--key FIELD_NAME`. Every field needs to be specified with own pair of function and field name (`-k DST_IP -k SRC_IP ...`).

## Aggregation functions
Functions are specified as pair of prefix and field name. Prefix determines the type of aggregation function to be assigned to given field name. Every field definition needs to be specified with own pair of prexix and field name the same way as key above

1. **Sum** 
  Makes total sum of field values. Function is assigned using `-s FIELD_NAME` or `--sum FIELD_NAME`.
2. **Avg**
  Makes average of field values. Every record stores its sum and in postprocessing phase before the record is sent, the average is computed. Function is assigned using `-a FIELD_NAME` or `--avg FIELD_NAME`.
3. **Min**
  Keep minimal value of field across all received records. Function is assigned using `-m FIELD_NAME` or `--min FIELD_NAME`.
4. **Max**
  Keep maximal value of field across all received records. Function is assigned using `-M FIELD_NAME` or `--max FIELD_NAME`.
5. **First**
  Keep the first obtained value of field. Function is assigned using `-f FIELD_NAME` or `--first FIELD_NAME`.
6. **Last**
  Update the field with every new received record. Function is assigned using `-l FIELD_NAME` or `--last FIELD_NAME`.
7. **Bitwise OR**
  Makes bitwise OR of field with every new received record. Function is assigned using `-o FIELD_NAME` or `--or FIELD_NAME`.
8. **Bitwise AND**
  Makes bitwise AND of field with every new received record. Function is assigned using `-n FIELD_NAME` or `--and FIELD_NAME`.

## Input
User defined configuration specifying
*  **key for aggregation** (fields which have to match to aggregate records together with specified operations.)
*  **field and function** (pair of aggregation function prefix and field name)
*  **time window** - Pair of timeout type and length described in [module description](./index.md#description). Available use for aggregation time window length 60 is `-t A:60` of `-t Active:60` for *Active*, `-t G:60` or `-t Global:60` for *Global*, `-t P:60` or `-t Passive:60` for *Passive*, `-t M:60,60` or `-t Mixed:60,60` for *Mixed*.

## Output
New UniRec record containing
* aggregation key fields
* processed fields
* COUNT
* TIME_FIRST, TIME_LAST fields
  
## Use cases

### Overall sum of bytes/packets/flows in given time window
(eg. making graphs)
* Key
  ```
  Nothing
  ```
  or
  ```
  LINK_BIT_FIELD (sums for different links)
  ```
* Aggregation
  ```
  sum:BYTES, sum:PACKETS, min:TIME_FIRST, max:TIME_LAST
  ```
#### Module configuration
```
./aggregator -i u:input,u:output -k LINK_BIT_FIELD -s BYTES -s PACKETS
```
Fields TIME_FIRST and TIME_LAST are always automaticaly handled by module using minimal TIME_FIRST value and maximal TIME_LAST value for given key.

### Blacklist filter output aggregation.

Requests from one source in specific time interval are aggregated to one record, which is in report system converted to IDEA message.
* Key
  ```
  SRC_IP, DST_IP, DST_BLACKLIST
  ```
* Aggregation
  ```
  sum:BYTES, sum:PACKETS, count:FLOWS, min:TIME_FIRST. max:TIME_LAST
  ```
#### Module configuration
```
./aggregator -i u:input,u:output -k SRC_IP -k DST_IP -k DST_BLACKLIST -s BYTES -s PACKETS
```
Fields TIME_FIRST, TIME_LAST, COUNT are always automaticaly handled by module using minimal TIME_FIRST value, maximal TIME_LAST value and count of processed records for given key.

### Clasic flow aggreagation

Flows divided into more records (in case of too short probe active timeout) are combined into one.
* Key
  ```
  SRC_IP, DST_IP, SRC_PORT, DST_PORT, PROTOCOL [, TOS, LINK_BIT_FIELD, DIR_BIT_FIELD]
  ```
* Aggregation
  ```
  sum:BYTES, sum:PACKETS, min:TIME_FIRST, max:TIME_LAST, or:TCP_FLAGS
  ```
### Module configuration
```
./aggregator -i u:input,u:output -k SRC_IP -k DST_IP -k SRC_PORT -k DST_PORT -k PROTOCOL -s BYTES -s PACKETS -o TCP_FLAGS
```
Fields TIME_FIRST and TIME_LAST are always automaticaly handled by module using minimal TIME_FIRST value and maximal TIME_LAST value for given key.

### DNS amplification attack detection 

**Functions mentioned there are not present in current solution.** In combination with input filter on SRC_Port=53 and ouptut filter with tresholds.
* Key
  ```
  SRC_IP, DST_IP
  ```
* Aggregation
  ```
  sum:BYTES, sum:PACKETS, avg:BYTES_AVG, stdev:BYTES
  ```
### Module configuration
  ```
  ./aggregator -i u:input,u:output -k SRC_IP -k DST_IP -s BYTES -s PACKETS -a BYTES_AVG
  ```
Current module implementation cannot apply 2 different aggregation functions on the same record field. The field BYTES_AVG has to be part of input record to be used like this. Function standard deviation (stdev) is not implemented in module (*Featured*).