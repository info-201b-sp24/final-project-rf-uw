library(shiny)
library(bslib)

source("ui.R")
source("server.R")

# Run the app ----
shinyApp(ui = ui, server = server)