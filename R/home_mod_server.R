user_home_server <- function(input, output, session) {
  res <- httr::GET(
    "https://www.reddit.com/r/aww.json?sort=hot&limit=12", 
    httr::user_agent(glue::glue("shiny:ashbaldry.shinyapps.io:v1.0.0 {Sys.time()} (by /u/AshenCoder)"))
  )
  cont <- httr::content(res)
  
  post <- cont$data$children[[floor(runif(1, 4, 12))]]$data
  # Can't find nice preview of gallery post
  while (length(post$media_metadata) > 0) {
    post <- cont$data$children[[floor(runif(1, 4, 12))]]$data
  }
  
  output$title <- renderUI(span(post$title))
  output$post <- renderUI({
      if (post$is_video) {
        tags$video(
          controls = NA, class = "ui medium image",
          tags$source(src = post$secure_media$reddit_video$fallback_url, type = "video/mp4")
        )
      } else {
        tags$img(class = "ui medium image", src = post$url)
      }
  })
  
  output$link <- renderUI({
    tagList(
      scales::comma(post$score),
      "karma - ",
      tags$a(href = paste0("https://www.reddit.com", post$permalink), target = "_blank", "Link")
    )
  })
}