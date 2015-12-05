#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.63])
AC_INIT([nemea], [2.1.0], [traffic-analysis@cesnet.cz])
AM_INIT_AUTOMAKE([foreign subdir-objects])

AC_MSG_CHECKING([network interface name])

# get IFC of default gateway
NIC_NAME=`route -n | sed -n '/^0\.0\.0\.0/ s/.*\s\([a-zA-Z0-9]\)/\1/p'`

if [[ -n "$NIC_NAME" ]]; then
    AC_MSG_RESULT([$NIC_NAME])
    AC_SUBST([NIC_NAME])
else
    AC_MSG_RESULT([not found])
fi

# Checks for programs.

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile config-examples/Makefile config-examples/flow_meter.sup])
AC_CONFIG_SUBDIRS([nemea-framework nemea-supervisor modules detectors])
AC_OUTPUT
