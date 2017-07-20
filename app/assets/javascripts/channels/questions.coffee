App.cable.subscriptions.create "QuestionsChannel", 
    connected: ->
      @follow()

    follow: ->
      @perform 'follow'

    received: (data) ->
      question = $.parseJSON(data)
      title = question.title
      url = "/questions/" + question.id
      $('.questions-list').append(JST["question"]({title: title, url: url}))