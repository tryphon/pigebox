#
# cron-jobs for pige
#

MAILTO=root
1,16,31,46 * * * *     pige   /usr/share/pige/bin/pige-cron

# FIXME
@reboot                root   /usr/local/bin/amixerconf
