EXTRA_DIST=amplification_detection.mkdir \
	   amplification_detection.sup \
	   hoststats.mkdir \
	   hoststats.sup \
	   prepare_default_config.sh \
	   README.md \
	   supervisor.mkdir \
	   traffic_repeater.sup

BUILT_SOURCES=supervisor_config.xml

supervisor_config.xml:
	./prepare_default_config.sh configonly

clean-local:
	@rm -f ${BUILT_SOURCES}

