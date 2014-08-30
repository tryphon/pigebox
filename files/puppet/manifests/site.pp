# Defaults

Exec {
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin"
}

File {
  checksum => md5, owner => root, group => root
}

import "config.pp"
import "classes/*.pp"
