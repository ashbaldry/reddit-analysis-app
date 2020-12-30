shiny.semantic::semanticPage(
  title = "Reddit Analysis",
  
  #### Settings ####
  tags$head(
    tags$script(src = "sub_search.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "icon", href = "https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-144x144.png")
  ),
  
  #### Header ####
  tags$header(
    style = "padding: 10px",
    shiny::div(
      shiny::a(class = "ui tiny image", href = "https://www.reddit.com", tags$img(src = "reddit_logo.png")),
      shiny::uiOutput("login_button", inline = TRUE)
    )
  ),
  
  #### Top of Page ####
  shiny.semantic::tabset(
    id = "top_tabset", menu_class = "three item", tab_content_class = "",
    tabs = list(
      list(menu = shiny::div("Subreddit"), id = "subreddit", content = sub_page),
      list(menu = shiny::div("User"), id = "user", content = user_page),
      list(menu = shiny::div("Tab 3"), id = "tab3", content = shiny::div("SS"))
    )
  )
  
)
