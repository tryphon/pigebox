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
  include pige::alsabackup
  include pige::crond
  include pige::storage
  include pige::lib
  include pige::frontend
}

class pige::alsabackup {
  include apt::tryphon

  package { alsa-backup: 
    ensure => "0.10-1lenny1",
    require => Apt::Source[tryphon]
  }

  # TODO fix alsa-backup libraries names
  file { 
    "/usr/lib/libasound.so": ensure => "/usr/lib/libasound.so.2.0.0";
    "/usr/lib/libsndfile.so": ensure => "/usr/lib/libsndfile.so.1.0.17"
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
    source => "$source_base/files/pige/pige-cron"
  }

  file { "/etc/cron.d/pige":
    source => "$source_base/files/pige/pige.cron.d",
    require => Package[cron]
  }
}

class pige::storage {
  file { "/srv/pige":
    ensure => directory
  }

  line { "fstab-pige":
    file => "/etc/fstab",
    line => "LABEL=pige /srv/pige ext3 defaults 0 0"
  }
}

class pige::frontend {
  include apt::tryphon

  include apache
  include apache::dnssd
  include apache::passenger

  file { "/etc/pige/database.yml":
    source => "$source_base/files/pige/database.yml",
    require => Package[pige]
  }
  file { "/etc/pige/production.rb":
    source => "$source_base/files/pige/production.rb",
    require => Package[pige]
  }
  package { pige: 
    ensure => "0.4-1lenny1",
    require => [Apt::Source[tryphon], Package[libapache2-mod-passenger]]
  }
  apt::source::pin { libtag1c2a:
    source => "lenny-backports"
  }
  
  file { "/var/log.model/pige": 
    ensure => directory, 
    owner => www-data
  }
}
