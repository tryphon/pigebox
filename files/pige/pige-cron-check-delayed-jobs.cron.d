#
# cron-jobs for pige
#

MAILTO=root
*/5 * * * *            root   /usr/local/sbin/pige-cron-check-delayed-jobs
