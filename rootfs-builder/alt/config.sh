# Copyright (c) 2020  Mikhail Gordeev
#
# SPDX-License-Identifier: Apache-2.0

# This is a configuration file add extra variables to
# be used by build_rootfs() from rootfs_lib.sh the variables will be
# loaded just before call the function. For more information see the
# rootfs-builder/README.md file.

OS_NAME="ALT"
OS_VERSION=${OS_VERSION:-p9}

PACKAGES="systemd-sysvinit iptables chrony"

# Init process must be one of {systemd,kata-agent}
INIT_PROCESS=systemd
# List of zero or more architectures to exclude from build,
# as reported by  `uname -m`
ARCH_EXCLUDE_LIST=( s390x )

[ "$SECCOMP" = "yes" ] && PACKAGES+=" libseccomp" || true
