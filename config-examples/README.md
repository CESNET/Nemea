How to use this directory?
==========================

This directory can be used for automatic generation of default
configuration for deployment of the Nemea system with supervisor.

To add new module, do the following steps.

Create a file with the _.sup_ extension that will contain module's
configuration for supervisor.  The supervisor configuration file is
described in supervisor's README.  However, the format is in XML-style,
users can inspire themselves by reading existing _.sup_ files.

Note: the content of the _.sup_ file is placed into template of new
supervisor's configuration file.  Therefore, it need not to have only one
root element as normal XML must have.

If the added module need to use existing one or more directories e.g. for
logs or outputs, create a second file with _.mkdir_ extension instead of _.sup_
for the module.  The content of _.mkdir_ is simply read and passed to mkdir(1)
and chmod(1).  This script does NOT support white spaces in the paths that
are listed in _.mkdir_ files.

To generate new supervisor config files and to create needed directories,
run the *prepare_default_config.sh* script.  The output configuration file
can be found as *supervisor_config.xml*.  It must be moved into default path
e.g. /etc/nemea/.

Note: if there is a special need of permissions and owners setting,
it should be tuned manually.  Patches are welcome...

