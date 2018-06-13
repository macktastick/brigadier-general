require 'watir'

# bundle exec rake brigade --trace
task :brigade =>  :environment do |t,args|

  target_url = "https://www.reddit.com/r/macktastick/comments/8ccl3y/brigadiergeneral_antivm_bot_test_44/"

  bot_users = BotUser.all

  0.upto(10) do |i|

    # existing_vote = BotVote.where(post_id: post.id, bot_user_id: bot_user.id).first

    # unless existing_vote

    bot_user = bot_users[i]

    browser = Watir::Browser.new
    browser.goto 'reddit.com'
    browser.text_field(name: "user").set bot_user.username
    browser.text_field(name: "passwd").set bot_user.password
    #browser.button(type: 'submit').click
    browser.element(:xpath => "//*[@id=\"login_login-main\"]/div[4]/button").click
    #wait(10)
    browser.text_field(name: 'user').wait_while_present
    browser.goto target_url

    # if targeting 'normal' sub
    browser.divs(:class => 'up').each do |down|
      down.click
    end

    # bot_vote = BotVote.create(post_id: post.id, bot_user_id: bot_user.id)

    puts browser.title
    browser.close if browser
    # end
  end


    # => 'Documentation – Watir Project...'


#  browser.close

end
