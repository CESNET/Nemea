SUBDIRS=nemea-framework

if ENABLE_SUPERVISOR
SUBDIRS+=nemea-supervisor
endif

if ENABLE_MODULES
SUBDIRS+=modules
endif

if ENABLE_DETECTORS
SUBDIRS+=detectors
endif

# because of supervisor, disable systemd checking and installation during
# distcheck
DISTCHECK_CONFIGURE_FLAGS="--without-systemd"

