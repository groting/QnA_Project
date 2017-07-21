$(document).on 'turbolinks:load', ->
  commentables = $("[data-commentable-id][data-commentable-type]")
  return if !commentables

  commentables.each (i) ->
    commentable = $(commentables[i])
    id = commentable.data('commentableId')
    type = commentable.data('commentableType')

    App['comments' + type + id] =
      App.cable.subscriptions.create {
        channel: "CommentsChannel",
        commentable_id:   id,
        commentable_type: type,
      }, {

      received: (data) ->
        comment = $.parseJSON(data)
        commentable.append(JST["comment"]({id: comment.id, body: comment.body}))
      }