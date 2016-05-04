# -*- mode: ruby -*-
# vi: set ft=ruby :

$ipfixcolpatch = <<-SCRIPT
echo '--- startup.xml	2016-02-25 14:30:15.595229902 +0100
+++ startup_new.xml	2016-02-25 14:26:54.543236208 +0100
@@ -1,148 +1,79 @@
 <?xml version="1.0" encoding="UTF-8"?>
 <ipfix xmlns="urn:ietf:params:xml:ns:yang:ietf-ipfix-psamp">
 
-	<!--## Every collecting process will be started as new process -->
-	<collectingProcess>
-		<!--## Arbitrary collecting process name  -->
-		<name>UDP collector</name>
-		<!--## Type of the collector. Supported types are defined in internalcfg.xml -->
-		<udpCollector>
-			<!--## Arbitrary udp collector name -->
-			<name>Listening port 4739</name>
-			<!--## Local listening port -->
-			<localPort>4739</localPort>
-			<!--## Template lifetime in seconds -->
-			<templateLifeTime>1800</templateLifeTime>
-			<!--## Options template lifetime in seconds -->
-			<optionsTemplateLifeTime>1800</optionsTemplateLifeTime>
-			<!--## Template lifetime in packets (for how many packets is template valid) -->
-			<!-- <templateLifePacket>5</templateLifePacket>  -->
-			<!--## Options template lifetime in packets -->
-			<!-- <optionsTemplateLifePacket>100</optionsTemplateLifePacket>  -->
-			<!--## Local address to listen on. If empty, bind to all interfaces -->
-			<localIPAddress>127.0.0.1</localIPAddress>
-		</udpCollector>
-		<!--## Name of the exporting process. Must match exporting process name -->
-		<exportingProcess>File writer UDP</exportingProcess>
-		<!--## File for exporting status information to (combined with -S) -->
-		<statisticsFile>/tmp/ipfixcol_stat.log</statisticsFile>
-	</collectingProcess>
+        <collectingProcess>
+                <name>UDP collector</name>
+                <udpCollector>
+                        <name>Listening port 4739</name>
+                        <localPort>4739</localPort>
+                        <localIPAddress></localIPAddress>
+                </udpCollector>
+                <exportingProcess>UniRec output</exportingProcess>
+        </collectingProcess>
+
+        <exportingProcess>
+                <name>UniRec output</name>
+                <destination>
+                        <name>Make unirec from the flow data</name>
+                        <fileWriter>
+                                <fileFormat>unirec</fileFormat>
+                                <!-- Default interface -->
+                                <interface>
+                                        <type>u</type>
+                                        <params>flow_data_source</params>
+                                        <ifcTimeout>10000</ifcTimeout>
+                                        <flushTimeout>1000000</flushTimeout>
+                                        <bufferSwitch>1</bufferSwitch>
+                                        <format>DST_IP,SRC_IP,BYTES,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,PACKETS,?DST_PORT,?SRC_PORT,DIR_BIT_FIELD,PROTOCOL,?TCP_FLAGS,?TOS,?TTL</format>
+                                </interface>
+                               <!-- VOIP interface -->
+                                <interface>
+                                        <type>u</type>
+                                        <params>voip_data_source</params>
+                                        <ifcTimeout>1000</ifcTimeout>
+                                        <flushTimeout>1000000</flushTimeout>
+                                        <bufferSwitch>1</bufferSwitch>
+                                        <format>DST_IP,?INVEA_SIP_RTP_IP4,?INVEA_SIP_RTP_IP6,SRC_IP,BYTES,?INVEA_RTCP_OCTETS,?INVEA_RTCP_PACKETS,?INVEA_SIP_BYE_TIME,?INVEA_SIP_INVITE_RINGING_TIME,?INVEA_SIP_OK_TIME,?INVEA_SIP_STATS,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,?INVEA_RTCP_LOST,?INVEA_RTP_JITTER,PACKETS,?DST_PORT,?INVEA_SIP_RTP_AUDIO,?INVEA_SIP_RTP_VIDEO,?SRC_PORT,DIR_BIT_FIELD,?INVEA_RTCP_SOURCE_COUNT,?INVEA_RTP_CODEC,?INVEA_VOIP_PACKET_TYPE,PROTOCOL,?TCP_FLAGS,?TOS,?TTL,?INVEA_SIP_CALLED_PARTY,?INVEA_SIP_CALLING_PARTY,?INVEA_SIP_CALL_ID,?INVEA_SIP_REQUEST_URI,?INVEA_SIP_USER_AGENT,?INVEA_SIP_VIA</format>
+                                </interface>
+                                <!-- SMTP interface -->
+                                <interface>
+                                        <type>u</type>
+                                        <params>smtp_data_source</params>
+                                        <ifcTimeout>1000</ifcTimeout>
+                                        <flushTimeout>1000000</flushTimeout>
+                                        <bufferSwitch>1</bufferSwitch>
+                                        <format>DST_IP,SRC_IP,BYTES,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,PACKETS,?SMTP_2XX_STAT_CODE_COUNT,?SMTP_3XX_STAT_CODE_COUNT,?SMTP_4XX_STAT_CODE_COUNT,?SMTP_5XX_STAT_CODE_COUNT,?SMTP_COMMAND_FLAGS,?SMTP_MAIL_CMD_COUNT,?SMTP_RCPT_CMD_COUNT,?SMTP_STAT_CODE_FLAGS,DST_PORT,SRC_PORT,DIR_BIT_FIELD,PROTOCOL,TCP_FLAGS,?TOS,?TTL,?SMTP_DOMAIN,?SMTP_FIRST_RECIPIENT,?SMTP_FIRST_SENDER</format>
+                                </interface>
+                                <!-- HTTP interface -->
+                                <interface>
+                                        <type>u</type>
+                                        <params>http_data_source</params>
+                                        <ifcTimeout>1000</ifcTimeout>
+                                        <flushTimeout>1000000</flushTimeout>
+                                        <bufferSwitch>1</bufferSwitch>
+                                        <format>DST_IP,SRC_IP,BYTES,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,?HTTP_REQUEST_AGENT_ID,?HTTP_REQUEST_METHOD_ID,?HTTP_RESPONSE_STATUS_CODE,PACKETS,DST_PORT,SRC_PORT,DIR_BIT_FIELD,PROTOCOL,TCP_FLAGS,?TOS,?TTL,?HTTP_REQUEST_AGENT,?HTTP_REQUEST_HOST,?HTTP_REQUEST_REFERER,?HTTP_REQUEST_URL,?HTTP_RESPONSE_CONTENT_TYPE</format>
+                                </interface>
+                                <!-- IPv6 Tunnel interface -->
+                                <interface>
+                                        <type>u</type>
+                                        <params>ipv6tunnel_data_source</params>
+                                        <ifcTimeout>1000</ifcTimeout>
+                                        <flushTimeout>1000000</flushTimeout>
+                                        <bufferSwitch>1</bufferSwitch>
+                                        <format>DST_IP,SRC_IP,BYTES,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,PACKETS,?DST_PORT,?SRC_PORT,DIR_BIT_FIELD,?IPV6_TUN_TYPE,PROTOCOL,?TCP_FLAGS,?TOS,?TTL</format>
+                                </interface>
+                                <!-- DNS interface -->
+                                <interface>
+                                        <type>u</type>
+                                        <params>dns_data_source</params>
+                                        <ifcTimeout>1000</ifcTimeout>
+                                        <flushTimeout>1000000</flushTimeout>
+                                        <bufferSwitch>1</bufferSwitch>
+                                        <format>DST_IP,SRC_IP,BYTES,LINK_BIT_FIELD,TIME_FIRST,TIME_LAST,DNS_RR_TTL,PACKETS,DNS_ANSWERS,DNS_CLASS,DNS_ID,?DNS_PSIZE,DNS_QTYPE,DNS_RLENGTH,?DST_PORT,?SRC_PORT,DIR_BIT_FIELD,?DNS_DO,DNS_RCODE,PROTOCOL,?TCP_FLAGS,?TOS,?TTL,?DNS_NAME,?DNS_RDATA</format>
+                                </interface>
+                        </fileWriter>
+                </destination>
+                <singleManager>yes</singleManager>
+        </exportingProcess>
 
-	<collectingProcess>
-		<name>TCP collector</name>
-		<tcpCollector>
-			<name>Listening port 4739</name>
-			<localPort>4739</localPort>
-			<localIPAddress>127.0.0.1</localIPAddress>
-		</tcpCollector>
-		<exportingProcess>File writer TCP</exportingProcess>
-	</collectingProcess>
-
-	<collectingProcess>
-		<name>SCTP collector</name>
-		<sctpCollector>
-			<name>Listening port 4739</name>
-			<localPort>4739</localPort>
-			<!--## Collector will listen on all addresses specified below -->
-			<localIPAddress>127.0.0.1</localIPAddress>
-			<localIPAddress>::1</localIPAddress>
-		</sctpCollector>
-		<exportingProcess>File writer SCTP</exportingProcess>
-	</collectingProcess>
-
-	<!--## Exporting process configuration -->
-	<exportingProcess>
-		<!--## Name of the exporting process, must match <exportingProcess> element
-			   in <collectingProcess> -->
-		<name>File writer UDP</name>
-		<!--## Specification of storage plugin -->
-		<destination>
-			<!--## Arbitrary name -->
-			<name>Write to /tmp folder</name>
-			<!--## Observation domain ID valid for this storage plugin 
-				   Only packets with this ODID will be passed to the plugin
-				   If unspecified, plugin is used for unknown ODIDs 
-					 (and not for any of specified)
-			-->
-			<observationDomainId>1</observationDomainId>
-			<!--## This element is passed to storage plugin -->
-			<fileWriter>
-				<!--## fileFormat must be configured in internalcfg.xml -->
-				<fileFormat>ipfix</fileFormat>
-				<!--## Storage plugin specific element -->
-				<file>file://tmp/collected-records-udp_1.ipfix</file>
-			</fileWriter>
-		</destination>
-		<destination>
-			<name>Write to /tmp folder</name>
-			<fileWriter>
-				<fileFormat>ipfix</fileFormat>
-				<file>file://tmp/collected-records-udp.ipfix</file>
-			</fileWriter>
-		</destination>
-	</exportingProcess>
-	
-	<exportingProcess>
-		<name>File writer TCP</name>
-		<destination>
-			<name>Write to /tmp folder</name>
-			<fileWriter>
-				<fileFormat>ipfix</fileFormat>
-				<file>file://tmp/collected-records-tcp.ipfix</file>
-			</fileWriter>
-		</destination>
-
-		<!--## Enable single Data manager - only one instance of storage plugin(s)
-		shared between every ODID -->
-		<!-- <singleManager>yes</singleManager>  -->
-	</exportingProcess>
-
-	<exportingProcess>
-		<name>File writer SCTP</name>
-		<destination>
-			<name>Store data using ipfix file format</name>
-			<fileWriter>
-				<fileFormat>ipfix</fileFormat>
-				<file>file://tmp/collected-records-sctp.ipfix</file>
-			</fileWriter>
-		</destination>
-	</exportingProcess>
-
-	<!-- List of active Intermediate Plugins -->
-	<intermediatePlugins>
-		<!-- Dummy Intermediate Plugin - does nothing -->
-		<dummy_ip>
-		</dummy_ip>
-		
-		<!-- Configuration for Anonymization Intermediate Plugin -->
-		<!--
-		<anonymization_ip>
-			<type>cryptopan</type>
-		</anonymization_ip>
-		-->
-		
-		<!-- Configuration for next Anonymization Intermediate Plugin -->
-		<!--
-		<anonymization_ip>
-			<type>truncation</type>
-		</anonymization_ip>
-		-->
-		
-		<!-- Configuration for joinflows plugin -->
-		<!-- <joinflows_ip>	-->
-			<!-- Set destination ODID -->
-			<!-- <join to="2"> -->
-				<!-- Set source ODIDs for this dst ODID -->
-				<!-- <from>1</from>	-->
-				<!-- <from>3</from> -->
-			<!-- </join> -->
-			<!-- Set another destination ODID -->
-			<!-- <join to="4"> -->
-				<!-- <from>5</from> -->
-				<!-- All ODIDs not mentioned in any <join> block 
-				  will be mapped on this dst ODID -->
-				<!-- <from>*</from> -->
-			<!-- </join> -->
-		<!-- </joinflows_ip> -->
-	</intermediatePlugins>
 </ipfix>' > /etc/ipfixcol/startup.diff
patch /etc/ipfixcol/startup.xml /etc/ipfixcol/startup.diff
rm -f /etc/ipfixcol/startup.diff
SCRIPT
