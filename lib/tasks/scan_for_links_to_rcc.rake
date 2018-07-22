require 'redd'

# bundle exec rake scan_for_links_to_rcc --trace
task :scan_for_links_to_rcc =>  :environment do |t,args|

  # Link.delete_all

  target_name = "CryptoCurrencyTesting"

  reddit = Redd.it(
    user_agent: ENV['reddit_user_agent'],
    client_id:  ENV['reddit_client_id'],
    secret:     ENV['reddit_secret'],
    username:   ENV['reddit_username'],
    password:   ENV['reddit_password']
  )

  remote_subreddit = reddit.subreddit(target_name)

  i = 0
  remote_subreddit.hot(limit: 100).each do |rpost|

    # if i == 1

      selftext_html = rpost.selftext_html
      if destination_a = selftext_html.match(/(?<=Destination:)\s*<a.*<\/a>/)

        if reddit_id = destination_a.to_s.match(/(?<=comments\/)\w+(?=\/)/)

          ap reddit_id.to_s

          source_a = selftext_html.match(/(?<=Source:)\s*<a.*<\/a>/)

          ap "source a:"
          ap source_a.to_s

          source = source_a.to_s.match(/http.*(?=\")/)

          ap "source: #{source.to_s}"

          if post = Post.find_by_reddit_id(reddit_id.to_s)
            ap "post found!"
            unless existing_link = Link.find_by_post_id_and_origin(post.id, source.to_s)
              ap "knows there isn't link"
              Link.create!(
                post_id: post.id,
                origin: source.to_s
              )

              post.linked = true
              post.save

            end
          end

        end
      end

    # end

    i += 1
  end

end
