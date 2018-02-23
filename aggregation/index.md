---
layout: page
title: Nemea aggregation module
menuentry: AGGREGATION
public: false
permalink: /aggregation/
---

## Featured aggregation functions
1. Sum 
2. Count 
3. Avg 
4. Min
5. Max
6. First
7. Last 
8. Bitwise OR
9. Bitwise AND

## Input
User defined configuration specifying
*  **key for aggregation** (what fields must match to apply any aggregation function)
*  **field and function** (combination which tells what how aggreagate)
*  **time window** - sliding window checked for each record independently

## Output
New UniRec record containing
* aggregation key fields
* processed fields
* count
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
  sum:BYTES, sum:PACKETS, sum:FLOWS, min:TIME_FIRST, max:TIME_LAST
  ```

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