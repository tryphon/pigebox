import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

include box
include box::audio

include pige

include tuner
include proftpd
