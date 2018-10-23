# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', (event) ->
  if $('.pagination').length && $('#images').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').html("<row class='text-center'><i class='fa fa-circle-o-notch fa-spin fa-3x fa-fw'></i><span class='sr-only'></span</p>")
        $.getScript(url)
    $(window).scroll()


$(document).on 'turbolinks:load', (event) ->
  $('input:file').change ->
    if $(this).val()
      $('button:submit').attr 'disabled', false
    return
  return

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
