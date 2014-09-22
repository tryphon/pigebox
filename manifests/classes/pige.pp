class pige {
  # from Puppet-Box
  include pige::base

  file { "/etc/pigecontrol": ensure => directory }

  include pige::frontend
  include pige::uploads

  include pige::steto
  include records
}

class pige::frontend {
  include apt::tryphon

  include apache
  include apache::dnssd
  include apache::passenger
  include apache::xsendfile

  include ruby::bundler

  file { "/etc/pigecontrol/database.yml":
    source => "puppet:///files/pigecontrol/database.yml",
    require => Package[pigecontrol]
  }
  file { "/etc/pigecontrol/production.rb":
    source => "puppet:///files/pigecontrol/production.rb",
    require => Package[pigecontrol]
  }

  include apt::tryphon::dev
  package { pigecontrol:
    ensure => '0.19-1+build2232',
    require => [Apt::Source[tryphon-dev], Package[libapache2-mod-passenger], Package[sox]],
  }

  file { "/var/log.model/pigecontrol":
    ensure => directory,
    owner => www-data
  }

  file { "/usr/local/sbin/pige-cron-check-delayed-jobs":
    source => "puppet:///files/pige/pige-cron-check-delayed-jobs",
    mode => 755
  }

  file { "/etc/cron.d/pige-cron-check-delayed-jobs":
    source => "puppet:///files/pige/pige-cron-check-delayed-jobs.cron.d",
    require => Package[cron],
    # It should be default .. but :
    # File found in 664 with this message from cron :
    # INSECURE MODE (group/other writable) (/etc/cron.d/pige)
    mode => 644
  }

  readonly::mount_tmpfs { "/var/lib/pigecontrol": }

  file { "/etc/puppet/manifests/classes/pigecontrol.pp":
    source => "puppet:///files/pigecontrol/manifest.pp"
  }
}

class pige::uploads {
  file { "/etc/puppet/manifests/classes/pige-uploads.pp":
    source => "puppet:///files/pige/manifest-uploads.pp"
  }
  exec { "add-www-data-user-to-ftp-group":
    command => "adduser www-data ftp",
    unless => "grep '^ftp:.*www-data' /etc/group",
    require => [Package[apache], Group[ftp]]
  }
}
