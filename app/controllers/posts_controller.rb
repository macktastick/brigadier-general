class PostsController < ApplicationController

  def index
  #  @posts = Post.all.includes(:alerts)
    # @posts = Post.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.json { render json: PostDatatable.new(view_context,
          {
            subreddit_id: params[:subreddit_id]
           })}
    end
  end

  def show
    @post = Post.find(params[:id])

    @observations = @post.observations.order("created_at DESC").paginate(:page => params[:page], :per_page => 60)

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text=>"Up votes / minutes after publishing"})
      f.options[:colors] = ['#3498DB', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
      f.options[:xAxis][:categories] = @post.observations.order("created_at ASC").map{|o| ((o.created_at - @post.created_at).to_f/60).ceil }

      data  = @post.observations.order("created_at ASC").map{|o| o.up_votes}

      f.series(
                 data: data,
                 type: 'area',
                 lineColor: '#3498DB',
                 color: '#3498DB',
                 fillOpacity: 0.5,
                 name: 'Up votes',
                 marker: {
                     enabled: false
                 },
                 threshold: nil
             )
    end


  end


  # TODO I don't think this is working anymore... 6/12/2018
  def show_from_reddit_id
    @post = Post.find_by_reddit_id(params[:reddit_id])

    @observations = @post.observations.order("created_at DESC").paginate(:page => params[:page], :per_page => 60)

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title({ :text=>"Up votes / minutes after publishing"})
      f.options[:colors] = ['#3498DB', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
      f.options[:xAxis][:categories] = @post.observations.order("created_at ASC").map{|o| ((o.created_at - @post.created_at).to_f/60).ceil }

      data  = @post.observations.order("created_at ASC").map{|o| o.up_votes}

      f.series(
                 data: data,
                 type: 'area',
                 lineColor: '#3498DB',
                 color: '#3498DB',
                 fillOpacity: 0.5,
                 name: 'Up votes',
                 marker: {
                     enabled: false
                 },
                 threshold: nil
             )
    end

    render :show
  end

end
