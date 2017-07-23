$(document).on 'turbolinks:load', ->
  App.cable.subscriptions.create "AnswersChannel", 
      connected: ->
        @follow()

      follow: ->
        questionId = $(".question").data("id")
        @perform('follow', question_id: questionId)

      received: (data) ->
        json = $.parseJSON(data)
        answer = json.answer
        question = json.question
        $('.answers-list').append(JST["answer"]({answer: answer, question: question}))