#
# cron-jobs for pige
#

MAILTO=root
1,16,31,46 * * * *     pige   /usr/share/pigecontrol/bin/pige-cron
*/5 * * * *            root   /usr/local/sbin/pige-cron-check-delayed-jobs

# FIXME
@reboot                root   /usr/local/bin/amixerconf
