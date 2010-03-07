import "defaults"
#import "defines/*.pp"
import "classes/*.pp"

import "box"

$source_base="/tmp/puppet"

# used as default hostname, etc
$box_name="pigebox"

# TODO replace by puppet boot
include readonly::initvarlog

include network
include network::interfaces::deprecated

include serial::console

include syslog
include ntp::readonly
include dbus::readonly
include avahi
include mdadm
include ssh
include smtp
include apache
include apache::dnssd
include munin::readonly
include munin-node
include sudo
include puppet

include apt
include linux::kernel-2-6-30

include alsa::common
include pige
