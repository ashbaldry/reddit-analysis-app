function(input, output, session) {
  # Reddit Reactive
  reddit <<- Reddit$new(client_id, client_secret, redirect_uri)
  rr <- reactive(reddit$get_reactive())
  
  #### Log In/Out ####
  login_button <- reactive({
      a(class = "ui right floated orange button", href = reddit$get_auth_uri(), "Sign In")
  })
  
  signed_in_settings <- reactive(signed_in_settings())
  
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
  callModule(comments_page_server, "comments", reddit = reddit, rr = rr)
  
  
  #### Subreddit Page ####
  selected_sub <- reactive(input$sub_search)
  output$selected_sub <- renderText(selected_sub())
}