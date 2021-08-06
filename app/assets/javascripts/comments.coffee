$ ->
  commentForm = $('.create-comment')
  comments = $('.comments')
  commentsBlock = $('.comment-block')
  questionId = $(".question").data("id")

  commentForm.on 'ajax:success', (e) ->
    xhr = e.detail[0]
    resourceName = xhr['commentable_type'].toLowerCase()
    resourceId = xhr['commentable_id']
    resourceContent = xhr['body']
    question = ".#{resourceName}-#{resourceId}"
    $("#{question} .comment-block .comments").append('<div class="comment"><p>'+ resourceContent + '</p></div>')

  commentForm.on 'ajax:error', (e) ->
    errors = e.detail[0]
    $.each errors, (index, value) ->
      $('.comment-errors').append('<p>' + index + ' ' + value + '<p>')


  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow', id: questionId
    ,

    received: (data) ->
      if gon.user_id != data.comment.author_id
        addComment data.comment.commentable_id, data.comment.body
  })

  addComment = (id, data) ->
    commentsList = $("#comments-list-#{id}")
    commentData = JST["templates/comment"]({body: data})
    commentsList.append commentData
