# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  source = new EventSource('/stream')
  source.addEventListener 'message', (e) ->
    content = $.parseJSON(e.data)
    $('#container').append("[#{content.timestamp}] <strong>#{content.user}</strong>: #{content.message}<br />")

  $(document).keypress (e) ->
    if e.keyCode == 13
      $('form').submit()
      $('form')[0].reset()
      false
