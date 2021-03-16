votes_chart <- function(dt, color = "#333333", label = "Upvotes") {
  if (is.null(dt)) return(highcharter::highchart())
  plt_dt <- dt[, .(count = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(plt_dt, -count)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      plt_dt[1:10], highcharter::hcaes(x = subreddit, y = count),
      type = "bar", name = "Downvotes", color = color
    ) %>%
    highcharter::hc_xAxis(
      type = "category"
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    )
}