class pige {
  # from Puppet-Box
  include pige::base

  file { "/etc/pigecontrol": ensure => directory }
  file { [
    "/usr/share/pigecontrol",
    "/usr/share/pigecontrol/tasks",
    "/usr/share/pigecontrol/bin"
    ]:
    ensure => directory
  }

  file { "/usr/share/pigecontrol/tasks/pige.rake":
    source => "$source_base/files/pige/pige.rake"
  }

  include sox
  include pige::crond
  include pige::frontend
  include pige::uploads

  include pige::steto
  include records
}

class pige::crond {
  include cron # ::cron not supported by this puppet version
  package { rake: }

  file { "/usr/share/pigecontrol/bin/pige-cron":
    source => "$source_base/files/pige/pige-cron",
    mode => 755
  }

  file { "/usr/local/sbin/pige-cron-check-delayed-jobs":
    source => "$source_base/files/pige/pige-cron-check-delayed-jobs",
    mode => 755
  }

  file { "/etc/cron.d/pige":
    source => "$source_base/files/pige/pige.cron.d",
    require => Package[cron],
    # It should be default .. but :
    # File found in 664 with this message from cron :
    # INSECURE MODE (group/other writable) (/etc/cron.d/pige)
    mode => 644
  }
}

class pige::frontend {
  include apt::tryphon

  include apache
  include apache::dnssd
  include apache::passenger
  include apache::xsendfile

  include ruby::bundler

  file { "/etc/pigecontrol/database.yml":
    source => "$source_base/files/pige/database.yml",
    require => Package[pigecontrol]
  }
  file { "/etc/pigecontrol/production.rb":
    source => "$source_base/files/pige/production.rb",
    require => Package[pigecontrol]
  }

  include apt::tryphon::dev
  package { pigecontrol:
    ensure => '0.19-1+build2223',
    require => [Apt::Source[tryphon-dev], Package[libapache2-mod-passenger], Package[sox]],
  }

  file { "/var/log.model/pige":
    ensure => directory,
    owner => www-data
  }
}

class pige::uploads {
  file { "/etc/puppet/manifests/classes/pige-uploads.pp":
    source => "puppet:///files/pige/manifest-uploads.pp"
  }
}
