################################################################################
#
# fakeroot
#
################################################################################

FAKEROOT_VERSION = 1.37.2
FAKEROOT_SOURCE = fakeroot_$(FAKEROOT_VERSION).orig.tar.gz
FAKEROOT_SITE = https://snapshot.debian.org/archive/debian/20260401T000000Z/pool/main/f/fakeroot

HOST_FAKEROOT_DEPENDENCIES = host-acl
# Force capabilities detection off
# For now these are process capabilities (faked) rather than file
# so they're of no real use
HOST_FAKEROOT_CONF_ENV = \
	ac_cv_header_sys_capability_h=no \
	ac_cv_func_capset=no

LIBC := $(shell ldd --version 2>&1 | head -1 | grep -oiE "musl|glibc" | tr '[:upper:]' '[:lower:]')
ifeq ($(LIBC),musl)
	HOST_FAKEROOT_CONF_ENV += CFLAGS="-D_STAT_VER=0 $(CFLAGS)"
	FAKEROOT_AUTORECONF = YES
endif

FAKEROOT_LICENSE = GPL-3.0+
FAKEROOT_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
