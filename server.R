library(shiny)
library(rCharts)
library(quantmod)

shinyServer(function(input, output, session) {
  
  # load time series from Yahoo Finance
  getYahooTimeSeriesAsJSON <- reactive({
    ts <- getSymbols(input$id, auto.assign = FALSE, from = "2014-01-01")  # xts
    
    # format time to Highstocks format
    t  <- as.numeric(as.POSIXct(time(ts))) * 1000
    
    # convert to data frame with time column
    df <- data.frame(x = t, open=Op(ts), high=Hi(ts), low=Lo(ts), close=Cl(ts))
    colnames(df) <- c("x", "open", "high", "low", "close")
    
    # format data frame as JSON
    return(toJSONArray2(df, json=FALSE)) 
  })
  
  # load time series from local JSON file aapl.json
  getLocalTimeSeriesAsJSON <- reactive({
    require(rjson)
    # read in JSON data and convert to data frame
    json_file <- 'AAPL.json'
    json_data <- fromJSON(paste(readLines(json_file), collapse=""))
    return(json_data)
  })
  
  # Highcharts Highstocks
  output$highstock <- renderChart2({
    p <- Highcharts$new()
    p$chart(zoomType = "xy", type="candlestick")
    p$title(text = sprintf('%s Stock Price', input$id))

    p$series(name = input$id,
      data = getYahooTimeSeriesAsJSON(),
      tooltip = list(valueDecimals=2)
    )
  
    # Highstock template to create 
    # var chart = new Highcharts.StockChart({{{ chartParams }}}); 
    # rCharts just uses a chart.html template which creates new Highcharts.Chart
    p$setTemplate(script="highstock.html")  

    # set width and height of the plot and attach it to the DOM
    p$addParams(height = 400, width=1000, dom="highstock")
    
    # save chart as HTML page highstock.html for debugging
    #p$save(destfile = 'highstock-test.html')
    
    print(p)
  })
})