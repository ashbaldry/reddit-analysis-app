votes_chart <- function(dt, color = "#333333", label = "Upvotes") {
  if (is.null(dt)) return(highcharter::highchart())
  plt_dt <- dt[, .(count = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(plt_dt, -count)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      plt_dt[seq(min(10, .N))], 
      highcharter::hcaes(x = subreddit, y = count),
      type = "bar", name = label, color = color
    ) %>%
    highcharter::hc_xAxis(
      type = "category"
    ) %>%
    highcharter::hc_title(
      text = glue::glue("Top {sub('s$', 'd', label)} Subreddits")
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    )
}

vote_ratio_chart <- function(up_dt, down_dt) {
  if (is.null(up_dt) || is.null(down_dt)) return(highcharter::highchart())
  up_cnt_dt <- up_dt[, .(upvote = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(up_cnt_dt, -upvote)
  
  down_cnt_dt <- down_dt[, .(downvote = .N), by = .(subreddit = subreddit_name_prefixed)]
  setorder(down_cnt_dt, -downvote)
  
  cnt_dt <- merge(up_cnt_dt, down_cnt_dt, by = "subreddit", all = TRUE)
  set(cnt_dt, which(is.na(cnt_dt$upvote)), "upvote", 0)
  set(cnt_dt, which(is.na(cnt_dt$downvote)), "downvote", 0)
  cnt_dt[, count := upvote + downvote]
  setorder(cnt_dt, -count)
  
  plt_dt <- cnt_dt[seq(min(15, .N))]
  plt_dt[, ratio := (upvote - downvote) / (upvote + downvote)]
  plt_dt[, bar_color := fifelse(ratio >= 0, upvote_colour, downvote_colour)]
  plt_dt[, ratio_order := fifelse(ratio >= 0, count, -count)]
  setorder(plt_dt, -ratio, -ratio_order)
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      plt_dt, 
      highcharter::hcaes(x = subreddit, y = ratio, color = bar_color, up = upvote, down = downvote),
      type = "bar", name = "Ratio",
      tooltip = list(
        pointFormat = "Ratio: <b>{point.value}</b><br/>Upvotes: <b>{point.up}</b> Downvotes: <b>{point.down}</b>",
        valueDecimals = 2
      )
    ) %>%
    highcharter::hc_xAxis(
      type = "category"
    ) %>%
    highcharter::hc_yAxis(
      min = -1, max = 1
    ) %>%
    highcharter::hc_title(
      text = "Top Voted Subreddits Upvote/Downvote Ratio"
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    )
}

weekday_abbr <- c("Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun")

vote_time_chart <- function(up_dt, down_dt) {
  up_time_dt <- up_dt[, .(up = .N), keyby = .(day = wday(created_utc), hour = hour(created_utc))]
  up_time_dt <- up_time_dt[CJ(day = 1:7, hour = 0:23)]
  set(up_time_dt, which(is.na(up_time_dt$up)), "up", 0)
  
  down_time_dt <- down_dt[, .(down = .N), keyby = .(day = wday(created_utc), hour = hour(created_utc))]
  down_time_dt <- down_time_dt[CJ(day = 1:7, hour = 0:23)]
  set(down_time_dt, which(is.na(down_time_dt$down)), "down", 0)
  
  time_dt <- merge(up_time_dt, down_time_dt, by = c("day", "hour"))
  time_dt[, wday := factor(day, labels = weekday_abbr)]
  time_dt[up != 0 | down != 0, diff := up - down]
  
  highcharter::highchart() %>%
    highcharter::hc_chart(
      type = "heatmap"
    ) %>%
    highcharter::hc_add_series(
      time_dt, type = "heatmap",
      highcharter::hcaes(x = hour, y = wday, value = diff)
    ) %>%
    highcharter::hc_colorAxis(
      stops = list(
        list(0, downvote_colour), 
        list(time_dt[, (0 - min(diff)) / (max(diff) - min(diff))], "#FFFFFF"), 
        list(1, upvote_colour)
      )
    ) %>%
    highcharter::hc_yAxis(
      categories = weekday_abbr
    )
}