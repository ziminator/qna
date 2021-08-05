# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  questionsList = $(".questions")
  questionId = $('.question').data('id')

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform('follow')
    ,

    received: (data) ->
      questionData = JST['templates/question']({
        question: data.question
      })

      questionsList.append questionData
  })
