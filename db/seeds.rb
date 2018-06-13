# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

bot_user_configs = HashWithIndifferentAccess.new(YAML.load_file(File.join(Rails.root, 'config', 'bot_users.yml')))[:bot_users]

bot_user_configs.each do |buc|
  BotUser.find_or_create_by(username: buc[:username]) do |bot_user|
    bot_user.email = buc[:email]
    bot_user.password = buc[:password]
  end
end

subreddit_configs = HashWithIndifferentAccess.new(YAML.load_file(File.join(Rails.root, 'config', 'subreddits.yml')))[:subreddits]

subreddit_configs.each do |sc|
  Subreddit.find_or_create_by(name: sc[:name]) do |subreddit|
    subreddit.notify = sc[:notify]
    subreddit.post_monitoring_period = sc[:monitoring_period]
    subreddit.coarse_filter_enabled = sc[:coarse_filter_enabled]
    subreddit.coarse_filter_period = sc[:coarse_filter_period]
    subreddit.coarse_filter_up_vote_threshold = sc[:coarse_filter_up_vote_threshold]
    subreddit.coarse_filter_comment_threshold = sc[:coarse_filter_comment_threshold]
    subreddit.medium_filter_enabled = sc[:medium_filter_enabled]
    subreddit.medium_filter_period = sc[:medium_filter_period]
    subreddit.medium_filter_up_vote_threshold = sc[:medium_filter_up_vote_threshold]
    subreddit.medium_filter_comment_threshold = sc[:medium_filter_comment_threshold]
    subreddit.fine_filter_enabled = sc[:fine_filter_enabled]
    subreddit.fine_filter_period = sc[:fine_filter_period]
    subreddit.fine_filter_up_vote_threshold = sc[:fine_filter_up_vote_threshold]
    subreddit.fine_filter_comment_threshold = sc[:fine_filter_comment_threshold]
  end
end
