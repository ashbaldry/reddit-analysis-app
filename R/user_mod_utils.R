karma_subreddit_chart <- function(subreddit_karma, yaxis_col = c("link_karma", "comment_karma")) {
  yaxis_col <- match.arg(yaxis_col)
  subreddit_karma_valid <- subreddit_karma[!is.na(get(yaxis_col)), .(sr, karma = .SD[[1]]), .SDcols = yaxis_col]
  subreddit_karma_valid[, percent := scales::percent(karma / sum(karma), accuracy = 1)]
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      subreddit_karma_valid, highcharter::hcaes(x = paste0("r/", sr), value = karma, colorValue = karma), 
      type = "treemap",
      layoutAlgortithm = "squarified",
      tooltip = list(
        pointFormat = "<b>{point.name}</b>: {point.value}<br/>{point.percent} of total karma<br/>"
      )
    ) %>%
    highcharter::hc_colorAxis(
      minColor = "#ffffff",
      maxColor = upvote_colour
    ) %>%
    highcharter::hc_title(
      text = paste(if (yaxis_col == "link_karma") "Post" else "Comment", "Karma Split by Subreddit")
    ) %>%
    highcharter::hc_subtitle(
      text = paste("Total Karma:", scales::comma(sum(subreddit_karma_valid$karma)))
    )
}