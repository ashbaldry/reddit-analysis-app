function(input, output, session) {
  # Reddit Reactive
  rr <- reactive(reddit$get_reactive())
  
  #### Log In/Out ####
  # Log In/Log Out Button
  login_button <- reactive({
    rr()
    if (reddit$is_authorized()) {
      shiny::a(id = "logout_button", class = "ui right floated basic orange button action-button", "Sign Out")
    } else {
      shiny::a(class = "ui right floated orange button", href = reddit$get_auth_uri(), "Sign In")
    }
  })
  output$login_button <- shiny::renderUI(login_button())
  
  # When logging out, need to remove access token
  shiny::observeEvent(input$logout_button, {
    reddit$logout()
    shiny::updateQueryString("?", mode = "push")
  })
  
  #### API Token ####
  shiny::observe({
    query <- getQueryString()
    if ("code" %in% names(query)) reddit$get_access_token(query$code)  
  })
  
  #### User Page ####
  callModule(user_page_server, "user", rr = rr)
  
  #### Subreddit Page ####
  selected_sub <- reactive(input$sub_search)
  output$selected_sub <- shiny::renderText(selected_sub())
}