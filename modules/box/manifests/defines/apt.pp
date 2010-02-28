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

define apt::source::pin($source) {
  apt::preferences { $name:
    package => $name, 
    pin => "release a=$source",
    priority => 999,
    require => Apt::Source[$source]
  }
}

define apt::preferences($ensure="present", $package, $pin, $priority) {
  concatenated_file_part { $name:
    ensure  => $ensure,
    dir    => "/etc/apt/preferences.d",
    content => "# file managed by puppet
Package: $package
Pin: $pin
Pin-Priority: $priority
"
  }
}
