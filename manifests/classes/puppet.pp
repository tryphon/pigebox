class puppet {
  include cron

  # Fix support of START=no
  file { "/etc/init.d/puppet":
    source => "$source_base/files/puppet/puppet.init",
    mode => 755
  }

  file { "/etc/puppet/site.pp":
    source => "$source_base/files/puppet/site.pp"
  }

  file { "/usr/local/sbin/launch-puppet":
    source => "$source_base/files/puppet/launch-puppet",
    mode => 755
  }

  file { "/boot/config.pp":
    ensure => present
  }

  file { "/etc/cron.d/puppet":
    source => "$source_base/files/puppet/puppet.cron.d",
    require => Package[cron]
  }

  readonly::mount_tmpfs { "/var/lib/puppet": }
}
