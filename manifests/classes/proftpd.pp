class proftpd {
  package { proftpd-basic:
    alias => proftpd
  }

  file { "/etc/proftpd/proftpd.conf":
    source => "puppet:///files/proftpd/proftpd.conf",
    require => Package[proftpd]
  }

  user { ftp:
    shell => "/bin/sh"
  }
}
