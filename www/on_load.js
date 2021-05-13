// Top Level Menu
$(window).on('load', function() {
  $('#page_select').dropdown();
  $('#page_select a.item').tab();
});

$(document).on('shiny:connected', function(event) {
  if (window.location.search !== '') {
    $('.dropdown_name_user_menu .mobile-item').tab();
    $('#page_select').dropdown('set selected', 'user');
    $('#page_select a.item').tab('change tab', 'user');
    $('.login-prompt').hide();
  } else {
    $('#page_select .signed-in-item').hide();
    $('.login-prompt').show();
  }
  
  $('.subreddit-search-dd').dropdown('setting', 'ignoreDiacritics', true);
  $('.subreddit-search-dd').dropdown('setting', 'fullTextSearch', 'exact');
});
