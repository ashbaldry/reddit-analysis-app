function(input, output, session) {
  rV <- shiny::reactiveValues(auth_code = NULL, access_token = NULL)
  
  #### Login ####
  # Log In/Log Out Button
  login_button <- reactive({
    if (!is.null(rV$access_token)) {
      shiny::a(id = "logout_button", class = "ui right floated basic orange button action-button", "Sign Out")
    } else {
      shiny::a(class = "ui right floated orange button", href = auth_reddit_uri(client_id, redirect_uri), "Sign In")
    }
  })
  output$login_button <- shiny::renderUI(login_button())
  
  # When logging out, need to remove access token
  shiny::observeEvent(input$logout_button, {
    rV$auth_code <- NULL
    rV$access_token <- NULL
    shiny::updateQueryString("?", mode = "push")
  })
  
  #### API Token ####
  shiny::observe({
    query_string <- shiny::parseQueryString(session$clientData$url_search)
    if ("code" %in% names(query_string)) {
      if (!identical(rV$auth_code, query_string$code)) {
        rV$auth_code <- query_string$code
        result <- access_reddit_uri(query_string$code, redirect_uri, client_id, client_secret)
        rV$access_token <- result$access_token
      }
    }
  })
  
  #### Subreddit ####
  # Temporary to just pull the user name of the person logged in
  reddit_user <- shiny::reactive({
    if (is.null(rV$access_token)) return("Not logged in")
    
    result <- httr::GET(
      "https://oauth.reddit.com/api/v1/me",
      httr::add_headers(Authorization = paste("bearer", rV$access_token)),
      httr::user_agent("httr")
    )
    
    access_token <<- rV$access_token
    user_info <- httr::content(result)
    user_info$name
  })
  
  output$reddit_user <- shiny::renderText(reddit_user())
  
  selected_sub <- reactive(input$sub_search)
  output$selected_sub <- shiny::renderText(selected_sub())
}