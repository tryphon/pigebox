# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"
import "classes/*.pp"

# Directories used by Pige

file { ["/srv/pige/chunks", "/srv/pige/db"]:
  ensure => directory,
  owner => www-data,
  tag => boot,
  require => Exec["storage-mount-pige"]
}

file { "/srv/pige/records":
  ensure => directory,
  owner => pige,
  tag => boot,
  require => Exec["storage-mount-pige"]
}

exec { "pige-create-db":
  creates => "/srv/pige/db/production.sqlite3",
  command => "cp /usr/share/pige/db/production.sqlite3 /srv/pige/db/production.sqlite3",
  require => File["/srv/pige/db"],
  tag => boot
}

exec { "pige-migrate-db":
  command => "/usr/share/pige/script/migrate",
  cwd => "/usr/share/pige",
  user => www-data,
  require => Exec["pige-create-db"],
  tag => boot
}  

file { "/srv/pige/db/production.sqlite3":
  owner => www-data,
  require => Exec["pige-create-db"],
  tag => boot
}

file { "/var/etc/fm/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/fm/fm.conf":
  content => template("/etc/puppet/templates/fm.conf"),
  notify => Service[fm],
  tag => boot
}

service { fm:
  ensure => running,
  hasrestart => true
}
