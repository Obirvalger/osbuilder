#!/bin/bash
# Copyright (c) 2020  Mikhail Gordeev
#
# SPDX-License-Identifier: Apache-2.0

# - Arguments
# rootfs_dir=$1
#
# - Optional environment variables
#
# EXTRA_PKGS: Variable to add extra PKGS provided by the user
#
# BIN_AGENT: Name of the Kata-Agent binary
#
# REPO_URL: URL to distribution repository ( should be configured in
#           config.sh file)
#
# Any other configuration variable for a specific distro must be added
# and documented on its own config.sh
#
# - Expected result
#
# rootfs_dir populated with rootfs pkgs
# It must provide a binary in /sbin/init

relink() {
    local ROOTFS_DIR=$1
    local FROM=$2
    local TO=$3

    if [ ! -L "${ROOTFS_DIR}/${FROM}" ]; then
        /bin/mkdir -p "${ROOTFS_DIR}/${TO}"
        find "${ROOTFS_DIR}/${FROM}" -maxdepth 1 -mindepth 1 -exec \
            mv -t "${ROOTFS_DIR}/${TO}" {} +
        rmdir "${ROOTFS_DIR}/${FROM}"
        chroot "${ROOTFS_DIR}" ln -rsf "${TO}" -T "${FROM}"
    fi
}

build_rootfs() {
	# Mandatory
	local ROOTFS_DIR=$1

	# Name of the Kata-Agent binary
	local BIN_AGENT=${BIN_AGENT}

	# In case of support EXTRA packages, use it to allow
	# users add more packages to the base rootfs
	local EXTRA_PKGS=${EXTRA_PKGS:-}

	# In case rootfs is created usign repositories allow user to modify
	# the default URL
	local REPO_URL=${REPO_URL-}

	# PATH where files this script is placed
	# Use it to refer to files in the same directory
	# Exmaple: ${CONFIG_DIR}/foo
	local CONFIG_DIR=${CONFIG_DIR}


	# Populate ROOTFS_DIR
	# Must provide /sbin/init and /bin/${BIN_AGENT}
	check_root
	mkdir -p "${ROOTFS_DIR}"

    apt-get -y -o "RPM::RootDir=${ROOTFS_DIR}" \
        install ${PACKAGES} ${EXTRA_PKGS}

    relink "${ROOTFS_DIR}" /var/run /run
    relink "${ROOTFS_DIR}" /var/lock /run/lock
}
