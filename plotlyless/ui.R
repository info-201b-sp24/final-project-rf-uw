library(shiny)
library(plotly)
library(tidyverse)
library(bslib)
library(thematic)

# Define UI ----
thematic_on()

intro <- tabPanel(title = "Introduction",
  sidebarLayout(
    sidebarPanel(
        img(src = "kingcountyvote.jpeg", width = 400, alt = em("A King County ballot drop box")),
        em("Image credit: David Hyde, KUOW")
    ),
    position = "right",
    mainPanel(
      title = "Introduction",
      h1("Introduction: Elections and Race in King County"),
      h4("Author: Ryder Forsythe"),
      h4("Spring 2024"),
      h3("Questions"),
      p("This project examines the last decade and a half of elections in King County, and how they have been correlated with race and ethnicity as measured by the U.S. Census Bureau. Since 2008, King County has undergone several major electoral realignments alongside the rest of the country. As the largest county in Washington State, and one of the largest and most diverse in the country, changes in its electoral landscape reflect several broader trends in political affiliation and electoral participation. In the past decade, traditional political divides have shifted, correlated in part with race. Using electoral and demographic data from the past 16 years, I want to explore and answer these research questions:"),
      h4("1. What is the racial geography of King County?"),
      h4("2. What is the electoral geography of King County? How has this changed over time?"),
      h4("3. How is race correlated with changes in the electoral landscape of King County?"),
      p("Analyzing these topics can help us to better understand not only how politics and electoral coalitions are changing, but *why* - and how they may continue to shift in the coming election - not only in King County or Washington State, but in the United States as a whole."),
      h3("The Dataset"),
      p(a("The dataset", href = "https://docs.google.com/spreadsheets/d/1M5eRNDF4ReLY5yJKrxArbkNGMHLGcWuQ5F9KORZF8vQ/edit?usp=sharing"), "was compiled by Dave’s Redistricting App", a("(davesredistricting.org)", href = "davesredistricting.org"), "a project of the nonprofit", a("Social Good Fund", href = "https://www.socialgoodfund.org"), "that provides free electoral and census data for the purpose of redistricting at the federal, state, and local level, alongside a suite of redistricting tools that allow users to draw and export district maps based on that data. The data has several primary sources; electoral data comes primarily from the Voting and Election Science Team, which in turn aggregates election data from state and local election administrators. In Washington State, the Secretary of State and county auditors administer elections and publish precinct-level electoral data; VEST cleans the data, and DRA merges it with geospatial precinct information, also from the Secretary of State, and demographic data from the United States Census Bureau."),
      p("This dataset contains electoral and demographic data from 2008 to 2020 in King County; there are 2755 observations (rows), corresponding to the 2755 precincts in the county, and 135 features/columns, containing data from 25 elections, the 2010 and 2020 censuses, and the American Communities race and ethnicity survey conducted by the Census Bureau. The racial data aggregated here is reflective of many historical and socioeconomic factors; redlining and recent migration and gentrification have shaped where racial minorities live in the county, and economic factors like income and education have shaped how people in King County vote - both on a partisan level and in terms of turnout and voter participation."),
      h3("Considerations and Challenges"),
      p("There are important things to consider about how the Census Bureau handles racial and ethnic data - in the decennial census, information about hispanic identification is collected separately from other racial data. The 5-year American Communities survey, by contrast, measures hispanic/latino identification as part of their racial categorization, alongside the standard racial categories. This means that there isn't one clear standard for how to measure hispanic/latino identity in conjuction with other racial categories; some discretion is required in determining how to deal with this discrepancy. I have chosen to use the more accurate Census numbers, but adding a category for people who did not select a racial identifier and did identify as hispanic."),
      p("Because the data ultimately comes from several different sources, with different methodologies for collecting data about people - elections vs. censuses - and because this is aggregated across precincts containing hundreds or thousands of people, we cannot draw direct conclusions about individuals’ political or electoral leanings based on this dataset. Still, it can be useful to study broader trends to understand the larger narratives at play in King County and the broader electorate. Elections are ultimately a proxy for political beliefs; what are typically binary choices cannot express the breadth and complexity of individuals’ views of the world, and so there is inherently a loss of dimensionality when we study this kind of data; similarly, demographic questions obscure a lot of complexity in how people identify their culture and communities. This kind of analysis is ultimately only a starting point for further quantitative and qualitative study of these trends.")
    )
  )
)
  
page1 <- tabPanel(title = "1: Race and Ethnicity",
  sidebarLayout(
      sidebarPanel(
        radioButtons(
          inputId = "race_choice",
          label = h4("Racial group:"),
          choices = list("White" = "white",
                         "Black" = "black",
                         "Hispanic" = "hispanic",
                         "Asian" = "asian",
                         "Native American" = "native",
                         "Pacific Islander" = "pacific",
                         "Multiracial" = "multi",
                         "All Nonwhite" = "nonwhite"
          )
        ),
        width = 2
      ),
    mainPanel(h2("Race by Precinct"),
      br(),
      plotOutput(outputId = "racial_map"),
      br(),
      p("This map shows the geographic concentration of people of different racial/ethnic identities in King County. This helps us to answer our first question, visualizing the racial geography of the county. We can see patterns in where members of different ethnic groups live - for example, Black and Hispanic people are most concentrated in South Seattle and Renton, while the Puget Sound and Lake Washington coasts tend to be more uniformly white. Asian Americans are the largest nonwhite racial group in the county, and have substantial communities both in South Seattle and on the Eastside.")
    )
  )      
)

page2 <- tabPanel(
  title = "2: Election Results",
  sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "election1",
          label = h4("Election:"),
          choices = list("President 2020" = "X2020_President",
                          "President 2016" = "X2016_President",
                          "President 2012" = "X2012_President",
                          "President 2008" = "X2008_President",
                          "Senator 2022" = "X2022_Senate",
                          "Governor 2020" = "X2020_Governor",
                          "Senator 2018" = "X2018_Senate",
                          "Senator 2016" = "X2016_Senate",
                          "Governor 2016" = "X2016_Governor"
            ),
          selected = "X2012_President"
          ),
          selectInput(
            inputId = "election2",
            label = h4("Swing to:"),
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
        h2("Election Results by Precinct"),
        navset_bar(
          padding = c(50, 0),
          nav_panel(strong("Results"), plotOutput(outputId = "election_map")),
          nav_panel(strong("Swings"), plotOutput(outputId = "swing_map"))
        ),
        p("These maps show election results from the past 16 years by precinct. This helps answer our second guiding question - what is the political geography of King County. King County is on the whole very Democratic in all elections shown here, but Seattle still stands out as exceptionally left-leaning even in that context. Under the surface, there are many interesting trends visible in how the county has swung between different elections. I think that it's especially apt to compare the 2012 and 2020 Presidential elections, as they were both decided by similar margins nationwide, but with very different electoral coalitions. In the Swings tab, we can compare how precincts voted between any two elections in the dataset. Looking at the 2012-2020 swing, there are noticeable shifts leftward in many very white places visible on the previous page, and similarly pronounced rightward swings in some majority-nonwhite places.")
      )
  )
)


page3 <- tabPanel(
  title = "3: Correlations",
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "race_choice2",
        label = "Racial group:",
        choices = list("White" = "white",
                       "Black" = "black",
                       "Hispanic" = "hispanic",
                       "Asian" = "asian",
                       "Native American" = "native",
                       "Pacific Islander" = "pacific",
                       "Multiracial" = "multi",
                       "All Nonwhite" = "nonwhite"
        ),
        selected = "nonwhite"
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
        ),
        selected = "X2012_President"
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
      sliderInput(
        inputId = "race_slider",
        label = "Population bounds",
        min = 0,
        max = 1,
        value = c(0, 1),
        step = 0.01
      ),
      width = 3
    ),
    mainPanel(
      fluidPage(h2("Correlations between race and electoral swing")),
                   plotlyOutput(outputId = "scatterplotly"), 
      br(),
      p("Finally, we can look at the correlations between election swings and different racial groups, to address our third question - how are race and political affiliation related. Again, I'm looking at the 2012-2020 swing to start, but there are interesting trends throughout this dataset. At surface level, there appears to be a modest negative correlation between the percentage of the population identifying as nonwhite and the rightward swing from 2012-2020; but we can go deeper. The plot can be adjusted to show different ranges of ethnic identification using the slider; this allows us to remove precincts with a tiny number of a given group from the regression, or just focus on the most homogenous precincts, to see if there are any effects specific to more insular communities. As an example, looking at Asian American % vs the 2012 - 2020 swing among all precincts shows a positive correlation between leftward swing and Asian population, but if we isolate precincts that are >50% Asian, this correlation reverses. This indicates that there are potentially more complex factors at play than a simple uniform swing among all members of a given racial group.")
    )
  )
)  
  
conclusion <- tabPanel(
  title = "Conclusion",
  h1("Conclusion and Key Takeaways"),
  br(),
  h3("1. King County is very blue, and getting bluer"),
  p("We can see this in the second chart, as well as in the overall data - King County has shifted very strongly to the left over time. In 2012, King County voted for Barack Obama (D) over Mitt Romney (R) by a margin of 40.36 percentage points. In 2020, it voted for Joe Biden (D) over Donald Trump (R) by 52.71 percentage points. This is a more than twelve point shift to the left, driven in large part by the leftward shift of white, suburban areas. Even just from 2016 to 2020, the county shifted four percentage points to the left. This swing has not been uniform, however."),
  img(src = "President 2020.png", width = 800, em("2020 Presidential election in King County")),
  br(),
  h3("2. There has been a rightward shift in majority-minority areas"),
  img(src = "Nonwhite%.png", width = 800, em("nonwhite percentage")),
  img(src = "correlation.png", width = 800, em("nonwhite percentage vs. 2012-2020 swing")),
  p("Even though King County as a whole has shifted quite a lot to the left, many nonwhite communities have moved in the opposite direction. From the first map, we can see that Black Americans, Hispanic Americans, Asian-Americans, and Pacific Islanders are mostly concentrated in South Seattle and the southern King County suburbs, with a substantial Asian population also residing in the suburbs east of Seattle. Most of these areas shifted to the right from 2012 to 2020, despite the county as a whole moving in the opposite direction. This suggests that there has been a significant realignment of nonwhite voters towards the Republican Party, which is also visible in shifts between more recent election results, like the swing from the 2020 Presidential election to the 2022 Senate election. These trends are also visible in the scatterplots - nonwhite % of the population is meaningfully correlated with rightward swings."),
  br(),
  h3("3. Not all plurality-nonwhite areas shifted to the right"),
  img(src = "Swing 2012-2020.png", width = 800, em("swing from 2012 to 2020")),
  p("We can see from the 2012 - 2020 swing map that many plurality- or majority-Asian areas on the Eastside actually shifted left, even as similarly Asian precincts in the south shifted to the right. This indicates that there might be more going on here than just a race-based realignment. Rather, it seems like the ultimate cause of these swings might be something correlated with race but distinct from it. My best guess is that the culprit is educational attainment."),
  br(),
  h3("Broader Implications"),
  p("Polarization based on educational attainment is a well-documented and highly discussed phenomenon in national politics; the New York Times' Nate Cohn", a("argues", href = "https://www.nytimes.com/2021/09/08/us/politics/how-college-graduates-vote.html"), "that educational polarization is the defining political trend of this era. One thing those leftward-swinging Asian neighborhoods have in common with their majority-white counterparts is very high levels of college education. Ultimately, I think that more study is needed to determine what this relationship might be; unfortunately, information about educational attainment is far less granular than Census data, so getting clear answers may be difficult. What is clear, however, is that there are realignments taking place in these communities, regardless of the cause, and this has implications for the political landscape of not just King County, but the whole country.")
)


ui <- navbarPage("Elections and Race in King County",
                 theme = bs_theme(bootswatch = "pulse"),
                 intro,
                 page1,
                 page2,
                 page3,
                 conclusion
                 )