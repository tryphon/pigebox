#
# cron-jobs for pige
#

MAILTO=root
1,16,31,46 * * * *     pige   /usr/share/pige/bin/pige-cron
@reboot                www-data   /usr/share/pige/bin/pige index /srv/pige/records

# FIXME
@reboot                root   /usr/local/bin/amixerconf
