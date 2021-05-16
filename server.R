function(input, output, session) {
  # Reddit Reactive
  reddit <- Reddit$new(client_id, client_secret, redirect_uri)
  rr <- reactive(reddit$get_reactive())
  
  observeEvent(rr(), if (reddit$is_authorized()) shiny.semantic::show_modal("load_modal"), priority = 100)
  observeEvent(rr(), {
    if (reddit$is_authorized()) {
      promises::promise_all(
        promises::future_promise(reddit$get_user_info()),
        promises::future_promise(reddit$get_user_upvotes()),
        promises::future_promise(reddit$get_user_downvotes()),
        promises::future_promise(reddit$get_user_posts()),
        promises::future_promise(reddit$get_user_comments())
      ) %>%
        promises::then(function(lst) shiny.semantic::hide_modal("load_modal"))
    }
  }, priority = 50)
  
  #### Home Page ####
  callModule(user_home_server, "home")
  
  #### Log In/Out ####
  login_button <- reactive({
      a(class = "ui right floated orange button", href = reddit$get_auth_uri(), "Sign In")
  })
  
  output$settings_dropdown <- renderUI({
    rr()
    if (!reddit$is_authorized()) signed_out_dropdown(reddit) else signed_in_dropdown(reddit)
  })
  
  # When logging out, need to remove access token
  observeEvent(input$logout_button, {
    reddit$logout()
    updateQueryString("?", mode = "push")
  })
  
  #### API Token ####
  observe({
    query <- getQueryString()
    if ("code" %in% names(query)) reddit$get_access_token(query$code)  
  })
  
  #### Content Pages ####
  callModule(user_page_server, "user", reddit = reddit, rr = rr)
  callModule(votes_page_server, "votes", reddit = reddit, rr = rr)
  callModule(comments_page_server, "posts", reddit = reddit, rr = rr, type = "Posts", text_col = "title")
  callModule(comments_page_server, "comments", reddit = reddit, rr = rr, type = "Comments", text_col = "body")
  
  #### Subreddit Page ####
  selected_sub <- reactive(input$sub_search)
  output$selected_sub <- renderText(selected_sub())
}