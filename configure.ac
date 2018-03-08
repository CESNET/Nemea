#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.63])
AC_INIT([nemea], [2.4.0], [traffic-analysis@cesnet.cz])
AM_INIT_AUTOMAKE([foreign subdir-objects])
RELEASE=1
AC_SUBST(RELEASE)
USERNAME=`git config --get user.name`
USERMAIL=`git config --get user.email`
AC_SUBST(USERNAME)
AC_SUBST(USERMAIL)
# Check for rpmbuild
AC_CHECK_PROG(RPMBUILD, rpmbuild, rpmbuild, [""])

AC_SUBST(RPMBUILD)
if test -z "$RPMBUILD"; then
	AC_MSG_WARN([Due to missing rpmbuild you will not able to generate RPM package.])
fi

RPM_RELEASE=1
AC_SUBST(RPM_RELEASE)
AM_CONDITIONAL(MAKE_RPMS, test x$RPMBUILD != x)

AC_ARG_ENABLE([supervisor], AC_HELP_STRING([--disable-supervisor], [Disable supervisor.]),
        [AM_CONDITIONAL([ENABLE_SUPERVISOR], [test "x$enableval" = xyes])],
        [AM_CONDITIONAL([ENABLE_SUPERVISOR], [true])])

AC_ARG_ENABLE([modules], AC_HELP_STRING([--disable-modules], [Disable NEMEA modules.]),
        [AM_CONDITIONAL([ENABLE_MODULES], [test "x$enableval" = xyes])],
        [AM_CONDITIONAL([ENABLE_MODULES], [true])])

AC_ARG_ENABLE([detectors], AC_HELP_STRING([--disable-detectors], [Disable NEMEA detectors.]),
        [AM_CONDITIONAL([ENABLE_DETECTORS], [test "x$enableval" = xyes])],
        [AM_CONDITIONAL([ENABLE_DETECTORS], [true])])

AC_CONFIG_FILES([Makefile
                  nemea.spec])
AC_CONFIG_SUBDIRS([nemea-framework nemea-supervisor modules detectors])
AC_OUTPUT

echo "Components:"
echo "  NEMEA modules....................: `if [[ -z "$ENABLE_MODULES_TRUE" ]]; then echo enabled; else echo disabled; fi`"
echo "  NEMEA detectors..................: `if [[ -z "$ENABLE_DETECTORS_TRUE" ]]; then echo enabled; else echo disabled; fi`"
echo "  NEMEA supervisor.................: `if [[ -z "$ENABLE_SUPERVISOR_TRUE" ]]; then echo enabled; else echo disabled; fi`"

