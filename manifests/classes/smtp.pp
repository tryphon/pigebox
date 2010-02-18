class smtp {
  # disable exim4 installed by default
  package { "exim4-daemon-light": ensure => purged }

  readonly::mount_tmpfs { "/var/lib/exim4": }
}
