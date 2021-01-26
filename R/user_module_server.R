user_page_server <- function(input, output, session, access_token) {
  ns <- session$ns
  
  user_info <- reactive({
    if (is.null(access_token())) return(NULL)
    
    result <- httr::GET(
      "https://oauth.reddit.com/api/v1/me",
      httr::add_headers(Authorization = access_token()),
      httr::user_agent("httr")
    )
    
    httr::content(result)
  })
  
  user_name <- reactive(if (is.null(access_token())) "Not Logged In" else user_info()$name)
  output$username <- renderText(user_name())
  avatar <- reactive(if (is.null(access_token())) NULL else img(src = user_info()$icon_img))
  output$avatar <- renderUI(avatar())
  output$karma <- renderText(user_info()$total_karma)
}