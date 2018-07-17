---
layout: page
title: Connection to Warden system
menuentry: Warden
public: false
docmenu: true
permalink: /doc/warden/
---

Warden ([warden.cesnet.cz](https://warden.cesnet.cz//en/index)) is a system for
sharing detected security events in form of low-level [IDEA](idea.cesnet.cz)
messages - alerts.

NEMEA system is ready to send detected events into Warden and help the community in a potential collaborative defense this way.

At first, Warden client must be registered properly on the Warden server.  See
[guide](https://warden.cesnet.cz/en/participation) for detailed information to
obtain a valid certificate.

There are two main principles of connection to Warden, both of them are related to the configuration of NEMEA Reporting modules:

## Reporters - Files - Warden Filer

The simplest way of export is to use a service process, which is called `warden_filer` from `contrib` package: [warden.cesnet.cz/en/downloads](https://warden.cesnet.cz/en/downloads).

To install and run it, see the README file of the `warden_filer`.

Sample configuration file can look like:

```
{
    "warden": {
        "url": "https://warden-hub.cesnet.cz/warden3",
        "certfile": "/etc/warden/filer/cert.pem",
        "keyfile": "/etc/warden/filer/key.pem",
        "cafile": "/etc/warden/filer/ca-bundle.crt",
        "timeout": 60,
        "get_events_limit": 1000,
        "errlog": {"level": "error"},
        "filelog": {"file": "/data/warden/warden_client.log", "level": "error"},
        "idstore": "warden_client.id",
        "name": "cz.my.registered.ids"
    },
    "sender": {
         "dir": "/data/warden/filer/",
         "node": {
             "Name": "cz.my.registered.warden_filer"
         }
    }
}
```

The most important parameter is `dir` that point to a directory, where it waits for new messages to send.

This `dir` must be used to configure reporting modules.

Use [file type](/reporting/#file) of custom action to set a target directory and use tmpdir that points to tmp/ subdir.

Example of configuration file for NEMEA reporters (`/etc/nemea/reporters-config.yml`) with `/data/warden/filer/` dir:

```
custom_actions:
  - id: warden_export
    file:
      - path: /data/warden/filer/incoming/
      - temp_path: /data/warden/filer/temp/

rules:
  - id: always_export
    condition: True
    actions:
      - warden_exports
```

Reporter modules can be started simply as follows:

```
vportscan2idea.py --name=cz.my.registered.nemea.vportscan -c /etc/nemea/reporters-config.yml
```


This way, any IDEA message created in `/data/warden/filer/incoming/` will be sent to warden by `warden_filer` and only one registration and one certificate is needed for a server.

## Direct export by warden action

Reporters are able to send alerts to Warden directly.

There is a warden type of action.

This way requires an additional config file to be passed as `--warden=` argument to each reporter at startup (e.g. `/etc/warden/vportscan/config.cfg`).

Example:

```
vportscan2idea.py --name=cz.my.registered.nemea.vportscan --warden=/etc/warden/vportscan/config.cfg -c /etc/nemea/reporters-config.yml
```

Example of `/etc/warden/vportscan/config.cfg`:

```
{
    "url": "https://warden-hub.cesnet.cz/warden3",
    "certfile": "/etc/warden/vportscan/cert.pem",
    "keyfile": "/etc/warden/vportscan/key.pem",
    "cafile": "/etc/ssl/certs/ca-bundle.crt",
    "timeout": 60,
    "get_events_limit": 1000,
    "errlog": {"level": "debug"},
    "syslog": {"socket": "/dev/log", "facility": "local7", "level": "warning"},
}
```

Example of configuration file for NEMEA reporters (`/etc/nemea/reporters-config.yml`):

```
custom_actions:
- id: warden
  warden:

rules:
  - id: always_export
    condition: True
    actions:
      - warden
```

It is worth noting that each reporter must have its own `config.cfg`, certificate, and it must be registered on Warden server.

