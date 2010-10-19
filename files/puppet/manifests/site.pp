# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"

file { "/var/etc/network":
  ensure => directory,
  tag => boot
}

file { "/var/etc/network/interfaces":
  content => template("/etc/puppet/templates/interfaces"),
  notify => Exec["restart-networking"],
  tag => boot
}

exec { "restart-networking": 
  command => "/sbin/ifdown eth0 && /sbin/ifup eth0",
  refreshonly => true
}

# Directories used by Pige

file { ["/srv/pige/chunks", "/srv/pige/db"]:
  ensure => directory,
  owner => www-data,
  tag => boot,
  require => Exec["storage-mount"]
}

file { "/srv/pige/records":
  ensure => directory,
  owner => pige,
  tag => boot,
  require => Exec["storage-mount"]
}

exec { "pige-create-db":
  creates => "/srv/pige/db/production.sqlite3",
  command => "cp /usr/share/pige/db/production.sqlite3 /srv/pige/db/production.sqlite3",
  require => File["/srv/pige/db"],
  tag => boot
}

exec { "pige-migrate-db":
  command => "./script/migrate",
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

exec { "storage-init":
  command => "/usr/local/sbin/storage init --label=pige > /tmp/storage.log",
  tag => boot
}

exec { "storage-mount":
  command => "mount /srv/pige",
  unless => "mount | grep /srv/pige",
  require => Exec["storage-init"],
  tag => boot
}

exec { "copy-var-model":
  creates => "/var/log/dmesg",
  command => "cp -a /var/log.model/* /var/log/",
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
