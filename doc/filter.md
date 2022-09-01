---
layout: page
title: Filtering of UniRec messages
menuentry: Filter
public: false
docmenu: true
permalink: /filter/
---
# Introduction

To filter UniRec data, there is an universal NEMEA module called `unirecfilter`
(it can be found at https://github.com/CESNET/Nemea-Modules/tree/master/unirecfilter).

The `unirecfilter` module can work with filter expression given by `-F`
parameter from command line, or with multiple expressions (and multiple output
IFC) given in a text file passed by `-f`.

Filter can contain any UniRec field and data type (except UniRec arrays), and
supports all traditional comparison operators with optimized `IN` operator.

General filter format is: `FIELD OPERATOR VALUE`

UniRec messages that match the given filter are forwarded via output IFC, others are dropped.

`unirecfilter` allows to specify output UniRec template `-O`, so the output can contain only a subset of fields.
It is also possible to specify fields that do not need to be present in the input UniRec template; such fields can be set to default value in the output template (e.g., `-O "ipaddr SRC_IP, ipaddr DST_IP, uint16 SRC_PORT, uint16 DST_PORT, string MESSAGE=\"this_is_message\""`).

`unirecfilter` can be stopped after receiving *N* messages (`-c N`).


# Filter

Filter is a logical expression composed of terms joined together by
logical operators, possibly with the use of brackets (`(`, `)`) and negation (`NOT`). Term is a
triplet `field cmp_operator value`, e.g. `FOO == 1` or `SRC_IP == 10.0.0.1`.

### Keywords

It is possible to use the following *keywords* instead of actual UniRec field
name from input template. The keywords are a shortcut (and simplification) for
compound expressions:

- `host` - stands for `SRC_IP` or `DST_IP`
- `port` - stands for `SRC_PORT` or `DST_PORT`

The semantics can be explain using the following example of filter:

```
host == 192.168.0.0/24
```

which returns true if and only if:

```
SRC_IP == 192.168.0.0/24 or DST_IP == 192.168.0.0/24
```

Note: it means any IP address in the range 192.168.0.0-192.168.0.255 matches.

### Operators

Available comparison operators are:

- `>` greater than
- `<` lesser than
- `>=`, `=>` greater than or equal
- `<=`, `=<` lesser than or equal
- `=`, `==` equal/matches subnet
- `!=`, `<>` not equal
- `=~`, `~=` matches regular expression
- `in`, `IN` In-Array function, see the "In Array" section below

Available logical operators are:

- `||`, `OR` - or
- `&&`, `AND` - and
- `!`, `NOT` - not

### Data types

Almost all data types from unirec are supported:

- `int8` 8bit signed integer
- `int16` 16bit signed integer
- `int32` 32bit signed integer
- `int32` 32bit signed integer
- `int64` 64bit signed integer
- `uint8` 8bit unsigned integer
- `uint16` 16bit unsigned integer
- `uint32` 32bit unsigned integer
- `uint64` 64bit unsigned integer
- `char` a single ASCII character
- `float` single precision floating point number (IEEE 754)
- `double` double precision floating point number (IEEE 754)
- `ipaddr` special type for IPv4/IPv6 addresses, see unirec README
  (note - IPv6 address in a filter loaded from a file has to be
  surrounded by double quotes because of syntax issues)
- `string` variable-length array of (mostly) printable characters,
  surrounded by double quotes
- `bytes` variable-length array of bytes (not expected to be printable
  characters), surrounded by double quotes
- `time` UniRec timestamp, such as `TIME_FIRST`, `TIME_LAST`. The time
  column can be compared with date&time specified in format:
  `YYYY-mm-ddTHH:MM:SS.sss`, where `.sss` represents miliseconds and
  is an optional part (Ex. `2018-01-10T21:17:00`). Note that the
  timestamp should be in UTC timezone.

**Subnets**

UniRec fields of `ipaddr` type (such as `SRC_IP`, `DST_IP`) can be
compared with host IP addresses or with a subnet in the notation
`IP/BITS`, where `BITS` represents a number of leading '1' bits in the
netmask.

Example: `-F "SRC_IP == 10.0.0.0/8"`

Note: `IP` need not to be necessarily a network address (it can be any
IP address) because it is masked during the initiation of the filter
(e.g., `10.1.1.1/8` becomes `10.0.0.0`).

Operator `==` returns true if and only if an `SRC_IP` belong to the
given subnet.

**In Array**

It is possible to abbreviate (and optimize) filter when a field is to be matched
with a set of values.
For example, it is possible to rewrite this:

`DST_PORT == 1 or DST_PORT == 234 or DST_PORT == 123 or DST_PORT == 80 or DST_PORT == 443`

into more readable this:

`DST_PORT in [1, 234, 123, 80, 443]`

Internally, the array (which is specified in brackets `[` and `]`) is parsed, sorted,
and the filter matching is done using binary search, i.e., it is faster
according to a measurement (mainly for longer arrays).

The following UniRec types are currently supported by this In Array feature:
`int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`,
`ipaddr`, `time`, `float`, `double`, and "subnets" (i.e., `ipaddr` with prefix
length such as `192.168.0.0/24`)

### Format

#### Command line

Filter specified on command line with `-F` flag is a single expression
which is evaluated for the output interface. For example: `-F "SRC_PORT == 23"`

#### File

Filter specified in a file provides more flexibility and allows to use more than
one output interface.

Format of the file is `TEMPLATE_1:FILTER_1; ...; TEMPLATE_N:FILTER_N;`
where each semicolon separated item corresponds to one output interface.
Line breaks along the separators as well as within a filter are allowed.
One-line comments starting with `#` can be used.
The semicolon at the end is necessary.

Template can be empty, meaning to use the same template as on input.

Examples:
```
ipaddr SRC_IP,ipaddr DST_IP: SRC_IP == 1.2.0.0/16;
```

```
# ifc0: HTTP(S) traffic
:PROTOCOL == 6 && (SRC_PORT in [80, 443] || DST_PORT in [80, 443]);
# ifc1: DNS traffic
:SRC_PORT == 53 || DST_PORT == 53;
```

To reload the filter while unirecfilter is running, send signal SIGUSR1 (10)
to the process.

## Default values

You can use syntax FIELD=value in the template to specify default
value used if field is not present on the input (f.e. uint32 BAR=1).
Example below.

`./unirecfilter -i u:test_ifc_in,u:test_ifc_out -O "ipaddr SRC_IP, ipaddr DST_IP, uint16 SRC_PORT, uint16 DST_PORT, string MESSAGE=\"this_is_message\""`

## Examples

`./unirecfilter -i IFC_SPEC [-O TMPLT] [-F FLTR]`

`./unirecfilter -i IFC_SPEC [-f FILE]`

Here are some examples of running unirecfilter.

*"Forward only `SRC_IP`, `DST_IP`, `SRC_PORT`, `DST_PORT` fields no matter what is the input template."*

`./unirecfilter -i u:test_ifc_in,u:test_ifc_out -O "ipaddr SRC_IP, ipaddr DST_IP, uint16 SRC_PORT, uint16 DST_PORT"`

*"Forward flow the first 100 records with `SRC_PORT higher than 20."*

`./unirecfilter -i u:test_ifc_in,u:test_ifc_out -c 100 -F "SRC_PORT > 20"`

*"Forward flow records that have `SRC_IP` or `DST_IP` from the given IP prefixes, and `SRC_PORT` or `DST_PORT` are lower than 200 except 80, 53, 123."*

`./unirecfilter -i u:test_ifc_in,u:test_ifc_out -F "host IN [195.113.232.0/24, 147.32.0.0/16, 82.208.0.0/16] and port < 200 and not port in [80, 53, 123]"`

*"Specify output template and forward flow the first 100 records with `SRC_PORT equal to 443 or 53. (Note: filter can be rewritten with IN operator)"*

`./unirecfilter -i u:test_ifc_in,u:test_ifc_out -c 100 -O "ipaddr SRC_IP, ipaddr DST_IP, uint16 DST_PORT, uint16 SRC_PORT" -F "SRC_PORT == 443 || SRC_PORT == 53"`

Below is an example of config file "filter.txt" to be used with the `-f` parameter, everything after `#` is considered as comment:

```
ipaddr DST_IP,ipaddr SRC_IP:SRC_PORT == 443; #port matching number 443
uint16 SRC_PORT:SRC_PORT >= 23 || DST_PORT >= 23; #usage of or
string BAR=not_present:BAR ~= "not_present"; #regex usage
```

You can then use filter file as shown below:

`unirecfilter -i u:test_ifc_in,u:test_ifc_out:timeout=HALF_WAIT,u:test_ifc_in,u:test_ifc_out2:timeout=HALF_WAIT -f "filter.txt"`

Especially notice interface option `:timeout=HALF_WAIT`. It will
enable the module to run even for interfaces that are not listening.
Meaning the module will not hang while waiting for someone to connect.
It will drop the message and move on to sending next one. These
dropped messages will count toward -c option (when this option is
enabled).
