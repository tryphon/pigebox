file { "/srv/pige/uploads":
  ensure => directory,
  owner => ftp,
  group => ftp,
  mode => 2775,
  tag => boot,
  require => Exec["storage-mount-pige"]
}
