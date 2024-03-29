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
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']

job_type :rbenv_rake, %Q{export PATH=/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && bundle exec rake RAILS_ENV=production :task --silent :output }

every 1.minutes do # 1.minute 1.day 1.week 1.month 1.year is also supported
  rbenv_rake "scan"
end

every 3.minutes do # 1.minute 1.day 1.week 1.month 1.year is also supported
  rbenv_rake "scan_for_links_to_rcc"
end
