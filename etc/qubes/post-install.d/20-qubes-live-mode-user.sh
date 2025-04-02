#!/bin/sh --

## Copyright (C) 2025 - 2025 ENCRYPTED SUPPORT LLC <adrelanos@whonix.org>
## See the file COPYING for copying conditions.

## NOTE: Code duplication.
## Copied from: helper-scripts /usr/libexec/helper-scripts/package_installed_check.bsh
pkg_installed() {
   local package_name dpkg_query_output
   local requested_action status error_state

   package_name="$1"
   ## Cannot use '&>' because it is a bashism.
   dpkg_query_output="$(dpkg-query --show --showformat='${Status}' "$package_name" 2>/dev/null)" || true
   ## dpkg_query_output Examples:
   ## install ok half-configured
   ## install ok installed

   requested_action=$(printf '%s' "$dpkg_query_output" | awk '{print $1}')
   status=$(printf '%s' "$dpkg_query_output" | awk '{print $2}')
   error_state=$(printf '%s' "$dpkg_query_output" | awk '{print $3}')

   if [ "$requested_action" = 'install' ]; then
      true "$0: INFO: $package_name is installed, ok."
      return 0
   fi

   true "$0: INFO: $package_name is not installed, ok."
   return 1
}

if pkg_installed initramfs-tools ; then
   qvm-features-request boot-mode.kernelopts.live='boot=live plainroot union=overlay ip=frommedia noeject nopersistence'
elif pkg_installed dracut ; then
   qvm-features-request boot-mode.kernelopts.live='rootovl'
fi
qvm-features-request boot-mode.name.live='LIVE mode USER'
