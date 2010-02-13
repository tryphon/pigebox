#
# cron-jobs for puppet
#

MAILTO=root
14 * * * *      root     /usr/local/sbin/launch-puppet
@reboot         root     /usr/local/sbin/launch-puppet

