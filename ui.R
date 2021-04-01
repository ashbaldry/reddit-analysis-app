shiny.semantic::semanticPage(
  title = "Reddit Analysis", 
  margin = 0,
  
  #### Settings ####
  tags$head(
    tags$link(rel = "preconnect", href = "https://fonts.gstatic.com"),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,400;0,700;1,100&display=swap"
    ),
    tags$script(src = "sub_search.js"),
    tags$script(src = "on_load.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "reddit-style.css"),
    tags$link(rel = "icon", href = "https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-144x144.png")
  ),
  
  #### Header ####
  tags$header(
    menu(
      class = "top attached borderless",
      menu_item(
        href = "https://www.reddit.com", target = "_blank",
        div(class = "ui tiny image", tags$img(src = "reddit_logo.png"))
      ),
      
      div(
        class = "item",
        div(
          class = "ui selection dropdown", id = "page_select",
          div(class = "text", tags$i(class = "home icon"), "Home"), 
          tags$i(class = "dropdown icon"),
          div(
            class = "menu",
            a(class = "active item", `data-tab` = "home", `data-value` = "home", tags$i(class = "home icon"), "Home"),
            a(class = "item", `data-tab` = "user", `data-value` = "user", tags$i(class = "reddit alien icon"), "User"),
            a(class = "item", `data-tab` = "subreddit", `data-value` = "subreddit", tags$i(class = "list icon"), "Subreddit")
          )
        )
      ),
      
      menu_item(
        item_feature = "ui right",
        uiOutput("login_button", inline = TRUE)
      )
    )
  ),
  
  tags$main(
    div(
      class = "ui tab basic segment active", `data-tab` = "home",
      h2("Welcome!"),
      p("This app is used to take a look into historical Reddit posts and behaviour..."),
      p("To get your results, please sign in"),
      a(class = "ui inverted orange button", 
        href = auth_reddit_uri(client_id, redirect_uri, c("identity", "read", "history")), 
        "Sign In"
      )
    ),
    div(
      class = "ui tab basic segment", `data-tab` = "user",
      user_page_ui("user")
    ),
    div(
      class = "ui tab basic segment", `data-tab` = "subreddit",
      sub_page
    )
  )
)
