# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Display Progress Indicator on Pagination Page Load
$(document).on 'turbolinks:load', (event) ->
  if $('.pagination').length && $('#images').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').html("<row class='text-center'><i class='fa fa-circle-o-notch fa-spin fa-3x fa-fw'></i><span class='sr-only'></span</p>")
        $.getScript(url)
    $(window).scroll()

# Disable Upload Button
$(document).on 'turbolinks:load', (event) ->
  $('input:file').change ->
    if $(this).val()
      $('button:submit').attr 'disabled', false
    return
  return

# Count Comment Characters
$(document).on 'turbolinks:load', (event) ->
  updateCount = ->
    cs = $(this).val().length
    $('#comment-char-count').text cs + '/500'
    if cs > 500
      $('#comment-char-count').removeClass('text-muted');
      $('#comment-char-count').addClass('text-danger');
      $('#comment-submit').addClass('disabled');
      $('#comment-submit').attr 'disabled', true
    else if cs < 10
      $('#comment-char-count').removeClass('text-danger');
      $('#comment-char-count').addClass('text-muted');    
      $('#comment-submit').removeClass('disabled');
      $('#comment-submit').attr 'disabled', true
    else
      $('#comment-char-count').removeClass('text-danger');
      $('#comment-char-count').addClass('text-muted');    
      $('#comment-submit').removeClass('disabled');
      $('#comment-submit').attr 'disabled', false
    return
  $('#comment-text').keyup updateCount
  $('#comment-text').keydown updateCount

# Clear Comments on Modal Close
$(document).on 'turbolinks:load', (event) ->
  clearComments = ->
    $('#comment-text').val('');
    $('#comment-char-count').text '0/500'
    $('#comment-char-count').removeClass('text-danger');
    $('#comment-char-count').addClass('text-muted');   
    return

  $('#comment-cancel').click clearComments
  $('#comment-dismiss').click clearComments
  $('#commentModal').on 'hide.bs.modal', ->
    clearComments
    return

# Image Upload Preview
ready_post = ->
  # Display the image to be uploaded.
  $('#image_image_image').on 'change', (e) ->
    readURL(this);

  readURL = (input) ->
    if (input.files && input.files[0])
      reader = new FileReader()

    reader.onload = (e) ->
      $('.image_to_upload').attr('src', e.target.result).removeClass('hidden');
      $swap = $('.swap')
      if $swap
        $swap.removeClass('hidden')

    reader.readAsDataURL(input.files[0]);

$(document).ready(ready_post)
$(document).on('turbolinks:load', ready_post)
