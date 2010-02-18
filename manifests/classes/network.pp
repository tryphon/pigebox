class network::base {
  package { [netbase, ifupdown, net-tools]: } 
}

class network::dhcp {
  package { dhcp3-client: }
}

class network::dhcp::readonly {
  include network::dhcp
  include readonly::common

  file { "/etc/dhcp3/dhclient.conf":
    source => "$source_base/files/dhcp3/dhclient.conf", 
    require => Package["dhcp3-client"] 
  } 
  file { "/etc/dhcp3/dhclient-script":
    source => "$source_base/files/dhcp3/dhclient-script", 
    require => Package["dhcp3-client"] 
  } 

  exec { "copy-resolv.conf":
    command => "cat /etc/resolv.conf > /var/etc/resolv.conf",
    creates => "/var/etc/resolv.conf",
    require => File["/var/etc"]
  }

  file { "/etc/resolv.conf":
    ensure => "/var/etc/resolv.conf",
    require => Exec["copy-resolv.conf"]
  }

  readonly::mount_tmpfs { "/var/lib/dhcp3": }

  file { "/etc/network/run": ensure => "/var/run", force => true }

}

class network::ifplugd {
  package { ifplugd: }
}

class network::hostname {
  file { "/etc/hostname": 
    content => "pigebox"
  }
  host { pigebox: ip => "127.0.1.1" }
}
