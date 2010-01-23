class kernel {
  include apt::backport
  package { "linux-image-2.6-686":
    ensure => "2.6.30+20~bpo50+1",
    require => Apt::Source["lenny-backport"]
  }
}
