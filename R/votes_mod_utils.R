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

vote_agree_data <- function(up_dt, down_dt) {
  if (is.null(up_dt) || is.null(down_dt)) return(highcharter::highchart())
  up_cnt_dt <- up_dt[, .(
    subreddit = subreddit_name_prefixed, permalink, type = "Upvote", agree_ratio = upvote_ratio
  )]
  setorder(up_cnt_dt, -agree_ratio)
  
  down_cnt_dt <- down_dt[, .(
    subreddit = subreddit_name_prefixed, permalink, type = "Downvote", agree_ratio = 1 - upvote_ratio
  )]
  setorder(down_cnt_dt, -agree_ratio)
  
  rbindlist(list(up_cnt_dt, down_cnt_dt))
}
  
vote_agree_chart <- function(dt) {
  labels <- c(
    "",
    glue::glue("Downvote<br/>Average:{dt[type == 'Downvote', scales::percent(mean(agree_ratio))]}"),
    glue::glue("Upvote<br/>Average:{dt[type == 'Upvote', scales::percent(mean(agree_ratio))]}")
  )
  
  highcharter::highchart() %>%
    highcharter::hc_add_series(
      dt, 
      highcharter::hcaes(x = agree_ratio * 100, y = fifelse(type == "Downvote", 1, 2), group = type),
      type = "scatter", cursor = "pointer",
      tooltip = list(
        headerFormat = "",
        pointFormat = paste0(
          "<span style='color:{point.color}'>●</span> <span> {point.subreddit}</span><br/>",
          "Agreement: <b>{point.x:.0f}%</b><br/>Click to see Reddit post"
        ),
        valueDecimals = 1,
        valueSuffix = "%"
      ),
      jitter = list(x = 0.5, y = 0.4)
    ) %>%
    highcharter::hc_yAxis(
      type = "category", categories = labels,
      labels = list(style = list(fontSize = "14px"), useHTML = TRUE)
    ) %>%
    highcharter::hc_xAxis(
      min = -2, max = 102, label = list(format = "{value}%")
    ) %>%
    highcharter::hc_title(
      text = "Upvote/Downvote Agreement"
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    ) %>%
    highcharter::hc_plotOptions(
      series = list(point = list(events = list(click = htmlwidgets::JS(
      "function() { window.open('https://www.reddit.com' + this.permalink); }"
      ))))
    ) %>%
    highcharter::hc_colors(c(downvote_colour, upvote_colour))
}

vote_ratio_chart <- function(up_dt, down_dt, n = 20) {
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
  
  plt_dt <- cnt_dt[seq(min(n, .N))]
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
        pointFormat = "Ratio: <b>{point.y}</b><br/>Upvotes: <b>{point.up}</b> Downvotes: <b>{point.down}</b>",
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
      text = "Top Voted Subreddits Up/Downvote Ratio"
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    )
}

get_post_type <- function(post_hint, is_video, url) {
  fcoalesce(
    sub("\\w+:", "", post_hint),
    # fifelse(post_hint == "rich:video", "gif", sub("\\w+:", "", post_hint)), 
    fifelse(
      is_video, "video",
      fifelse(grepl("i.redd.it", url), "image", fifelse(grepl("v.redd.it", url), "video", "text"))
    )
  )
}

get_vote_demo <- function(dt) {
  summ_dt <- dt[
    ,
    .(votes = .N, upvote = mean(upvote_ratio)),
    by = .(post_type)
  ]
  summ_dt[, percent := votes / sum(votes)]
  summ_dt
}

vote_type_tbl <- function(up_dt, down_dt) {
  up_dt[, post_type := get_post_type(post_hint, is_video, url)]
  down_dt[, post_type := get_post_type(post_hint, is_video, url)]
  
  info_dt <- rbindlist(list(
    data.table(type = "Upvote", get_vote_demo(up_dt)),
    data.table(type = "Downvote", get_vote_demo(down_dt))
  ))
  info_dt[, ud_percent := votes / sum(votes), by = .(post_type)]
  info_dt
}