user_home_server <- function(input, output, session) {
  res <- httr::GET(
    "http://www.reddit.com/r/aww.json?sort=hot&limit=10", 
    httr::user_agent("shiny:ashbaldry.shinyapps.io:v1.0.0 (by /u/AshenCoder)")
  )
  cont <- httr::content(res)
  
  post <- cont$data$children[[floor(runif(1, 4, 10))]]$data
  
  output$title <- renderText(post$title)
  output$post <- renderUI({
    if (post$is_video) {
      tags$a(
        href = paste0("https://www.reddit.com", post$permalink), target = "_blank",
        tags$video(
          controls = NA, class = "ui medium image",
          tags$source(src = post$secure_media$reddit_video$fallback_url, type = "video/mp4")
        )
      )
    } else {
      tags$a(
        href = paste0("https://www.reddit.com", post$permalink), target = "_blank",
        tags$img(class = "ui medium image", src = post$url)
      )
    }
  })
}