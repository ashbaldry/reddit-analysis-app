var semanticSearchBinding = new Shiny.InputBinding();

$.extend(semanticSearchBinding, {

  // This initialize input element. It extracts data-value attribute and use that as value.
  initialize: function(el) {
    $(el).search({
    type          : 'category',
    minCharacters : 3,
    onSelect: function(result, response) { $(el).trigger('select'); },
    apiSettings   : {
      onResponse: function(redditResponse) {
        var response = { results : {} };
        
        // translate Reddit API response to work with search
        $.each(redditResponse.data.children, function(index, item) {
          var maxResults = 5;
          
          if(index >= maxResults) {
            return false;
          }
          
          response.results[item.data.url] = {
              name    : item.data.url,
              results : []
            };
          
          // add result to category
          response.results[item.data.url].results.push({
            title       : item.data.url,
            description : item.data.title
          });
        });
        return response;
      },
      url: 'https://www.reddit.com/subreddits/search.json?q={query}&include_over_18=on'
    }
  });
  },

  // This returns a jQuery object with the DOM element.
  find: function(scope) {
    return $(scope).find('.subreddit-search');
  },

  // Returns the ID of the DOM element.
  getId: function(el) {
    return el.id;
  },

  // Given the DOM element for the input, return the value as JSON.
  getValue: function(el) {
    return $(el).search('get value');
  },

  // Given the DOM element for the input, set the value.
  setValue: function(el, value) {
    $(el).search('set exactly', value);
  },

  // Set up the event listeners so that interactions with the
  // input will result in data being sent to server.
  // callback is a function that queues data to be sent to
  // the server.
  subscribe: function(el, callback) {
    $(el).on('select', function () { callback(true); });
  },

  // TODO: Remove the event listeners.
  unsubscribe: function(el) {
    $(el).off('.semanticSearchBinding');
  }
});

Shiny.inputBindings.register(semanticSearchBinding, 'shiny.semanticSearch');