shiny.semantic::semanticPage(
  title = "Reddit Profile Analyzer", 
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
        div(id = "reddit_logo", class = "ui tiny image", tags$img(src = "reddit_logo.png"), alt = "Reddit logo")
      ),
      
      div(
        class = "item",
        div(
          class = "ui selection dropdown", id = "page_select",
          div(class = "text", shiny.semantic::icon("blue home"), "Home"), 
          tags$i(class = "dropdown icon"),
          div(
            class = "menu",
            a(
              class = "active item", `data-tab` = "home", `data-value` = "home", 
              shiny.semantic::icon("blue home"), "Home"
            ),
            a(
              class = "signed-in-item item", `data-tab` = "user", `data-value` = "user", 
              shiny.semantic::icon("blue reddit alien"), "User"
            ),
            a(
              class = "signed-in-item item", `data-tab` = "votes", `data-value` = "votes", 
              shiny.semantic::icon("blue arrow alternate circle up"), "Votes"
            ),
            a(
              class = "signed-in-item item", `data-tab` = "posts", `data-value` = "posts", 
              shiny.semantic::icon("blue edit"), "Posts"
            ),
            a(
              class = "signed-in-item item", `data-tab` = "comments", `data-value` = "comments", 
              shiny.semantic::icon("blue comment dots"), "Comments"
            )
            # a(
            #   class = "item", `data-tab` = "subreddit", `data-value` = "subreddit", 
            #   shiny.semantic::icon("blue list ol"), "Subreddit"
            # ),
          )
        )
      ),
      
      menu_item(
        item_feature = "ui right",
        uiOutput("settings_dropdown", inline = TRUE)
      )
    )
  ),
  
  tags$main(
    div(
      class = "ui top aligned modal", id = "load_modal",
      h4(class = "ui header", "Pulling user activity from Reddit (this may take a while)..."),
      div(
        class = "content", 
        shiny.semantic::progress(
          "load_progress", 
          value = 0, 
          total = 6, 
          label_complete = "Complete!", 
          class = "indicating"
        )
      )
    ),
    div(
      class = "ui tab basic segment active", `data-tab` = "home",
      user_home_ui("home")
    ),
    div(
      class = "ui tab basic segment", `data-tab` = "user",
      user_page_ui("user")
    ),
    div(
      class = "ui tab basic segment", `data-tab` = "votes",
      votes_page_ui("votes")
    ),
    div(
      class = "ui tab basic segment", `data-tab` = "posts",
      comments_page_ui("posts", type = "Post")
    ),
    div(
      class = "ui tab basic segment", `data-tab` = "comments",
      comments_page_ui("comments", type = "Comment")
    )
    # div(
    #   class = "ui tab basic segment", `data-tab` = "subreddit",
    #   sub_page
    # )
  )
)
