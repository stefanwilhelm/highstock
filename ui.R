library(shiny)
library(rCharts)

shinyUI(fluidPage(
  
  tags$head(tags$script(src = "https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"),
            tags$script(src = "https://code.highcharts.com/stock/highstock.js"),
            tags$script(src = "https://code.highcharts.com/modules/exporting.js")),
            
  titlePanel("Interactive Highcharts Highstocks in Shiny"),
  
  inputPanel(
    selectInput("id", "Select Stock", choices=c("Apple (AAPL)" = "AAPL", 
                                                "Google (GOOG)" = "GOOG", 
                                                "Microsoft (MSFT)" = "MSFT"))
  ),

  tabsetPanel(
    tabPanel("Highcharts Highstocks Chart",
      showOutput("highstock","highcharts")
    ),
    
    tabPanel("About",
      p("This is a quick demonstration on how to use Highstocks in R Shiny.
         It loads the data from Yahoo!Finance using the ",
        a(href='http://cran.r-project.org/package=quantmod','quantmod')," package and uses the ", 
        a(href='http://rcharts.io','rCharts'), " package to display the Highstock chart.")
    )
  )
))