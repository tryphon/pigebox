import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

$box_name="pigebox"
include box

include box::audio
include box::storage

include pige
