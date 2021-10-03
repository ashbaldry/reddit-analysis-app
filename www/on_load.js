// Top Level Menu
$(window).on('load', function() {
  $('#page_select').dropdown();
  $('#page_select a.item').tab();
});

$(document).on('shiny:connected', function(event) {
  $('#user_menu a.tab-item').tab();
  
  if (window.location.search !== '') {
    $('#page_select').dropdown('set selected', 'user');
    $('#page_select a.item').tab('change tab', 'user');
    $('.login-prompt').hide();
    
    Shiny.initSemanticModal('load_modal'); 
    $('#load_modal').modal({ closable: false }).modal('show');
  } else {
    $('#page_select .signed-in-item').hide();
    $('.login-prompt').show();
  }
  
  $('.info-popup').popup();
  
  $('.subreddit-search-dd').dropdown('setting', 'ignoreDiacritics', true);
  $('.subreddit-search-dd').dropdown('setting', 'fullTextSearch', 'exact');
});
