#!/bin/sh

cd /var/www/crowdsync/current
RAILS_ENV=production bundle exec rake cs:notifications:deliver_apn