function(input, output, session) {
  # Reddit Reactive
  reddit <<- Reddit$new(client_id, client_secret, redirect_uri)
  rr <- reactive(reddit$get_reactive())
  
  #### Log In/Out ####
  # Log In/Log Out Button
  login_button <- reactive({
      a(class = "ui right floated orange button", href = reddit$get_auth_uri(), "Sign In")
  })
  
  signed_in_settings <- reactive({
    shiny.semantic::dropdown_menu(
      name = "user_menu",
      class = "right-float",
      div(
        class = "ui grid",
        div(
          class = "thirteen wide column",
          div(
            class = "ui tiny items user-header-item",
            div(
              class = "item",
              div(
                class = "ui mini image",
                # tags$img(class = "banner-avatar-image", src = reddit$user_info$icon_img)
                tags$img(src = reddit$user_info$icon_img)
              ),
              div(
                class = "middle aligned content",
                div(class = "header", reddit$user_name),
                div(class = "meta", reddit_karma_icon("banner-karma-icon"), paste(reddit$user_info$total_karma, "karma"))
              )
            )
          )
        ),
        div(
          class = "two wide column",
          shiny.semantic::icon(class = "dropdown")
        )
      ),
      shiny.semantic::menu(
        class = "fluid",
        shiny.semantic::menu_item(
          id = "logout_button", class = "action-button", shiny.semantic::icon("sign out alternate"), "Log Out"
        )
      )
    )
  })
  
  output$login_button <- renderUI({
    rr()
    if (!reddit$is_authorized()) {
      login_button()
    } else {
      signed_in_settings()
    }
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
  
  #### User Page ####
  callModule(user_page_server, "user", reddit = reddit, rr = rr)
  
  #### Subreddit Page ####
  selected_sub <- reactive(input$sub_search)
  output$selected_sub <- renderText(selected_sub())
}