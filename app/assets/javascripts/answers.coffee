# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.best-answer-bage').closest('div').prependTo('.answers-list')
#
$(document).on('turbolinks:load', ready)

$(document).on('click', '.edit-answer-link', (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  $('form#edit-answer-' + answer_id).show()
)