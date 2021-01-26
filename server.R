function(input, output, session) {
  auth_code <- reactiveVal(NULL)
  access_token <- reactiveVal(NULL)
  
  #### Login ####
  # Log In/Log Out Button
  login_button <- reactive({
    if (!is.null(access_token())) {
      shiny::a(id = "logout_button", class = "ui right floated basic orange button action-button", "Sign Out")
    } else {
      shiny::a(class = "ui right floated orange button", href = auth_reddit_uri(client_id, redirect_uri), "Sign In")
    }
  })
  output$login_button <- shiny::renderUI(login_button())
  
  # When logging out, need to remove access token
  shiny::observeEvent(input$logout_button, {
    auth_code(NULL)
    access_token(NULL)
    shiny::updateQueryString("?", mode = "push")
  })
  
  #### API Token ####
  shiny::observe({
    query_string <- shiny::parseQueryString(session$clientData$url_search)
    if ("code" %in% names(query_string)) {
      if (!identical(auth_code(), query_string$code)) {
        auth_code(query_string$code)
        result <- access_reddit_uri(query_string$code, redirect_uri, client_id, client_secret)
        access_token(paste("bearer", result$access_token))
      }
    }
  })
  
  #### User Page ####
  callModule(user_page_server, "user", access_token = access_token)
  
  selected_sub <- reactive(input$sub_search)
  output$selected_sub <- shiny::renderText(selected_sub())
}