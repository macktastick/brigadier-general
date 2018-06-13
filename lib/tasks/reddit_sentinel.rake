require 'redd'

# bundle exec rake reddit_sentinel --trace
task :reddit_sentinel =>  :environment do |t,args|
  session = Redd.it(
    user_agent: ENV['reddit_user_agent'],
    client_id:  ENV['reddit_client_id'],
    secret:     ENV['reddit_secret'],
    username:   ENV['reddit_username'],
    password:   ENV['reddit_password']
  )

  session.subreddit('all').comment_stream do |comment|

    str = comment.body.downcase
    targets = Subreddit.all.map{|s| "reddit.com/r/#{s.name}"}

    if targets.any? { |word| str.include?(word) }
      ap comment
      ap comment.body
      reddit_post_id_regex = /(?<=\/comments\/)\w+(?=\/)/
      reddit_post_id = comment.body.downcase.match(reddit_post_id_regex).andand.to_s
      ap "REDDIT POST ID: #{reddit_post_id}"

      if reddit_post_id


        if post = Post.find_by_reddit_id(reddit_post_id)
          Link.create(
            post_id: post.id,
            origin: comment.link_permalink
          )
        end

      end
    end
  end
end
