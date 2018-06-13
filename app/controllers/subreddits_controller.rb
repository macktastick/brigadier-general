class SubredditsController < ApplicationController

  def index
    @subreddits = Subreddit.all.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @subreddit = Subreddit.find(params[:id])

    @posts = @subreddit.posts.order("remote_created_at DESC").paginate(:page => params[:page], :per_page => 20)
  end

end
