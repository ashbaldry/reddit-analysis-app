user_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  user_info <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_info()
  })
  
  user_name <- reactive(if (is.null(user_info())) "Not Logged In" else user_info()$name)
  output$username <- renderText(user_name())
  
  avatar <- reactive(if (is.null(user_info())) NULL else img(src = user_info()$icon_img))
  output$avatar <- renderUI(avatar())
  
  output$karma <- renderText(user_info()$total_karma)
  
  
}