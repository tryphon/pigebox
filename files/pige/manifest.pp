file { "/var/etc/default/go-broadcast":
  content => template("go-broadcast.default"),
  tag => boot,
  notify => Service[go-broadcast]
}

service { go-broadcast:
  ensure => running,
  hasrestart => true
}
