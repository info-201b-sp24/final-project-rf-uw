library(shiny)
library(tidyverse)
library(bslib)
library(thematic)

# Define UI ----
thematic_shiny()

intro <- tabPanel(title = "Introduction",
  sidebarLayout(
    sidebarPanel(
      img("description", src = "path")
    ),
    mainPanel(
      title = "Introduction",
      theme = bs_theme(version = 5, bootswatch = "pulse"),
      h1("Introduction: Elections and Race in King County"),
      h4("Author: Ryder Forsythe"),
      h4("Spring 2024"),
      p("This project examines the last decade and a half of elections in King County, and how they have been correlated with race and ethnicity as measured by the U.S. Census Bureau. Since 2008, King County has undergone several major electoral realignments alongside the rest of the country. As the largest county in Washington State, and one of the largest and most diverse in the country, changes in its electoral landscape reflect several broader trends in political affiliation and electoral participation. In the past decade, traditional political divides have shifted, correlated in part with race. Using electoral and demographic data from the past 16 years, I want to explore and answer these research questions:"),
      h4("What is the racial geography of King County? How has this changed over time?"),
      h4("What is the electoral geography of King County? How has this changed over time?"),
      h4("How is race correlated with changes in the electoral landscape of King County?"),
      p("Analyzing these topics can help us to better understand not only how politics and electoral coalitions are changing, but *why* - and how they may continue to shift in the coming election - not only in King County or Washington State, but in the United States as a whole.")
    )
  )
)
  
page1 <- tabPanel(title = "1: Race and Ethnicity",
  sidebarLayout(
      sidebarPanel(
        theme = bs_theme(version = 5, bootswatch = "pulse"),
        radioButtons(
          inputId = "race_choice",
          label = h4("Racial group:"),
          choices = list("White" = "white",
                         "Black" = "black",
                         "Hispanic" = "hispanic",
                         "Asian" = "asian",
                         "Native American" = "native",
                         "Pacific Islander" = "pacific",
                         "Multiracial" = "multi"
          )
        ), 
        width = 2
      ),
    mainPanel(plotOutput(outputId = "racial_map")
    )
  )      
)

page2 <- tabPanel(
  title = "2: Election Maps",
  sidebarLayout(
      sidebarPanel(
        theme = bs_theme(version = 5, bootswatch = "pulse"),
        selectInput(
          inputId = "election1",
          label = "Election:",
          choices = list("President 2020" = "X2020_President",
                          "President 2016" = "X2016_President",
                          "President 2012" = "X2012_President",
                          "President 2008" = "X2008_President",
                          "Senator 2022" = "X2022_Senate",
                          "Governor 2020" = "X2020_Governor",
                          "Senator 2018" = "X2018_Senate",
                          "Senator 2016" = "X2016_Senate",
                          "Governor 2016" = "X2016_Governor"
            )
          ),
          selectInput(
            inputId = "election2",
            label = "Swing to:",
            choices = list("President 2020" = "X2020_President",
                           "President 2016" = "X2016_President",
                           "President 2012" = "X2012_President",
                           "President 2008" = "X2008_President",
                           "Senator 2022" = "X2022_Senate",
                           "Governor 2020" = "X2020_Governor",
                           "Senator 2018" = "X2018_Senate",
                           "Senator 2016" = "X2016_Senate",
                           "Governor 2016" = "X2016_Governor"
            )
          ),
        width = 2,
        position = "left"
      ),
      mainPanel(
        navset_tab(
          nav_panel("Results", plotOutput(outputId = "election_map"), theme = bs_theme(version = 5, bootswatch = "pulse")),
          nav_panel("Swings", plotOutput(outputId = "swing_map"), theme = bs_theme(version = 5, bootswatch = "pulse"))
        )
      )
  )
)


page3 <- tabPanel(
  title = "3: Correlations",
  theme = bs_theme(version = 5, bootswatch = "pulse"),
  sidebarLayout(
    sidebarPanel(
      theme = bs_theme(version = 5, bootswatch = "pulse"),
      sliderInput(
        inputId = "race_slider",
        label = h4("Racial percentage:"),
        min = 0,
        max = 1,
        value = 0.5,
        step = 0.01
      ),
      selectInput(
        inputId = "election3",
        label = "Swing from:",
        choices = list("President 2020" = "X2020_President",
                       "President 2016" = "X2016_President",
                       "President 2012" = "X2012_President",
                       "President 2008" = "X2008_President",
                       "Senator 2022" = "X2022_Senate",
                       "Governor 2020" = "X2020_Governor",
                       "Senator 2018" = "X2018_Senate",
                       "Senator 2016" = "X2016_Senate",
                       "Governor 2016" = "X2016_Governor"
        )
      ),
      selectInput(
        inputId = "election4",
        label = "Swing to:",
        choices = list("President 2020" = "X2020_President",
                       "President 2016" = "X2016_President",
                       "President 2012" = "X2012_President",
                       "President 2008" = "X2008_President",
                       "Senator 2022" = "X2022_Senate",
                       "Governor 2020" = "X2020_Governor",
                       "Senator 2018" = "X2018_Senate",
                       "Senator 2016" = "X2016_Senate",
                       "Governor 2016" = "X2016_Governor"
        )
      ),
      width = 4
    ),
    mainPanel(fluidPage("Scatterplots", plotlyOutput(outputId = "scatterplotly")))
  )
)  

  
conclusion <- tabPanel(
  title = "Conclusion",
  theme = bs_theme(version = 5, bootswatch = "pulse")
)


ui <- navbarPage("Elections and Race in King County",
                 intro,
                 page1,
                 page2,
                 page3,
                 conclusion
                 )