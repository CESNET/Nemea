# About this file
This file contains a list of UniRec fields collected from all parts of project (including git submodules).
The part of this file is generated automatically, so be careful during any editing.


# List of UniRec fields
| Field name | Field data type | Description |
| ----- | ----- | ----- |
| uint32 | ADDR_CNT |  |
| bytes | ARP_DST_HA | ARP destination hardware address. |
| bytes | ARP_DST_PA | ARP destination protocol address. |
| uint16 | ARP_HA_FORMAT | Type of ARP hardware address. |
| uint16 | ARP_OPCODE | Type of ARP message. |
| uint16 | ARP_PA_FORMAT | Type of ARP protocol address. |
| bytes | ARP_SRC_HA | ARP source hardware address. |
| bytes | ARP_SRC_PA | ARP source protocol address. |
| uint32 | BAR | Generic field containing 32bit unsigned integer (used for testing and example purposes). |
| uint32 | BAZ | Generic field containing 32bit unsigned integer (used for testing and example purposes). |
| uint8 | BLACKLIST_TYPE | Type of the used blacklist (spam, C&C, malware, etc.). |
| uint64 | BYTES | Total number of bytes transferred by the flow. |
| uint64 | CALLEE_CNT |  |
| uint64 | CALLER_CNT |  |
| time | DETECTION_TIME | Timestamp of the detection of some event. |
| uint8 | DIR_BIT_FIELD | Bit field used for detemining incomming/outgoing flow. |
| uint8 | DIRECTION_FLAGS | Bit field for identification of flow direction. |
| uint16 | DNS_ANSWERS | Number of DNS answer records. |
| uint8 | DNS_BLACKLIST | ID of blacklist which contains suspicious domain name. |
| uint16 | DNS_CLASS | Class field from DNS question. |
| uint8 | DNS_DO | DNSSEC OK bit. |
| uint16 | DNS_ID | DNS transaction ID. |
| string | DNS_NAME | DNS question domain name. |
| uint16 | DNS_PSIZE | Requestor's payload size (RFC 6891). |
| uint16 | DNS_QTYPE | DNS question type field. |
| uint8 | DNS_RCODE | DNS response code field. |
| bytes | DNS_RDATA | Resource record specific data. |
| uint16 | DNS_RLENGTH | Length of DNS_RDATA. |
| uint32 | DNS_RR_TTL | DNS resource record TTL field. |
| uint64 | DST_BLACKLIST | Bit field of blacklists IDs which contains the destination address of the flow. |
| ipaddr | DST_IP | Destination IP address. |
| bytes | DST_MAC | Destination MAC address (L2). |
| uint16 | DST_PORT | Destination port of Transport layer (L4), e.g. TCP, UDP. |
| uint16 | ETHERTYPE | Protocol encapsulated in payload of L2 frame. |
| uint32 | EVENT_ID | Identification number of reported event. |
| uint32 | EVENT_SCALE | Attack intensity. |
| uint8 | EVENT_TYPE | Type of detected event. |
| uint64 | FLOWS | Number of flows, used after aggregation. |
| uint32 | FOO | Generic field containing 32bit unsigned integer (used for testing and example purposes). |
| string | HTTP_CONTENT_TYPE | Content type field from HTTP response message. |
| string | HTTP_HOST | Host field from HTTP request message. |
| string | HTTP_METHOD | Method field from HTTP request message. |
| string | HTTP_REFERER | Referer field from HTTP request message. |
| string | HTTP_REQUEST_HOST | Host field from HTTP request message. |
| string | HTTP_REQUEST_REFERER | Referer field from HTTP request message. |
| string | HTTP_REQUEST_URL | URL field from HTTP request message. |
| uint16 | HTTP_RESPONSE_CODE | Response code from HTTP response message. |
| string | HTTP_SDM_REQUEST_HOST |  |
| string | HTTP_SDM_REQUEST_REFERER |  |
| string | HTTP_SDM_REQUEST_URL |  |
| string | HTTP_URL | URL field from HTTP request message. |
| string | HTTP_USER_AGENT | User agent field from HTTP request message. |
| uint64 | INVITE_CNT |  |
| ipaddr | IP | IP address. |
| uint64 | LINK_BIT_FIELD | Bit field where each bit marks whether a flow was captured on corresponding link. |
| string | NOTE | Generic string note. |
| uint32 | NTP_DELAY | NTP root delay. |
| uint32 | NTP_DISPERSION | NTP root dispersion. |
| uint8 | NTP_LEAP | NTP leap field. |
| uint8 | NTP_MODE | NTP mode field. |
| string | NTP_ORIG | NTP origin timestamp. |
| uint8 | NTP_POLL | NTP poll interval. |
| uint8 | NTP_PRECISION | NTP precision field. |
| string | NTP_RECV | NTP receive timestamp. |
| string | NTP_REF | NTP reference timestamp. |
| string | NTP_REF_ID | NTP reference ID. |
| string | NTP_SENT | NTP transmit timestamp. |
| uint8 | NTP_STRATUM | NTP stratum field. |
| uint8 | NTP_VERSION | NTP message version. |
| uint32 | PACKETS | Number of packets of the flow. |
| uint32 | PORT_CNT |  |
| uint8 | PROTOCOL | Transport protocol identification (e.g. 6 for TCP, 17 for UDP, https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers). |
| uint64 | REQ_BYTES | Number of bytes in a flow or in an interval (requests). |
| uint32 | REQ_FLOWS | Number of flows in an interval (requests). |
| uint32 | REQ_PACKETS | Number of packets in a flow or in an interval (requests). |
| uint64 | RSP_BYTES | Number of bytes in a flow or in an interval (responses). |
| uint32 | RSP_FLOWS | Number of flows in an interval (responses). |
| uint32 | RSP_PACKETS | Number of packets in a flow or in an interval (responses). |
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
| string | SDM_CAPTURE_FILE_ID | ID of file for sdmcap. |
| string | SIP_CALLED_PARTY |  |
| string | SIP_CALL_ID |  |
| string | SIP_CALLING_PARTY |  |
| string | SIP_CSEQ |  |
| uint16 | SIP_MSG_TYPE |  |
| string | SIP_REQUEST_URI |  |
| uint16 | SIP_STATUS_CODE |  |
| string | SIP_USER_AGENT |  |
| string | SIP_VIA |  |
| uint64 | SRC_BLACKLIST | Bit field of blacklists IDs which contains the source address of the flow. |
| ipaddr | SRC_IP | Source IP address. |
| bytes | SRC_MAC | Destination MAC address (L2). |
| uint16 | SRC_PORT | Source port of Transport layer (L4), e.g. TCP, UDP. |
| string | STR1 |  |
| string | STR2 |  |
| uint8 | TCP_FLAGS | TCP flags of all packets from the flow - flag bits are added bitwise. |
| time | TIME | Timestamp of packet capture. |
| time | TIME_FIRST | Timestamp of the first packet of the flow. |
| time | TIME_LAST | Timestamp of the last packet of the flow. |
| uint32 | TIMEOUT |  |
| uint8 | TOS | Type of service field from IP header. |
| uint8 | TTL | Time-To-Live value from IP header (https://en.wikipedia.org/wiki/Time_to_live). |
| uint32 | TUNNEL_CNT_PACKET | Number of packets which were recorded recognized like anomaly. |
| string | TUNNEL_DOMAIN | Anomaly domain name. |
| float | TUNNEL_PER_NEW_DOMAIN | Percent of new domains (searched just ones). |
| float | TUNNEL_PER_SUBDOMAIN | Percent of subdomains in the most used domain for tunnel type, for another anomaly it is percent of different domains. |
| uint8 | TUNNEL_TYPE | Type of detected event. |
| string | URL |  |
| string | VOIP_FRAUD_COUNTRY_CODE | Country identification (ISO 3166, 2 char). |
| uint32 | VOIP_FRAUD_INVITE_COUNT | Total number of INVITE requests in the context of prefix examination. |
| uint32 | VOIP_FRAUD_PREFIX_EXAMINATION_COUNT | Number of unique SIP TO that was evaluated as prefix examination attack. |
| uint16 | VOIP_FRAUD_PREFIX_LENGTH | Prefix length of VOIP_FRAUD_SIP_TO (in prefix examination attack). |
| string | VOIP_FRAUD_SIP_FROM | SIP FROM header. |
| string | VOIP_FRAUD_SIP_TO | SIP TO header. |
| uint32 | VOIP_FRAUD_SUCCESSFUL_CALL_COUNT | Number of successful calls initiation to unique SIP TO in the context of prefix examination. |
| string | VOIP_FRAUD_USER_AGENT | SIP User-Agent header. |
| uint8 | WARDEN_TYPE | Type of event. |

This table can be updated using `ur_dict_updater.sh` which completes missing fields.
Description of the fields must be filled manually.

