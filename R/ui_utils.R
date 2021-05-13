reddit_karma_icon <- function(class) {
  tags$svg(
    class = class, viewBox = "0 0 20 20", version = "1.1", xmlns = "http://www.w3.org/2000/svg",
    tags$g(
      tags$path(
        d = "M6.42528593,9.54562407 C4.41043013,8.02026355 3.10790651,5.60355545 3.10790651,2.88165092 L3.10790651,2.79711586 L3.19244157,2.79711586 C5.9143461,2.79711586 8.33136499,4.09963948 9.85641472,6.11449528 C8.02399304,6.25279712 6.56358777,7.7128916 6.42528593,9.54562407 Z M6.42528593,10.2560915 C6.56358777,12.088824 8.02399304,13.5489184 9.85641472,13.6872203 C8.33136499,15.7020761 5.9143461,17.0045997 3.19244157,17.0045997 L3.10790651,17.0045997 L3.10790651,16.9200646 C3.10790651,14.1981601 4.41043013,11.781452 6.42528593,10.2560915 Z M13.6872203,10.2560915 C15.7020761,11.781452 17.0045997,14.1981601 17.0045997,16.9200646 L17.0045997,17.0045997 L16.9200646,17.0045997 C14.1981601,17.0045997 11.7811412,15.7020761 10.2560915,13.6872203 C12.0885132,13.5489184 13.5486077,12.088824 13.6872203,10.2560915 Z M16.9200646,2.79711586 L17.0045997,2.79711586 L17.0045997,2.88165092 C17.0045997,5.60324465 15.7020761,8.02026355 13.6872203,9.54562407 C13.5489184,7.7128916 12.0885132,6.25279712 10.2560915,6.11449528 C11.7811412,4.09963948 14.1981601,2.79711586 16.9200646,2.79711586 Z M19.9403282,9.84895574 L20,9.90862755 L19.9403282,9.96829935 C18.9346096,10.9740179 17.7346469,11.6624192 16.46227,12.0474888 C15.9659373,11.2534187 15.3446668,10.5308304 14.6071606,9.90862755 C15.3446668,9.28642466 15.9659373,8.5638364 16.46227,7.76976629 C17.7346469,8.1548359 18.9346096,8.8432372 19.9403282,9.84895574 Z M9.90862755,5.39283938 C9.28642466,4.65533317 8.5638364,4.03406266 7.76976629,3.53772999 C8.1548359,2.26535306 8.8432372,1.06539035 9.84895574,0.0596718051 L9.90862755,0 L9.96829935,0.0596718051 C10.9740179,1.06539035 11.6624192,2.26535306 12.0474888,3.53772999 C11.2534187,4.03406266 10.5308304,4.65533317 9.90862755,5.39283938 Z M5.39283938,9.90862755 C4.65533317,10.5308304 4.03406266,11.2534187 3.53772999,12.0474888 C2.26535306,11.6624192 1.06539035,10.9740179 0.0596718051,9.96829935 L0,9.90862755 L0.0596718051,9.84895574 C1.06539035,8.8432372 2.26535306,8.1548359 3.53772999,7.76976629 C4.03406266,8.5638364 4.65533317,9.28642466 5.39283938,9.90862755 Z M9.90862755,14.6071606 C10.5308304,15.3446668 11.2534187,15.9659373 12.0474888,16.46227 C11.6624192,17.7346469 10.9740179,18.9346096 9.96829935,19.9403282 L9.90862755,20 L9.84895574,19.9403282 C8.8432372,18.9346096 8.1548359,17.7346469 7.76976629,16.46227 C8.5638364,15.9659373 9.28642466,15.3446668 9.90862755,14.6071606 Z"
      )
    )
  )
}

reddit_segment <- function(..., sidebar = NULL) {
  div(
    class = "ui segment",
    div(
      class = "ui grid",
      div(
        class = "one wide column grey-sidebar",
        sidebar
      ),
      div(
        class = "fifteen wide column",
        ...
      )
    )
  )
}

signed_in_dropdown <- function(reddit) {
  tagList(
    div(
      id = "user_menu",
      name = "user_menu",
      class = "ui dropdown right-float",
      div(
        class = "ui grid",
        div(
          class = "thirteen wide column",
          div(
            class = "ui tiny unstackable items user-header-item",
            div(
              class = "item",
              div(
                class = "ui mini image",
                tags$img(src = reddit$user_info$icon_img)
              ),
              div(
                class = "middle aligned content",
                div(class = "header", reddit$user_name),
                div(
                  class = "meta", 
                  reddit_karma_icon("banner-karma-icon"), 
                  paste(reddit$user_info$total_karma, "karma")
                )
              )
            )
          )
        ),
        div(
          class = "two wide column",
          shiny.semantic::icon(class = "dropdown")
        )
      ),
      shiny.semantic::menu(
        class = "fluid",
        a(
          class = "mobile-item item", `data-tab` = "home", `data-value` = "home", 
          shiny.semantic::icon("home"), "Home"
        ),
        a(
          class = "mobile-item active item", `data-tab` = "user", `data-value` = "user", 
          shiny.semantic::icon("reddit alien"), "User"
        ),
        a(
          class = "mobile-item item", `data-tab` = "votes", `data-value` = "votes", 
          shiny.semantic::icon("arrow alternate circle up"), "Votes"
        ),
        a(
          class = "mobile-item item", `data-tab` = "posts", `data-value` = "posts", 
          shiny.semantic::icon("edit"), "Posts"
        ),
        a(
          class = "mobile-item item", `data-tab` = "comments", `data-value` = "comments", 
          shiny.semantic::icon("comment dots"), "Comments"
        ),
        a(
          class = "mobile-item item", `data-tab` = "subreddit", `data-value` = "subreddit", 
          shiny.semantic::icon("list"), "Subreddit"
        ),
        shiny.semantic::menu_divider(class = "mobile-item"),
        shiny.semantic::menu_item(
          shiny.semantic::icon("external alternate"), "Visit Reddit",
          href = "https://www.reddit.com", target = "_blank"
        ),
        shiny.semantic::menu_item(
          shiny.semantic::icon("github"), "GitHub",
          href = "https://www.github.com/ashbaldry/reddit-analysis-app", target = "_blank"
        ),
        shiny.semantic::menu_divider(),
        shiny.semantic::menu_item(
          id = "logout_button", class = "action-button", 
          shiny.semantic::icon("sign out alternate"), "Log Out"
        )
      )
    ),
    tags$script(HTML("
      $('#user_menu').dropdown({
        onChange: function() {
          var menu_val = $(this).dropdown('get value');
          var page_val = $('#page_select').dropdown('get value');
          if (menu_val && (page_val !== menu_val)) {
            $('#page_select').dropdown('set selected', menu_val);
          }
          $(this).trigger('shown');
        }
      });
      
      $('#page_select').dropdown({
        onChange: function() {
          var page_val = $(this).dropdown('get value');
          var menu_val = $('#user_menu').dropdown('get value');
          if ((page_val !== menu_val)) {
            $('#user_menu').dropdown('set selected', page_val);
          }
          $(this).trigger('shown');
        }
      });
      
      $('#user_menu .mobile-item').tab();
      $('#user_menu').dropdown('set selected', 'user');
      
      $('#logout_button').on('click', function() { 
        $('#user_menu').dropdown('set selected', 'home');
        $('#page_select a.item').tab('change tab', 'home');
        $('#page_select .signed-in-item').hide(); 
      });
    "))
  )
}

signed_out_dropdown <- function(reddit) {
  tagList(
    div(
      id = "user_menu",
      name = "user_menu",
      class = "ui dropdown right-float",
      span(
        class = "login-icon-header",
        shiny.semantic::icon(class = "large grey user"),
        shiny.semantic::icon(class = "grey dropdown")
      ),
      shiny.semantic::menu(
        class = "fluid",
        shiny.semantic::menu_item(
          id = "login_button",  
          href = reddit$get_auth_uri(),
          shiny.semantic::icon("sign in alternate"), "Sign In"
        ),
        shiny.semantic::menu_divider(),
        shiny.semantic::menu_item(
          shiny.semantic::icon("external alternate"), "Visit Reddit",
          href = "https://www.reddit.com", target = "_blank"
        ),
        shiny.semantic::menu_item(
          shiny.semantic::icon("github"), "GitHub",
          href = "https://www.github.com/ashbaldry/reddit-analysis-app", target = "_blank"
        )
      )
    ),
    tags$script(HTML("
      $('#user_menu').dropdown({
        direction: 'downward',
        context: 'header'
      });
    "))
  )
}
