$(document).bind 'ajax:success', (e) ->
  json = $.parseJSON(e.detail[2].responseText)
  votable = json.votable
  votable_with_id = json.resource + '-' + votable.id
  if json.vote
    $('#vote-' + votable_with_id).html("You've " + json.vote_value + "d it")
  else
    $('#vote-' + votable_with_id).html('')
  $('#rate-' + votable_with_id).html(votable.rating)
  $('.vote-form#vote-' + votable_with_id).toggle()
  $('#clear-vote-' + votable_with_id).toggle()