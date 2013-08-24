class pige {
  file { "/etc/pige": ensure => directory }
  file { [
    "/usr/share/pige",
    "/usr/share/pige/tasks",
    "/usr/share/pige/bin"
    ]:
    ensure => directory
  }

  file { "/usr/share/pige/tasks/pige.rake":
    source => "$source_base/files/pige/pige.rake"
  }

  user { pige:
    groups => [audio]
  }

  include sox
  include pige::go-broadcast
  include pige::crond
  include pige::lib
  include pige::frontend

  include pige::steto
  include records
}

class pige::go-broadcast {
  include go-broadcast

  file { "/etc/default/go-broadcast":
    source => "puppet:///files/pige/go-broadcast.default"
  }
}

class pige::alsabackup {
  include apt::tryphon

  package { alsa-backup:
    ensure => "0.12-1",
    require => Apt::Source[tryphon]
  }

  # TODO fix alsa-backup libraries names
  file {
    "/usr/lib/libasound.so": ensure => "/usr/lib/libasound.so.2.0.0";
    "/usr/lib/libsndfile.so": ensure => "/usr/lib/libsndfile.so.1.0.21"
  }

  file { "/etc/default/alsa-backup":
    source => "$source_base/files/pige/alsa.backup.default"
  }
  file { "/etc/pige/alsa.backup.config":
    source => "$source_base/files/pige/alsa.backup.config"
  }
}

class pige::lib {
  # FIXME manually install syslog_logger
  # TODO use/create a syslog_logger debian package
  file { "/usr/share/pige/lib/syslog_logger.rb":
    source => "$source_base/files/pige/syslog_logger.rb";
    "/usr/share/pige/lib" : ensure => directory
  }
}

class pige::crond {
  include cron # ::cron not supported by this puppet version
  package { rake: }

  file { "/usr/share/pige/bin/pige-cron":
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

  file { "/etc/pige/database.yml":
    source => "$source_base/files/pige/database.yml",
    require => Package[pigecontrol]
  }
  file { "/etc/pige/production.rb":
    source => "$source_base/files/pige/production.rb",
    require => Package[pigecontrol]
  }
  package { pigecontrol:
    ensure => "0.16-1",
    require => [Apt::Source[tryphon], Package[libapache2-mod-passenger], Package[sox]],
  }

  file { "/var/log.model/pige":
    ensure => directory,
    owner => www-data
  }
}

class pige::steto {
  steto::conf { pige:
    source => "puppet:///files/pige/steto.rb"
  }
  include sox::ruby
  include pige::gem
}

class pige::gem {
  ruby::gem { pige:
    ensure => "0.0.2",
    require => Package[libtagc0-dev, libtag1-dev]
  }
  package { [libtagc0-dev, libtag1-dev]: }
}
