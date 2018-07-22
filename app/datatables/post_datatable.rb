class PostDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :post_path

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      reddit_id: { source: "Post.reddit_id", cond: :like, searchable: true, orderable: true },
      title:  { source: "Post.title",  cond: :like, searchable: true, orderable: true },
      notified:  { source: "Post.notified",  cond: :eq, searchable: false, orderable: true },
      exceded_vm_threshold:  { source: "Post.exceded_vm_threshold",  cond: :eq, searchable: false, orderable: true },
      linked:  { source: "Post.linked",  cond: :eq, searchable: false, orderable: true },
      created_at:  { source: "Post.created_at",  searchable: false, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        reddit_id: record.reddit_id,
        title: link_to(record.title, post_path(record)),
        notified: record.notified,
        exceded_vm_threshold: record.exceded_vm_threshold,
        linked: record.linked,
        created_at: record.created_at

      }
    end
  end

  private

  def subreddit_id
    @subreddit_id ||= options[:subreddit_id]
  end

  def get_raw_records
    # insert query here
    Post.where("subreddit_id = ?", subreddit_id)
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
