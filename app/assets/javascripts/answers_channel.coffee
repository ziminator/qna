# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  questionId = $(".question").data("id")
  answersList = $(".answers")

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: questionId
    ,

    received: (data) ->
      if gon.user_id != data.answer.author_id
        answerData = JST['templates/answer']({
          answer: data.answer
          links: data.links
          files: data.files
        })

        answersList.append answerData
  })
