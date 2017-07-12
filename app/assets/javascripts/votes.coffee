$(document).bind 'ajax:success', (e) ->
  json = $.parseJSON(e.detail[2].responseText)
  votable = json.votable
  votableWithId = json.resource + '-' + votable.id
  if json.vote
    $('#vote-' + votableWithId).html("You've " + json.vote_value + "d it")
  else
    $('#vote-' + votableWithId).html('')
  $('#rate-' + votableWithId).html(votable.rating)
  $('.vote-form#vote-' + votableWithId).toggle()
  $('#clear-vote-' + votableWithId).toggle()