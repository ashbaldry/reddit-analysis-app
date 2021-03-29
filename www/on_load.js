// Top Level Menu
$(window).on('load', function() {
  $('#page_select').dropdown();
  $('#page_select a.item').tab();
  if (window.location.search !== '') {
    $('#page_select').dropdown('set selected', 'user');
    $('#page_select a.item').tab('change tab', 'user');
  }
})