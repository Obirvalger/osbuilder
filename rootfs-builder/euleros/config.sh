#
# Copyright (C) 2018 Huawei Technologies Co., Ltd
#
# SPDX-License-Identifier: Apache-2.0
OS_NAME="EulerOS"

OS_VERSION=${OS_VERSION:-2.2}

BASE_URL="http://developer.huawei.com/ict/site-euleros/euleros/repo/yum/${OS_VERSION}/os/${ARCH}/"

GPG_KEY_FILE="RPM-GPG-KEY-EulerOS"

PACKAGES="iptables chrony"

#Optional packages:
# systemd: An init system that will start kata-agent if kata-agent
#          itself is not configured as init process.
[ "$AGENT_INIT" == "no" ] && PACKAGES+=" systemd" || true

# Init process must be one of {systemd,kata-agent}
INIT_PROCESS=systemd
# List of zero or more architectures to exclude from build,
# as reported by  `uname -m`
ARCH_EXCLUDE_LIST=( aarch64 ppc64le s390x )
# Allow the build to fail without generating an error.
# For more info see: https://github.com/kata-containers/osbuilder/issues/190
BUILD_CAN_FAIL=1

[ "$SECCOMP" = "yes" ] && PACKAGES+=" libseccomp" || true
