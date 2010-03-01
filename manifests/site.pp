import "defaults"
import "defines/*.pp"
import "classes/*.pp"

$source_base="/tmp/puppet"

file { "/etc/network/interfaces": 
   content => "auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
"
}

include readonly::initvarlog

include network::base
include network::dhcp::readonly
include network::ifplugd
include network::hostname
include syslog
include ntp::readonly
include dbus::readonly
include avahi
include mdadm
include ssh
include smtp
include apache
include munin::readonly
include munin-node
include sudo
include puppet

include apt
include linux::kernel-2-6-30

include alsa::common
include pige
