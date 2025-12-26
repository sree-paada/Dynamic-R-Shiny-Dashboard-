source("scripts/dynamicdashboard.R")

data <- read_csv("data/Paralympic.csv")

data <- data %>%
  mutate(total_medals = npc_gold + npc_silver + npc_bronze)

print(colnames(data))

transformations_q1 <- list(
  list(
    function(df) {
      summer_data <- df %>%
        filter(games_season == "Summer")
      
      Prev_5yrs_data <- summer_data %>%
        distinct(games_year) %>%
        arrange(desc(games_year)) %>%
        slice_head(n = 5) %>%
        pull(games_year)
      
      Prev_5yrs_summer_data <- summer_data %>%
        filter(games_year %in% Prev_5yrs_data)
      
      Top_NPCs <- Prev_5yrs_summer_data %>%
        group_by(npc_new) %>%
        summarise(total = sum(total_medals, na.rm = TRUE)) %>%
        arrange(desc(total)) %>%
        slice_head(n = 10) %>%
        pull(npc_new)
      
      Prev_5yrs_summer_data %>%
        filter(npc_new %in% Top_NPCs) %>%
        group_by(npc_new, games_year) %>%
        summarise(total_medals = sum(total_medals, na.rm = TRUE), .groups = "drop")
    }
  ),
  
  list(
    function(df) {
      summer_data <- df %>%
        filter(games_season == "Summer")
      
      Prev_5yrs_data <- summer_data %>%
        distinct(games_year) %>%
        arrange(desc(games_year)) %>%
        slice_head(n = 5) %>%
        pull(games_year)
      
      Prev_5yrs_summer_data <- summer_data %>%
        filter(games_year %in% Prev_5yrs_data)
      
      Top_NPCs <- Prev_5yrs_summer_data %>%
        group_by(npc_new) %>%
        summarise(total = sum(total_medals, na.rm = TRUE)) %>%
        arrange(desc(total)) %>%
        slice_head(n = 10) %>%
        pull(npc_new)
      
      summer_data %>%
        filter(npc_new %in% Top_NPCs) %>%
        filter(games_year %in% Prev_5yrs_data) %>%
        select(games_year, npc_new, npc_gold, npc_silver, npc_bronze) %>%
        pivot_longer(cols = c(npc_gold, npc_silver, npc_bronze),
                     names_to = "Medal_Type",
                     values_to = "Count") %>%
        mutate(Medal_Type = recode(Medal_Type,
                                   npc_gold = "Gold",
                                   npc_silver = "Silver",
                                   npc_bronze = "Bronze"))
    }
  )
)

plots_q1 <- list(
  function(df) ggplot(df, aes(x = games_year,
                              y = total_medals,
                              color = npc_new)) +
    geom_line(size = 1.2) +
    geom_point(size = 3) +
    labs(title = "Trends of Medals for Top 10 NPCs over last 5 Summer Games",
         color = "Country",
         x = "Game Year",
         y = "Total Medals") +
    theme_minimal(),
  
  function(df) ggplot(df, aes(x = factor(games_year),
                              y = Count,
                              fill = Medal_Type)) +
    geom_bar(stat = "identity") +
    facet_wrap(~npc_new) +
    labs(title = "Medal Composition for Top 10 NPCs",
         x = "Games Year",
         y = "Medal Count",
         fill = "Medal Type") +
    theme_minimal()
)

transformations_q2 <- list(
  list(
    function(df) {
      masochism_sports <- c("Athletics", "Swimming", "Powerlifting", "Cycling")
      
      sports_dom <- df %>%
        filter(sport %in% masochism_sports) %>%
        filter(total_medals > 0) %>%
        mutate(Region = case_when(npc_new %in% c("USA", "BRA", "CAN") ~ "America",
                                  npc_new %in% c("CHN", "JPN", "KOR") ~ "Asia",
                                  npc_new %in% c("GBR", "FRA", "GER", "ITA") ~ "Europe",
                                  TRUE ~ "Other"))
      
      region_sport_yr <- sports_dom %>%
        group_by(games_year, Region, sport) %>%
        summarise(Count = n(), .groups = "drop")
    }
  ),
  
  list(
    function(df) {
      masochism_sports <- c("Athletics", "Swimming", "Powerlifting", "Cycling")
      
      sports_dom <- df %>%
        filter(sport %in% masochism_sports) %>%
        filter(total_medals > 0) %>%
        mutate(Region = case_when(npc_new %in% c("USA", "BRA", "CAN") ~ "America",
                                  npc_new %in% c("CHN", "JPN", "KOR") ~ "Asia",
                                  npc_new %in% c("GBR", "FRA", "GER", "ITA") ~ "Europe",
                                  TRUE ~ "Other"))
      
      bubble_data <- sports_dom %>%
        group_by(sport, Region) %>%
        summarise(medal_Count = sum(total_medals, na.rm = TRUE), .groups = "drop")
    }
  )
)

plots_q2 <- list(
  function(df) ggplot(df, aes(x = games_year,
                              y = Count,
                              fill = sport)) +
    geom_area() +
    facet_wrap(~Region) +
    labs(title = "Participation in High-Endurance Sports by Region",
         x = "Games Year",
         y = "Participation Count",
         fill = "High Endurance Sport") +
    theme_minimal(),
  
  function(df) ggplot(df, aes(x = sport, y = Region,
                              size = medal_Count,
                              color = Region)) +
    geom_point(alpha = 0.7) +
    labs(title = "Sport Domination by Region",
         x = "Sport",
         y = "Region",
         size = "Medal Count",
         color = "Region") +
    theme_minimal()
)

label_map <- c("npc_new" = "Country",
               "games_season" = "Season",
               "games_year" = "Year")

filters <- c("games_year", "npc_new", "games_season")

generate_dynamic_dashboard(data, transformations_q1, plots_q1, transformations_q2, plots_q2, filters, label_map, dashboard_title = "Paralympic Dashboard", q1_page = "Medal Trends", q2_page = "Mascular Game Trends")

