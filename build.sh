#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# build.sh
#
# The main script that runs the build
#

base_path="$( cd "$( dirname "$0" )" && pwd )"
arch=('i686' 'x86_64')
packages=('plymouth' 'calamares' 'orchiis' 'tela-circle-icon-theme')
pkg_builds=('orchiis' 'tela-circle-icon-theme')

_config_packages() {
    mkdir -p "${base_path}/localrepo/i686 ${base_path}/localrepo/x86_64"
}

_build_packages() {
    for pkg in "${pkg_builds[@]}"; do
        echo -e "[build.sh] building ${pkg} "
        cd "${base_path}/${pkg}" 
        makepkg -cfs
        mv *.pkg.tar.zst ../localrepo/x86_64
    done
}

_finish() {
    cd "${base_path}/localrepo/x86_64"
    for pkg in "${packages[@]}"; do
        repo_packages="${repo_packages} ${pkg}*.pkg.tar.zst "
    done
    repo-add essentials.db.tar.gz ${repo_packages}
}

_config_packages
_build_packages
_finish
