@app.factory 'uploadService', ($http) ->

  root = "http://localhost:4000"

  @run = ->
    # 1. Generate presigned S3 POST
    $http
      .post(root + '/videos/upload', { video: { title: "bar" } })
      .then (resp) -> alert(JSON.stringify(resp))

    # Construct form like:
    # <form action="<%= @post.url %>" method="post" enctype="multipart/form-data">
    #   ...
    # </form>

    # <% @post.fields.each do |name, value| %>
    #   <input type="hidden" name="<%= name %>" value="<%= value %>"/>
    # <% end %>

    # <input type="file" name="file"/>


  return @