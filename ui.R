shiny.semantic::semanticPage(
  title = "Reddit Analysis", 
  margin = 0,
  
  #### Settings ####
  tags$head(
    tags$script(src = "sub_search.js"),
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "icon", href = "https://www.redditstatic.com/desktop2x/img/favicon/apple-icon-144x144.png")
  ),
  
  #### Header ####
  tags$header(
    div(
      class = "app-header",
      a(class = "ui tiny image", href = "https://www.reddit.com", tags$img(src = "reddit_logo.png"), target = "_blank"),
      uiOutput("login_button", inline = TRUE)
    )
  ),
  
  #### Top of Page ####
  shiny.semantic::tabset(
    id = "top_tabset", menu_class = "three item top-menu", tab_content_class = "",
    tabs = list(
      list(menu = div("User"), id = "user", content = user_page_ui("user")),
      list(menu = div("Subreddit"), id = "subreddit", content = sub_page),
      list(menu = div("Tab 3"), id = "tab3", content = div("SS"))
    )
  )
  
)
