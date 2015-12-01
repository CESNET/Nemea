#!/bin/sh

# name of the output file:
conffile=supervisor_config.xml

echo "This script expects one argument: 'configonly' or 'install'.

'configonly': creates a config file for Nemea-Supervisor using *.sup files.
'install':    runs 'configonly' and also creates directories from *.mkdir files.

Note: root permissions are probably needed for 'install'"

if [ "$1" = "configonly" -o "$1" = "install" ]; then
	cat > "$conffile" <<END
<?xml version="1.0"?>
<nemea-supervisor>
	<supervisor>
		<verbose>false</verbose>
		<module-restarts>4</module-restarts>
		<logs-directory>/var/log/nemea-supervisor/</logs-directory>
	</supervisor>

	<modules>
		<name>detection modules</name>
		<enabled>true</enabled>

END

	cat *.sup >> "$conffile"

	cat >> "$conffile" <<END
	</modules>
</nemea-supervisor>
END

	xmllint -format "$conffile" > "$conffile.tmp" && mv "$conffile.tmp" "$conffile"

fi

# creation of needed directories and permissions setup
if [ "$1" = "install" ]; then
	for f in *.mkdir; do
		for d in `cat "$f"`; do
			mkdir -p "$d"
			# This is not secure enough! It grants full access to the directory:
			chmod 777 "$d"
		done
	done
fi

