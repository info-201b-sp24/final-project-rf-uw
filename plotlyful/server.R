library(tidyverse)
library(plotly)
library(maps)
library(sf)
library(scales)
library(shiny)

precinct_data <- read.csv(url("https://raw.githubusercontent.com/info-201b-sp24/final-project-rf-uw/main/precinct_data.csv"))
precinct_shapes <- read_sf("precinct_shapes.geojson")

# Create separate, cleaned dataframes for easier use
election_data <- precinct_data %>% select(NAME, X2008_President, X2012_President, X2016_President, X2020_President, X2022_Senate, X2020_Governor, X2018_Senate, X2016_Governor, X2016_Senate) %>% 
  pivot_longer(!NAME, names_to = "election", values_to = "margin")

racial_data <- precinct_data %>% select(NAME, V_20_VAP_NH_Total, V_20_VAP_NH_White, V_20_VAP_NH_Hispanic, V_20_VAP_NH_BlackAlone, V_20_VAP_NH_AsianAlone, V_20_VAP_NH_NativeAlone, V_20_VAP_NH_PacificAlone, V_20_VAP_NH_TwoOrMore) %>% 
  mutate(V_20_VAP_NH_Nonwhite = V_20_VAP_NH_Total - V_20_VAP_NH_White,
    white = V_20_VAP_NH_White/V_20_VAP_NH_Total,
    nonwhite = V_20_VAP_NH_Nonwhite/V_20_VAP_NH_Total,
    black = V_20_VAP_NH_BlackAlone/V_20_VAP_NH_Total,
    hispanic = V_20_VAP_NH_Hispanic/V_20_VAP_NH_Total,
    asian = V_20_VAP_NH_AsianAlone/V_20_VAP_NH_Total,
    pacific = V_20_VAP_NH_PacificAlone/V_20_VAP_NH_Total,
    native =  V_20_VAP_NH_NativeAlone/V_20_VAP_NH_Total,
    multi = V_20_VAP_NH_TwoOrMore/V_20_VAP_NH_Total
    ) %>%
  select(NAME, white, nonwhite, black, hispanic, asian, pacific, native, multi) %>%
  pivot_longer(!NAME, names_to = "race", values_to = "race_percent")
  

# Define server logic ----
server <- function(input, output) {
  
# Setup for first page plots
  output$racial_map <- renderPlotly({
    race_choice <- input$race_choice
# Creating custom dataframe from input
    racial_joined <- inner_join(precinct_shapes, racial_data, by = "NAME")
    filtered_racial <- racial_joined %>% filter(race %in% input$race_choice)

# Race/ethnicity map
    racial_map <- ggplot(filtered_racial) +
      geom_sf(aes(fill = race_percent, text = paste("Name:", NAME, ", % of total:", round(race_percent, digits = 3))), color = "white", linewidth = 0.01) +
      labs(
        x = "Longitude",
        y = "Latitude"
      ) + 
      scale_fill_viridis_c(
        name = paste(
          case_match(race_choice,
                     "white" ~ "White",
                     "black" ~ "Black",
                     "hispanic" ~ "Hispanic",
                     "asian" ~ "Asian",
                     "pacific" ~ "Pacific Islander",
                     "native" ~ "Native American",
                     "multi" ~ "Multiracial",
                     "nonwhite" ~ "Nonwhite"
          ), 
          "%",
        ),
        breaks = c(0, 0.5, 1),
        labels = c("0%", "50%", "100%")
      ) +
      theme(
        plot.title = element_text(face = "bold"),
        rect = element_blank(),
        legend.title = element_text(vjust = 5, face = "bold")
      )
    
    racial_plotly <- ggplotly(racial_map, tooltip = "text")
    
    return(racial_plotly)
  })

# Setup for second page plots  
  output$election_map <- renderPlotly({
    
# Creating custom dataframe from input    
    election_joined <- inner_join(precinct_shapes, election_data, by = "NAME")
    filtered_election <- election_joined %>% filter(election %in% input$election1)

# Election results map        
    election_map <- ggplot(filtered_election) +
      geom_sf(aes(fill = margin, text = paste("Name:", NAME, ", Margin:", round(margin, 3))), color = "white",  linewidth = 0.01) +
      scale_fill_gradient2(
        low = "#DC3220",
        high = "#005AB5",
        mid = "#FFFFFF",
        breaks = c(-1, 0, 1),
        labels = c("R + 100", "No Change", "D + 100"),
        limits = c(-1, 1),
        name = "Margin"
      ) +
      theme(
        plot.title = element_text(face = "bold"),
        rect = element_blank(),
        legend.title = element_text(vjust = 5, face = "bold")
      ) +
      labs(
        x = "Latitude",
        y = "Longitude"
      )
    
    election_plotly <- ggplotly(election_map, tooltip = "text")
    
    return(election_plotly)
  })
  
  output$swing_map <- renderPlotly({
    
# Creating custom dataframe from input
    swing_from <- election_data %>% filter(election %in% input$election1)
    swing_to <- election_data %>% filter(election %in% input$election2)
    swing_df <- inner_join(swing_from, swing_to, by = "NAME") %>% 
      mutate(swing = margin.y - margin.x)
    precinct_joined_swing <- inner_join(precinct_shapes, swing_df, by = "NAME")

# Election swing map        
    swing_map <- ggplot(precinct_joined_swing) +
      geom_sf(aes(fill = swing, text = paste("Name:", NAME, ", Swing:", round(swing, 3))), color = "#e0e0e0",  linewidth = 0.01) +
      scale_fill_gradient2(
        low = "#DC3220",
        high = "#005AB5",
        mid = "#FFFFFF",
        guide = "colourbar",
        breaks = c(-0.5, 0, 0.5),
        labels = c("R + 50", "No Change", "D + 50"),
        limits = c(-0.5, 0.5),
        name = "Swing"
      ) +
      labs(
        x = "Latitude",
        y = "Longitude"
      ) +
      theme(
        plot.title = element_text(face = "bold"),
        rect = element_blank(),
        legend.title = element_text(vjust = 5, face = "bold")
      )
    
    swing_plotly <- ggplotly(swing_map, tooltip = "text")
    
    return(swing_plotly)
  })
  
# Setup for third page plot
  output$scatterplotly <- renderPlotly({
# Get swing and racial data
    swing_from_correlation <- election_data %>% filter(election %in% input$election3)
    swing_to_correlation <- election_data %>% filter(election %in% input$election4)
    swing_df_correlation <- inner_join(swing_from_correlation, swing_to_correlation, by = "NAME") %>% 
      mutate(swing = margin.y - margin.x) 
    correlation_data <- inner_join(swing_df_correlation, racial_data, by = "NAME", relationship = "many-to-many")
    correlation_data <- correlation_data %>% filter(race %in% input$race_choice2)
    lower_bound <- input$race_slider[1]
    upper_bound <- input$race_slider[2]
    
# Create scatterplot
    scatterplot <- correlation_data %>% 
      ggplot(aes(x = race_percent, y = swing)) +
      geom_point(aes(text = paste("Name:", NAME, ", Swing:", swing, ", Racial %:", round(race_percent, 3))), size = 0.25, alpha = 0.5, color = "dodgerblue4") +
      geom_smooth(method = lm, color = "dodgerblue2", show.legend = TRUE, linewidth = 0.5) +
      labs(
        x = "Percentage of population in selected racial group",
        y = "Margin swing"
      ) +
      geom_hline(yintercept = 0, alpha = 0.5,  linetype = "longdash") +
      scale_y_continuous(breaks = c(-0.5, -0.25, 0, 0.25, 0.5),
                         labels = c("R + 50", "R + 25", "No Change", "D + 25", "D + 50"), 
                         limits = c(-0.5, 0.5)
                        ) +
      scale_x_continuous(labels = label_percent(), limits = c(lower_bound, upper_bound)) +
      theme_minimal()
      
    scatterplotly <- ggplotly(scatterplot, tooltip = "text")
    
    return(scatterplotly)
  })
}



