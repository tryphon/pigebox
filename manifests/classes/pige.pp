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
  include pige::lib
  include pige::frontend

  include pige::steto
  include records
}

class pige::lib {
  # FIXME manually install syslog_logger
  # TODO use/create a syslog_logger debian package
  file { "/usr/share/pigecontrol/lib/syslog_logger.rb":
    source => "$source_base/files/pige/syslog_logger.rb";
    "/usr/share/pigecontrol/lib" : ensure => directory
  }
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
    require => Package[cron]
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
  package { pigecontrol:
    ensure => "0.17-2",
    require => [Apt::Source[tryphon], Package[libapache2-mod-passenger], Package[sox]],
  }

  file { "/var/log.model/pige":
    ensure => directory,
    owner => www-data
  }
}
