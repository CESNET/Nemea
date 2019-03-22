---
layout: page
title: Reporting Modules and Alert Filtering
menuentry: Reporters
public: false
docmenu: true
permalink: /reporting/
---


# Introduction

Contrary to the first version of reporting modules, which were configured
separately using parameters from CLI, it became needed to create a central
configuration that can be shared with all reporting modules.

Reporting modules (reporters) are currently python-written modules that import `report2idea` from
the `python-nemea-pycommon` (it is a part of [NEMEA-framework](https://github.com/CESNET/NEMEA-framework)).  The aim of each module is to
convert output of related detection module into JSON-based [IDEA format](https://idea.cesnet.cz/en/index).

The following figure shows a simple example of deployed detection modules and their reporters.  The central configuration
is a file written in Yaml format.  The configuration file specifies what to do with received IDEA messages.

![]({{ "/images/reporter-config.png" | prepend: site.baseurl }} "Connection and configuration of reporting modules.")

## Simple examples

Short example can be found in the [NEMEA-modules repository](https://github.com/CESNET/Nemea-Modules/blob/master/report2idea/config.yml.example)

The second and more complex example is placed in the [pycommon directory](https://github.com/CESNET/Nemea-Framework/blob/master/pycommon/reporter_config/example.yaml)

# Specification

Configuration consists of several sections: *namespace*, *smtp connections*, *address groups*, *custom actions*, and list of *rules*.

## Namespace

Usually, all reporters share the common prefix of their name that identify deployed system.
This prefix should be set by `namespace` key.
For example, all reporters on CESNET collector with NEMEA system share the namespace `cz.cesnet.nemea`.

Automatically, each reporter appends its unique name.
For example, `vportscan2idea.py` reporter creates name: `cz.cesnet.nemea.vportscan`

Note: it is set in the source code of the module, e.g., `MODULE_NAME = "vportscan"` in [source](https://github.com/CESNET/Nemea-Modules/blob/master/report2idea/vportscan/vportscan2idea.py).

Note2: if you want to override this behavior, reporters still support `-n` option to provide a complete name.

## SMTP connections

`smtp_connections`

This section contains a list of configured SMTP servers that can be referenced from `email` action (see below in Custom actions).

Each connection can contain the following parameters:

- id - identifier of an SMTP connection
- server - (optional) Hostname of SMTP server, `localhost` is default
- port - (optional) Port of SMTP server, `25` is default
- key - (optional) Path to key file for TLS
- chain - (optional) Path to certificate (chain) file for TLS
- forceSSL - (optional) Boolean value to force SSL connection from the beginning, `False` is default
- startTLS - (optional) Boolean value to perform `STARTTLS`, `False` is default
- user - (optional) User name for SMTP server requiring authentication
- pass - (optional) Password for SMTP server requiring authentication

Warning: Username and password (for authentication) are passed in plain-text so
be cautious to use this.

Note: If `forceSSL` is set to `True`, `startTLS` has no effect.

Example:

```
smtp_connections:
  - id: 'mylocalserver'
    server: 127.0.0.1
    port: 25
    user: ''
    pass: ''
    key: ''
    chain: ''
    force_ssl: False
    start_tls: False
```

## Address groups

`addressgroups`

This section contains definition of lists of addresses either specified directly "in-text" or loaded from a file.
Since the lists have their identifiers - names, it is possible to refer the list of addresses in conditions of *rules*.

The `addressgroups` section is optional.

## Custom actions

`custom_actions`

The whole configuration stands upon lists of rules (described in the following section) that specify what to do with each reported event - IDEA message.
There are several types of actions that can be performed.
Most of action types require some parameters so the action must be "defined" in the Custom actions section to be referred from a rule.

To define an action in `custom_actions` list, unique name (id) and type of the action must be defined.
Some action types can require additional arguments.

The `custom_actions` section is optional.

Each custom action can be one of the following action types:

### warden

Send the message to Warden server.

Note: to use this action, the reporter module must be started with `--warden=` parameter that specifies path to Warden client config file.

Action arguments:

- url - URL of a warden server (this does not work right now)

### file

Store message into file or into files in directory.

Action arguments:

- path - path to a log file; if a directory is given, create a separate files with unique name for each message; otherwise if a regular file is given, append the message to the given file.
- temp\_path - temporary write the file into temp\_path directory; when the content is written, move the file into path automatically (this is useful for utilities that wait for the new files and need a complete content before opening the file, such as `warden_filer`)


### email

Send message via SMTP.

This action sends each alert as an e-mail message.
Be careful with this action, it is not recommended for frequent alerts, it may
generate lots of e-mails since there is currently no implemented aggregation in
this action.

Action arguments:

- `smtp_connection` - reference to predefined SMTP server (see SMTP connections section above)
- `to` - Destination e-mail address, multiple addresses might be specified, separated by comma (`,`).
- `subject` - Subject of the messages that is used as a [jinja2](http://jinja.pocoo.org/docs/2.10/) template; an IDEA message is passed as `idea` object; Besides `idea`, the following variables can be used in the `subject`:
    * `category` a comma separated list of Categories or "N/A",
    * `node` a name of last `Node` (in IDEA message),
    * `src_ip` an IP address and "(...)" when there are more, "N/A" when there is no IP,
    * `tgt_ip` an IP address and "(...)" when there are more, "N/A" when there is no IP,
    * `byte_rate` rate in `Mb/s` or empty string when it's not computable,
    * `flow_rate`  rate in `flow/s` or empty string when it's not computable.
- `template` - path to the file with body of the message that is used as a [jinja2](http://jinja.pocoo.org/docs/2.10/) template; an IDEA message is passed as `idea` object
- `from`  - (optional) Source e-mail address.

Example `template` file in [jinja2](http://jinja.pocoo.org/docs/2.10/):

```
{% raw %}
NEMEA system has detected a possible security event.

 Description:  {{ idea.Description }}
 Category: {{ idea.Category | join(", ") }}
 Source(s) of Trouble: {% for s in idea.Source %}{% if s.IP4 %}{{ s.IP4 | join(", ") }}{% endif %} {% if s.IP6 %}{{ s.IP6 | join(", ") }}{% endif %}{% endfor %}
 Victim(s):  {% for t in idea.Target %}{% if t.IP4 %}{{ t.IP4 | join(", ") }}{% endif %} {% if t.IP6 %}{{ t.IP6 | join(", ") }}{% endif %}{% endfor %}
 Note:      {{ idea.Note }}
 Event Time: {{ idea.EventTime }}
 Cease Time: {{ idea.CeaseTime }}
 Detect Time: {{ idea.DetectTime }}

Raw message:

{{ idea }}
{% endraw %}
```

Similarly, `subject` can contain similar [jinja2](http://jinja.pocoo.org/docs/2.10/) constructs like in the body template example.

### mongo

Store message into MongoDB.

Action arguments:

- host
- port
- db name
- collection name
- user (optional)
- password (optional)

### mark

Add label into alert / modify IDEA message.

The modification of the message by **mark** action is valid ONLY for the subsequent actions of the list of **actions**/**elseactions** where the mark action is used.
That means the modification is not global - for more than one rule.

Action arguments:

- path - Path in JSON
- value - string

Note: `path_set(msg, path, value)` from Mentat is used

### trap

Send the message via output TRAP IFC.

Note: to use this action, the reporter module must be started with `--trap` and correct `IFC_SPEC` with one input and one output IFC must be passed via `-i`.

Action arguments: No arguments.

### drop

Implicitly defined action, it can be used without any definition in `custom_actions` section. Moreover, it MUST NOT be defined in `custom_actions`.

## Rules

`rules`

This section consists of rules - list of `rule` ordered by id which is integer (the order is significant). The list of rules is evaluated by all modules from the first rule to the last one.

The `rules` section is mandatory and it must contain at least one `rule`.

Each `rule` is composed of **condition**, **actions**, **elseactions**.

All IDEA messages will be matched with filtering condition consisting of unary and binary operations, constants and JSON paths that are supported by Mentat filter (MFilter).
When the IDEA message meets the condition, the specified list of actions is performed.
Otherwise, the list of elseactions is performed.
Both actions and elseactions are optional.

To create condition representing tautology (always true) resp. contradiction (always false), simple use `True` resp. `False`.

**actions** / **elseactions**

Each rule can specify list of actions in the actions or elseactions lists.
An action can be either of an implicitly defined action (see below) or it can be defined in a separate list - `custom_actions`.

The `custom_actions` is a list of action identified by id key which can be a string - this identifier is used to reference an action from rule.
The actions and elseactions lists in rule are used to reference an action, which can be an implicitly defined action or an action defined in `custom_actions`.


# Example configuration

## Minimal Example

This prints all incoming alerts to `stdout`:

```
{% raw %}
---
namespace: com.example.nemea
custom_actions:
  - id: file
    file:
      path: /dev/stdout
rules:
  - id: 1
    condition: true
    actions:
      - file
{% endraw %}
```

## Tips and Troubleshooting

Reporters are able to parse and check configuration file without actually running.
There is `--dry` option that can be used to do it.

### Example (malformed yaml):

`$ cat malformedyaml.yaml`

```
{% raw %}
 a b: abcdef
1: aaa
{% endraw %}
```

`$ idea2idea.py --dry -c malformedyaml.yaml`

```
{% raw %}
Yaml file could not be parsed: expected '<document start>', but found '<block mapping start>'
  in "<string>", line 2, column 1:
    1: aaa
    ^
error: Parsing configuration file failed.
{% endraw %}
```

### Example 2 (working example):

`$ cat multiple_actions.yaml`

```
{% raw %}
---
namespace: com.example.nemea
custom_actions:
  - id: mark
    mark:
      path: Test
      value: true
  - id: mongo
    mongo:
      db: rc_test
      collection: alerts
  - id: file
    file:
      path: testfile.idea

addressgroups:
  - id: whitelist
    list:
    - 8.8.8.8

rules:
  - id: 1
    condition: Source.IP4 in whitelist
    actions:
    - mark
    - file
    - mongo
{% endraw %}
```

`$ idea2idea.py --dry -c multiple_actions.yaml`

```
{% raw %}
Namespace: com.example.nemea
----------------
Smtp connections:

----------------
Address Groups:
ID: 'whitelist' IPs: [IP4('8.8.8.8')]
----------------
Custom Actions:
drop:
	DROP

mongo:
	Host: localhost, Port: 27017, DB: rc_test, Collection: alerts

file:
	Path: testfile.idea

mark:
	Path: Test, Value: True

----------------
Rules:
1: Source.IP4 in whitelist
	Actions: mark (mark), file (file), mongo (mongo)
{% endraw %}
```

## Other Links

Yaml configuration example: [pycommon/reporter_config/example.yaml](https://github.com/CESNET/Nemea-Framework/blob/master/pycommon/reporter_config/example.yaml)

E-mail body template: [pycommon/reporter_config/default.html](https://github.com/CESNET/Nemea-Framework/blob/master/pycommon/reporter_config/default.html)

# Use-cases

## Use-case 1 (Mongo + Warden + whitelists + TRAP ifc)

- if IP is on any whitelist add “_CESNET.Whitelisted = true” to record before storing it to MongoDB
- always store all alerts into MongoDB
- alerts from detector1, Category=ASDF and Target in [ list_of_networks ] -> pass to output IFC (to email_sender)
- don't send alerts from detector2 with Category=XYZ and with Source IP in whitelist2 to Warden -> drop
- don't send alerts with Source IP in main_whitelist to Warden (from any detector) -> drop
- alerts from detector1, detector2 -> Warden
- alerts from detector3 -> Warden with Test category



Example in YAML:


```
namespace: com.example.nemea
custom_actions:
- id: warden1
  warden:
	url: https://warden1
- id: mongo1
  host: localhost
  port: 1234
  db: abcd
  collection: alerts
- id: marktest
  mark:
	path: category
	value: test
- id: markwhitelisted
  mark:
	path: _CESNET.Whitelisted
	value: 'True'
addressgroups:
- id: main_whitelist
  file: "/var/lib/whitelist1"
- id: whitelist2
  list:
  - 1.1.0.0/24
  - 1.2.3.4
rules:
- id: 1
  condition: Source.IPv4 in main_whitelist or Target.IPv4 in main_whitelist
  actions:
  - addwhitelisted:q
  - mongo1
  elseactions:
  - mongo1
- id: 2
  condition: Node.SW == ‘detector1’ and Category == ASDF and Target.IPv4 in whitelist2
  actions:
  - trap
- id: 3
  condition: Source.IPv4 == main_whitelist
  actions:
  - drop
- id: 4
  condition: Node.SW == 'detector2' and Category == XYZ and Source.IPv4 in whitelist2
  actions:
  - drop
- id: 5
  condition: Node.SW in [‘detector1’, ‘detector2’]
  actions:
  - warden1
  - drop
- id: 6
  condition: Node.SW == detector3
  actions:
  - addtest
  - warden1
  - drop
```

# Appendix 1: Mentat filter

(developed by Jan Mach)

Lexical analyzer accepts the following keywords, i.e. operators:

```
reserved = {
'or': 	'OP_OR',
'xor':	'OP_XOR',
'and':	'OP_AND',
'not':	'OP_NOT',
'exists': 'OP_EXISTS',

'like': 'OP_LIKE',
'in':   'OP_IN',
'is':   'OP_IS',
'eq':   'OP_EQ',
'ne':   'OP_NE',
'gt':   'OP_GT',
'ge':   'OP_GE',
'lt':   'OP_LT',
'le':   'OP_LE',

'OR': 	'OP_OR',
'XOR':	'OP_XOR',
'AND':	'OP_AND',
'NOT':	'OP_NOT',
'EXISTS': 'OP_EXISTS',

'LIKE': 'OP_LIKE',
'IN':   'OP_IN',
'IS':   'OP_IS',
'EQ':   'OP_EQ',
'NE':   'OP_NE',
'GT':   'OP_GT',
'GE':   'OP_GE',
'LT':   'OP_LT',
'LE':   'OP_LE',

'||': 'OP_OR_P',
'^^': 'OP_XOR_P',
'&&': 'OP_AND_P',
'!':  'OP_NOT',
'?':  'OP_EXISTS',

'=~': 'OP_LIKE',
'~~': 'OP_IN',
'==': 'OP_EQ',
'!=': 'OP_NE',
'<>': 'OP_NE',
'>':  'OP_GT',
'>=': 'OP_GE',
'<':  'OP_LT',
'<=': 'OP_LE',

'+': 'OP_PLUS',
'-': 'OP_MINUS',
'*': 'OP_TIMES',
'/': 'OP_DIVIDE',
'%': 'OP_MODULO'
}
```

Therefore, the Mentat filter accepts e.g. the following data:

```
1 + 1 - 1 * 1 % 1
OR 2 or 2 || 2
XOR 3 xor 3 ^^ 3
AND 4 and 4 && 4
NOT 5 not 5 ! 5
EXISTS 6 exists 4 ? 6
LIKE 7 like 7 =~ 7
IN 8 in 8 ~~ 8
IS 9 is 9
EQ 10 eq 10 == 10
NE 11 ne 11 <> 11 != 11
GT 12 gt 12 > 12
GE 13 ge 13 >= 13
LT 14 lt 14 < 14
LE 15 le 15 <= 15
(127.0.0.1 eq ::1 eq 2001:afdc::58 eq Source.Node eq "Value 525.89:X><" eq 'Value 525.89:X><')
[1, 2, 3 , 4]
```

{% comment %}

# Appendix 2: Draft of data model in Yang

It is planned to migrate to sysrepo and NETCONF in the future version of the NEMEA collector and this configuration will be migrated as well.
Therefore, we provide a configuration data model in Yang. Even though the current implementation (and representation in Yaml) might not fit to this model for 100%,
it is going to be adapted in the future.

TODO check if it is consistent and up-to-date

```
module "reporting-filter" {
    namespace "urn:cesnet:tmc:nemea-filter:1.0";
    prefix "nemea";
    organization
   	 "CESNET, z.s.p.o.";
    contact
   	 "cejkat@cesnet.cz";
    description
   	 "Module specifying configuration of NEMEA reporters.";
    revision "2017-02-28" {
   	 description
   		 "Configuration of NEMEA reporters.";
    }

    container "reporting-filter" {
   	 list "custom_actions" {
   		 key "id";
   		 leaf "id" {
   			 type "string";
   		 }
   		 choice action-type {
   			 case "warden" {
   				 container "warden" {
   					 leaf "url" {
   						 type "string";
   					 }
   				 }
   			 }
   			 case "file" {
   				 container "file" {
   					 leaf "path" {
   						 type "string";
   						 description "Path to file. If directory is given, create a separate file with unique name for each message, otherwise, append the message to the given file.";
   					 }
   				 }
   			 }
   			 case "email" {
   				 container "email" {
   					 leaf "to" {
   						 type "string";
   						 description "Email address";
   					 }
   					 leaf "subject" {
   						 type "string";
   						 description "Subject of the email";
   					 }
   				 }
   			 }
   			 case "mongo" {
   				 container "mongo" {
   					 leaf "host" {
   						 type "string";
   					 }
   					 leaf "port" {
   						 type "uint16";
   					 }
   					 leaf "db" {
   						 type "string";
   					 }
   					 leaf "collection" {
   						 type "string";
   					 }
   				 }
   			 }
   			 case "mark" {
   				 container "mark" {
   					 leaf "path" {
   						 type "string";
   						 description "Path to key in JSON.";
   					 }
   					 leaf "value" {
   						 type "string";
   						 description "TODO - do we need any other data type of values?";
   					 }
   				 }
   			 }
   			 case "trap" {
   				 leaf "trap" {
   					 type "empty";
   					 description "Send the message via TRAP interface.";
   				 }
   			 }
   		 }
   	 }

   	 list "rules" {
   		 key "id";
   		 leaf "id" {
   			 type "uint32";
   			 description "identifier of rule, it is used for ordering";
   		 }
   		 leaf "condition" {
   			 type "string";
   			 description "Filtering condition";
   		 }
   		 list "actions" {
   			 key "id";
   			 leaf "id" {
   				 type "uint32";
   			 }
   			 choice action-type {
   				 case "drop" {
   					 leaf "drop" {
   						 type "empty";
   					 }
   				 }
   				 case "custom" {
   					 leaf-list "action" {
   						 type leafref {
   							path "/reporting-filter/custom_actions/id";
   						 }
   					 }
   				 }
   			 }
   		 }
   		 list "elseactions" {
   			 key "id";
   			 leaf "id" {
   				 type "uint32";
   			 }
   			 choice action-type {
   				 case "drop" {
   					 leaf "drop" {
   						 type "empty";
   					 }
   				 }
   				 case "custom" {
   					 leaf-list "action" {
   						 type leafref {
   							 path "/reporting-filter/custom_actions/id";
   						 }
   					 }
   				 }
   			 }
   		 }
   	 }
    }
}
```

{% endcomment %}


