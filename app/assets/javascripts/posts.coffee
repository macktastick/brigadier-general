$ ->
  $('#posts-table').dataTable
    processing: true
    serverSide: true
    ajax:
      url: $('#posts-table').data('source')
      type: 'POST'
    pagingType: 'full_numbers'
    order: [[3, 'desc']]
    columns: [
      {data: 'reddit_id'}
      {data: 'title'}
      {data: 'notified'}
      {data: 'created_at'}
    ]
    # pagingType is optional, if you want full pagination controls.
    # Check dataTables documentation to learn more about
    # available options.
