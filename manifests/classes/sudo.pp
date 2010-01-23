class sudo {
  package { sudo: }

  file { "/etc/sudoers":
    source => "$source_base/files/sudo/sudoers",
    mode => 0440,
    require => Package[sudo]
  }

}
