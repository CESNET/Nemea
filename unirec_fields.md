# About this file
This file contains a list of UniRec fields collected from all parts of project (including git submodules).
The part of this file is generated automatically, so be careful during any editing.


# List of UniRec fields
| Field name | Field data type | Description |
| ----- | ----- | ----- |
| uint32 | ADDR_CNT |  |
| bytes | ARP_DST_HA |  |
| bytes | ARP_DST_PA |  |
| uint16 | ARP_HA_FORMAT |  |
| uint16 | ARP_OPCODE |  |
| uint16 | ARP_PA_FORMAT |  |
| bytes | ARP_SRC_HA |  |
| bytes | ARP_SRC_PA |  |
| uint32 | BAR |  |
| uint32 | BAZ |  |
| uint8 | BLACKLIST_TYPE |  |
| uint64 | BYTES |  |
| uint64 | CALLEE_CNT |  |
| uint64 | CALLER_CNT |  |
| time | DETECTION_TIME |  |
| uint8 | DIR_BIT_FIELD |  |
| uint8 | DIRECTION_FLAGS |  |
| uint16 | DNS_ANSWERS |  |
| uint8 | DNS_BLACKLIST |  |
| uint16 | DNS_CLASS |  |
| uint8 | DNS_DO |  |
| uint16 | DNS_ID |  |
| string | DNS_NAME |  |
| uint16 | DNS_PSIZE |  |
| uint16 | DNS_QTYPE |  |
| uint8 | DNS_RCODE |  |
| bytes | DNS_RDATA |  |
| uint16 | DNS_RLENGTH |  |
| uint32 | DNS_RR_TTL |  |
| uint64 | DST_BLACKLIST |  |
| ipaddr | DST_IP | Destination IP address. |
| bytes | DST_MAC | Destination MAC address (L2). |
| uint16 | DST_PORT | Destination port of Transport layer (L4), e.g. TCP, UDP. |
| uint16 | ETHERTYPE |  |
| uint32 | EVENT_ID |  |
| uint32 | EVENT_SCALE |  |
| uint8 | EVENT_TYPE |  |
| uint64 | FLOWS |  |
| uint32 | FOO |  |
| string | HTTP_CONTENT_TYPE |  |
| string | HTTP_HOST |  |
| string | HTTP_METHOD |  |
| string | HTTP_REFERER |  |
| string | HTTP_REQUEST_HOST | HTTP Hostname from request. |
| string | HTTP_REQUEST_REFERER |  |
| string | HTTP_REQUEST_URL |  |
| uint16 | HTTP_RESPONSE_CODE |  |
| string | HTTP_SDM_REQUEST_HOST |  |
| string | HTTP_SDM_REQUEST_REFERER |  |
| string | HTTP_SDM_REQUEST_URL |  |
| string | HTTP_URL |  |
| string | HTTP_USER_AGENT |  |
| uint64 | INVITE_CNT |  |
| ipaddr | IP |  |
| uint64 | LINK_BIT_FIELD |  |
| string | NOTE |  |
| uint32 | NTP_DELAY |  |
| uint32 | NTP_DISPERSION |  |
| uint8 | NTP_LEAP |  |
| uint8 | NTP_MODE |  |
| string | NTP_ORIG |  |
| uint8 | NTP_POLL |  |
| uint8 | NTP_PRECISION |  |
| string | NTP_RECV |  |
| string | NTP_REF |  |
| string | NTP_REF_ID |  |
| string | NTP_SENT |  |
| uint8 | NTP_STRATUM |  |
| uint8 | NTP_VERSION |  |
| uint32 | PACKETS |  |
| uint32 | PORT_CNT |  |
| uint8 | PROTOCOL |  |
| uint64 | REQ_BYTES |  |
| uint32 | REQ_FLOWS |  |
| uint32 | REQ_PACKETS |  |
| uint64 | RSP_BYTES |  |
| uint32 | RSP_FLOWS |  |
| uint32 | RSP_PACKETS |  |
| uint32 | SBFD_ATTEMPTS |  |
| uint32 | SBFD_AVG_ATTEMPTS |  |
| time | SBFD_BREACH_TIME |  |
| time | SBFD_CEASE_TIME |  |
| uint64 | SBFD_EVENT_ID |  |
| time | SBFD_EVENT_TIME |  |
| uint8 | SBFD_EVENT_TYPE |  |
| uint64 | SBFD_LINK_BIT_FIELD |  |
| uint8 | SBFD_PROTOCOL |  |
| ipaddr | SBFD_SOURCE |  |
| ipaddr | SBFD_TARGET |  |
| string | SBFD_USER |  |
| string | SDM_CAPTURE_FILE_ID |  |
| string | SIP_CALLED_PARTY |  |
| string | SIP_CALL_ID |  |
| string | SIP_CALLING_PARTY |  |
| string | SIP_CSEQ |  |
| uint16 | SIP_MSG_TYPE |  |
| string | SIP_REQUEST_URI |  |
| uint16 | SIP_STATUS_CODE |  |
| string | SIP_USER_AGENT |  |
| string | SIP_VIA |  |
| uint64 | SRC_BLACKLIST |  |
| ipaddr | SRC_IP |  |
| bytes | SRC_MAC | Destination MAC address (L2). |
| uint16 | SRC_PORT | Source port of Transport layer (L4), e.g. TCP, UDP. |
| string | STR1 |  |
| string | STR2 |  |
| uint8 | TCP_FLAGS | TCP flags of all packets from the flow - flag bits are added bitwise. |
| time | TIME |  |
| time | TIME_FIRST | Timestamp of the first packet of the flow. |
| time | TIME_LAST | Timestamp of the last packet of the flow. |
| uint32 | TIMEOUT |  |
| uint8 | TOS |  |
| uint8 | TTL | Time-To-Live value. |
| uint32 | TUNNEL_CNT_PACKET |  |
| string | TUNNEL_DOMAIN |  |
| float | TUNNEL_PER_NEW_DOMAIN |  |
| float | TUNNEL_PER_SUBDOMAIN |  |
| uint8 | TUNNEL_TYPE |  |
| string | URL |  |
| string | VOIP_FRAUD_COUNTRY_CODE |  |
| uint32 | VOIP_FRAUD_INVITE_COUNT |  |
| uint32 | VOIP_FRAUD_PREFIX_EXAMINATION_COUNT |  |
| uint16 | VOIP_FRAUD_PREFIX_LENGTH |  |
| string | VOIP_FRAUD_SIP_FROM |  |
| string | VOIP_FRAUD_SIP_TO |  |
| uint32 | VOIP_FRAUD_SUCCESSFUL_CALL_COUNT |  |
| string | VOIP_FRAUD_USER_AGENT |  |
| uint8 | WARDEN_TYPE |  |

This table can be updated using `ur_dict_updater.sh` which completes missing fields.
Description of the fields must be filled manually.

