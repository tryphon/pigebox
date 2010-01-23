class puppet {
  # Fix support of START=no
  file { "/etc/init.d/puppet":
    source => "$source_base/files/puppet/puppet.init",
    mode => 755
  }
}
