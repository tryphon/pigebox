class alsa::common {

  package { alsa-utils: }
	
  readonly::mount_tmpfs { "/var/lib/alsa": }

}
