class munin-node::local inherits munin-node {
  file { "/etc/munin/plugins/df":
    ensure => "/usr/share/munin/plugins/df",
    require => Package["munin-node"]
  }
}
