

library(shiny)
library(markdown)
library(caret)
library(rtweet)
library(tidyverse)
library(httr)
library(randomForest)
library(shinythemes)
library(shinycssloaders)

source("./helpers.R")
source("./token.R") # token removed for privacy concerns


# UI ----
ui <- fluidPage(
  theme = shinytheme("darkly"),
  
  # Application title
  titlePanel("Botocracy"),
  
  # Sidebar
  sidebarLayout(
    
    sidebarPanel(
      # text input ----
      textInput(
        inputId = "screen_name",
        placeholder = "@...",
        label = "Insert Twitter ID"
      ),
      # slider input----
      sliderInput(
        inputId = "num",
        label = "Number of Tweets to check: ",
        min = 10,
        max = 500,
        value = 38
      ),
      actionButton("button1", "Bot or Not?"),
    ),
    
    mainPanel(
      withSpinner(shiny::textOutput('botornot'), type = 4),
      shiny::textOutput('mean'),
      shiny::tableOutput("table")
      
      )
  )
)


# Server logic----
server <- function(input, output) {
  observeEvent(input$button1, {
    out <- bot_check(input$screen_name, input$num)
    output$botornot <-
      shiny::renderText({
        ifelse(
          mean(as.numeric(as.character(out$BotOrNot))) > 0.5, 
          "This is a bot!", 
          "This is NOT a bot!"
          )
        })
    output$table <- shiny::renderTable({out})
    output$mean <-
      shiny::renderText({
        paste0(
          "The mean bot prediction for this user's last ",
          input$num,
          " Tweets is: ",
          round(mean(as.numeric(as.character(out$BotOrNot))), 2)
        )
        })
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
