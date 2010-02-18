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

# Support now only local key files
define apt::key($ensure = present, $source) {
  case $ensure {
    present: {
      exec { "cat '$source' | /usr/bin/apt-key add -":
        unless => "apt-key list | grep -Fqe '${name}'"
      }
    }
    
    absent: {
      exec {"/usr/bin/apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }
  }
}

define apt::source($key) {
  apt::key { $key:
    source => "$source_base/files/apt/$name.key"
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
    key => "C6ADBBD5"
  }
}

class apt::backport {
  apt::source { "lenny-backport": 
    key => "16BA136C"
  }
}
