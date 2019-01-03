# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Display Progress Indicator on Pagination Page Load
$(document).on 'turbolinks:load', (event) ->
  if $('.pagination').length && $('#events').length
    $(window).scroll ->
      url = $('.pagination .next_page').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').html("<row class='text-center'><i class='fa fa-circle-o-notch fa-spin fa-3x fa-fw'></i><span class='sr-only'></span</p>")
        $.getScript(url)
    $(window).scroll()