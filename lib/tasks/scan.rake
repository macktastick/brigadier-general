# bundle exec rake scan --trace
task :scan =>  :environment do |t,args|

  # setup reddit client
  reddit = Redd.it(
    user_agent: ENV['reddit_user_agent'],
    client_id:  ENV['reddit_client_id'],
    secret:     ENV['reddit_secret'],
    username:   ENV['reddit_username'],
    password:   ENV['reddit_password']
  )

  Subreddit.all.each do |local_subreddit|

    i = 1

    remote_subreddit = reddit.subreddit(local_subreddit.name)

    remote_subreddit.hot(limit: 100).each do |rpost|

      # ap rpost

      unless post = Post.find_by_reddit_id(rpost.id)
        post = Post.create(
          title: rpost.title,
          reddit_id: rpost.id,
          url: "https://reddit.com#{rpost.permalink}",
          status: 'active',
          remote_created_at: rpost.created_utc,
          subreddit_id: local_subreddit.id,
          permalink: rpost.permalink
        )
      end

      age_in_minutes = (Time.now - Time.at(rpost.created_utc))/60

      if post.status == 'active' and age_in_minutes > local_subreddit.post_monitoring_period.andand.to_i
        post.status = 'closed'
        post.save
      end

      if post.status == 'active'

        current_observation = Observation.create(
          post_id: post.id,
          up_votes: rpost.ups,
          down_votes: rpost.downs,
          comment_count: rpost.num_comments
        )

        thresholds_exceded = []

        if post.observations.count > local_subreddit.fine_filter_period

          start_of_period_observation = Observation.where("post_id = ?", post.id).order("created_at DESC")[local_subreddit.fine_filter_period]
          previous_num_up_votes= start_of_period_observation ? start_of_period_observation.up_votes : 0
          up_vote_delta = current_observation.up_votes - previous_num_up_votes

          if (up_vote_delta > local_subreddit.fine_filter_up_vote_threshold.to_i) and (current_observation.comment_count <= local_subreddit.fine_filter_comment_threshold.to_i)
            thresholds_exceded << {
              upvote_threshold_exceded: local_subreddit.fine_filter_up_vote_threshold.to_i,
              upvote_threshold_type: 'fine',
              upvote_threshold_period: "#{local_subreddit.fine_filter_period} minutes",
              comment_threshold: local_subreddit.fine_filter_comment_threshold.to_i
            }
          end

        end

        if post.observations.count > local_subreddit.medium_filter_period
          start_of_period_observation = Observation.where("post_id = ?", post.id).order("created_at DESC")[local_subreddit.medium_filter_period]
          previous_num_up_votes= start_of_period_observation ? start_of_period_observation.up_votes : 0
          up_vote_delta = current_observation.up_votes - previous_num_up_votes

          if up_vote_delta > local_subreddit.medium_filter_up_vote_threshold.to_i and current_observation.comment_count <= local_subreddit.medium_filter_comment_threshold.to_i
            thresholds_exceded << {
              upvote_threshold_exceded: local_subreddit.medium_filter_up_vote_threshold.to_i,
              upvote_threshold_type: 'medium',
              upvote_threshold_period: "#{local_subreddit.medium_filter_period} minutes",
              comment_threshold: local_subreddit.medium_filter_comment_threshold.to_i
            }
          end

        end

        if post.observations.count > local_subreddit.coarse_filter_period
          start_of_period_observation = Observation.where("post_id = ?", post.id).order("created_at DESC")[local_subreddit.coarse_filter_period]
          previous_num_up_votes= start_of_period_observation ? start_of_period_observation.up_votes : 0
          up_vote_delta = current_observation.up_votes - previous_num_up_votes

          if up_vote_delta > local_subreddit.coarse_filter_up_vote_threshold.to_i and current_observation.comment_count <= local_subreddit.coarse_filter_comment_threshold.to_i
            thresholds_exceded << {
              upvote_threshold_exceded: local_subreddit.coarse_filter_up_vote_threshold.to_i,
              upvote_threshold_type: 'coarse',
              upvote_threshold_period: "#{local_subreddit.coarse_filter_period} minutes",
              comment_threshold: local_subreddit.coarse_filter_comment_threshold.to_i
            }
          end

        end

        unless thresholds_exceded.empty?
          alert_text = "This post tripped the following anti-VM filters:"
          thresholds_exceded.each do |tr|
            alert_text += "\n\n* #{tr[:upvote_threshold_type]}"

            existing_alert = Alert.where("post_id = ? and threshold_type = ?", post.id, tr[:upvote_threshold_type]).first
            unless existing_alert

              alert = Alert.create(
                post_id: post.id,
                observation_id: current_observation.id,
                threshold_type: tr[:upvote_threshold_type]
              )
            end
          end

          post.exceded_vm_threshold = true
          post.save

          alert_text += "\n\n\n\nLink to post: #{post.url}"

          alert_text += "\n\n\n\n_This message will only be sent once for this post even though it may violate other filters in the future._"

          alert_text += "\n\n\n\nFor future updates or more detailed information on this post, please visit its monitoring page: http://brigadier-general.org/posts/#{post.id}"


            user = reddit.user('brigadier-general')
            subject = "Irregular Voting Activity"



            if local_subreddit.notify and !post.notified?
              if subreddit_to_notify = reddit.subreddit(local_subreddit.notify)
                # Pause modmail notifications per /u/PhantomMod's request
                # subreddit_to_notify.send_message(subject: subject, text: alert_text)
                subreddit_to_notify.submit(subject, text: alert_text)
              end
              post.notified = true
              post.save
            end

        end # unless thresholds_exceded.empty?

      end # if post.status == 'active'
    end # subreddit.hot(limit: 100).each do |rpost|
    i += 1

  end # Subreddit.all.each do |subreddit|

end # task
