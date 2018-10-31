# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  output$exploreTable = renderDataTable({
    datatable(select(use_data, c(1,4:8,10, input$bool_vect)), rownames = FALSE) %>%
      formatStyle(., input$bool_vect, background="skyblue", fontWeight='bold')
  })
  
  output$scatter = renderPlot({
    xdata = use_data[input$xaxis]
    ydata = use_data[input$yaxis]
    print(xdata[,])
    plot(ydata[,] ~ xdata[,], xlab = input$xaxis, ylab = input$yaxis)
  })
  
  output$VFIS = renderDataTable({
    this_data = select(predict_data, append(c("RespectPerView"), input$checkgroup))
    model2 = lm(RespectPerView ~ ., data = this_data)
    
    these_vfis = vif(model2)
    datatable(data.frame(these_vfis))
  })
  
  output$summary = renderPrint({
    this_data = select(predict_data, append(c("RespectPerView"), input$checkgroup))
    model2 = lm(RespectPerView ~ ., data = this_data)
    
    capture.output(summary(model2))
  })
  
  
  output$infobox = renderInfoBox({
    this_data = select(predict_data, append(c("RespectPerView"), input$checkgroup))
    model2 = lm(RespectPerView ~ ., data = this_data)
    
    new_dat = predict_data[1,]
    new_dat[1,] = 0
    new_dat[1,names(new_dat) %in% input$checkgroup2] = 1
    
    new_dat$Followers = as.numeric(input$followers)
    new_dat$Project = as.numeric(input$projects)
    
    prediction = predict(model2, newdata = new_dat)
    
    infoBox(
      "Predicted Respects Per Views", prediction, icon = icon("list"),
      color = "purple", width = '100%'
    )
  })
  
})
