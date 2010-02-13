# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

# Directories used by Pige

file { ["/srv/pige/chunks", "/srv/pige/db"]:
  ensure => directory,
  owner => www-data
}

file { "/srv/pige/records":
  ensure => directory,
  owner => pige
}

exec { "pige-create-db":
  creates => "/srv/pige/db/production.sqlite3",
  command => "cp /usr/share/pige/db/production.sqlite3 /srv/pige/db/production.sqlite3",
  require => File["/srv/pige/db"]
}

file { "/srv/pige/db/production.sqlite3":
  owner => www-data,
  require => Exec["pige-create-db"]
}
