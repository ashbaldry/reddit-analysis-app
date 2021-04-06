user_page_server <- function(input, output, session, reddit, rr) {
  ns <- session$ns
  
  #### User Info ####
  user_info <- reactive({
    rr()
    if (!reddit$is_authorized()) return(NULL)
    reddit$get_user_info()
  })
  
  #### Post Stats ####
  post_karma <- reactive({
    if (is.null(user_info())) return(NA)
    user_info()$link_karma
  })
  output$post_karma <- renderText(post_karma())
  
  comm_karma <- reactive({
    if (is.null(user_info())) return(NA)
    user_info()$comment_karma
  })
  output$comm_karma <- renderText(comm_karma())
}