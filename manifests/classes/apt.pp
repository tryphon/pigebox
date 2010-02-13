# Retrieved from module puppet-apt

class apt {
  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true
  }
  Package {
    require => Exec["apt-get_update"]
  }

}

define apt::key($ensure = present, $source) {
  include wget
  case $ensure {
    present: {
      file { "/tmp/${name}.key":
        source => "$source_base/files/${name}.key"
      }
			exec { "cat /tmp/${name}.key | /usr/bin/apt-key add -":
        require => File["/tmp/${name}.key"],
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"]
      }
#      exec { "/usr/bin/wget -O - '$source' | /usr/bin/apt-key add -":
#        unless => "apt-key list | grep -Fqe '${name}'",
#        path   => "/bin:/usr/bin",
#        before => Exec["apt-get_update"],
#        notify => Exec["apt-get_update"],
#        require => [Package[wget], Class["network::base"], Class["network::ifplugd"]]
#      }
    }
    
    absent: {
      exec {"/usr/bin/apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }
  }
}

define apt::source($key, $key_source) {
  apt::key { $key:
    source => $key_source
  }
  # copy and launch apt-get update in the same operation
  exec { "apt-source-copy-$name":
    command => "cat $source_base/files/apt/$name.list > /etc/apt/sources.list.d/$name.list && apt-get update",
    require => Apt::Key[$key],
    creates => "/etc/apt/sources.list.d/$name.list"
  }
}

class apt::local {
  include apt
  file { "/etc/apt/preferences":
    source => "$source_base/files/apt/preferences",
    notify => Exec["apt-get_update"]
  }
}

class apt::tryphon {
  apt::source { tryphon: 
    key => "C6ADBBD5",
    key_source => "http://debian.tryphon.org/release.asc"
  }
}

class apt::backport {
  apt::source { "lenny-backport": 
    key => "16BA136C",
    key_source => "http://backports.org/debian/archive.key"
  }
}
