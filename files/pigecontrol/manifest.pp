file { ["/srv/pige/chunks", "/srv/pige/db"]:
  ensure => directory,
  owner => www-data,
  tag => boot,
  require => Exec["storage-mount-pige"]
}

exec { "pige-create-db":
  creates => "/srv/pige/db/production.sqlite3",
  command => "cp /usr/share/pigecontrol/db/production.sqlite3 /srv/pige/db/production.sqlite3",
  require => File["/srv/pige/db"],
  tag => boot
}

exec { "pige-migrate-db":
  command => "/usr/share/pigecontrol/script/migrate",
  cwd => "/usr/share/pigecontrol",
  user => www-data,
  require => Exec["pige-create-db"],
  tag => boot
}
