# Retrieved from module puppet-apt

class apt {
  exec { "apt-get_update":
    command => "apt-get update",
    refreshonly => true
  }
  Package {
    require => Exec["apt-get_update"]
  }
  concatenated_file { "/etc/apt/preferences":
    dir => "/etc/apt/preferences.d",
    before  => Exec["apt-get_update"]
  }
}

class apt::tryphon {
  apt::source { tryphon: 
    key => "C6ADBBD5"
  }
}

class apt::backport {
  apt::source { lenny-backports: 
    key => "16BA136C"
  }
}
