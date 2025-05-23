# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end

env :PATH, ENV.fetch('PATH', nil)
env :GEM_HOME, ENV.fetch('GEM_HOME', nil)
env :GEM_PATH, ENV.fetch('GEM_PATH', nil)
env :REDIS_URL, 'redis://localhost:6379/1'

set :environment, 'production'
set :output, 'log/cron.log'

every 1.days do
  runner 'DailyDigestJob.perform_now'
end

every 30.minutes do
  rake 'ts:index'
end

# Learn more: http://github.com/javan/whenever
