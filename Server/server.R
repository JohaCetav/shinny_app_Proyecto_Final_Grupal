# Proyecto Final Shihy
# Integrantes:
# Nancy López
# Rebeca Rodríguez
# Johanna Salazar
# Instructora:
# Kimberley Orozco


server <- function(input, output, session) {
  
  
  filtered_scatter_data <- reactive({
    data <- Datos_texd
    if (input$scatter_event_input != "Todos") {
      data <- data[data$event == input$scatter_event_input, ]
    }
    return(data)
  })
  
  
  output$scatter_plot <- renderPlotly({
    data <- filtered_scatter_data()
    scatter <- plot_ly(data, x = ~duration, y = ~views, color = ~published_year, 
                       text = ~paste("Event: ", event),
                       mode = "markers", marker = list(size = 10, opacity = 0.7))
    scatter <- scatter |>  layout(title = "Relación entre Duración y Vistas",
                                  xaxis = list(title = "Duración (en segundos)"),
                                  yaxis = list(title = "Vistas"),
                                  showlegend = TRUE)
    scatter
  })
  
  
  observeEvent(input$scatter_event_input, {
    shinyalert(
      "scatter_plot",
      title = "Éxito",
      text = "¡Has seleccionado un evento!",
      type = "success"
    )
  })
  
  output$scatter_dummy_output <- renderUI({
    tagList()
  })
  
  filtered_line_data <- reactive({
    data <- Datos_texd
    data <- data[data$published_year >= input$line_year_input[1] & data$published_year <= input$line_year_input[2], ]
    return(data)
  })
  
  output$line_plot <- renderPlotly({
    data <- filtered_line_data()
    count_data <- data |> 
      group_by(published_year) |> 
      summarise(count = sum(.data[[input$line_metric_input]]))
    line_plot <- plot_ly(count_data, x = ~published_year, y = ~count, type = "scatter", mode = "lines+markers",
                         text = ~paste("Año: ", published_year, "<br>Métrica: ", count),
                         marker = list(color = "#DD4B39", size = 10, opacity = 0.7),
                         line = list(color = "#DD4B39", width = 1.5))  
    line_plot <- line_plot |>  layout(title = paste("Cantidad de ", input$line_metric_input, " TEDx por Año"),
                                      xaxis = list(title = "Año"),
                                      yaxis = list(title = input$line_metric_input),
                                      showlegend = FALSE)
    return(line_plot)
  })
  
  output$line_dummy_output <- renderUI({
    tagList()
  })
  
 
  output$download_line_data <- downloadHandler(
    filename = function() {
      paste("line_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      
      data <- filtered_line_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
  
  output$speakers_by_year_table <- renderDT({
    speakers_data <- Datos_texd |> 
      group_by(.data[[input$speakers_by_year_input]]) |> 
      summarise(speakers_count = n_distinct(speaker))
    col_name <- ifelse(input$speakers_by_year_input == "speaker", "Conferencista", "Fecha de Publicación")
    colnames(speakers_data) <- c(col_name, "Cantidad de Conferencistas")
    return(DT::datatable(speakers_data, options = list(pageLength = 50)))
  })
  
  output$speakers_by_year_dummy_output <- renderUI({
    tagList()
  })
  
  output$speakers_by_year_line_chart <- renderPlotly({
    data <- Datos_texd
    data <- data[data$published_year >= input$line_chart_year_input[1] & data$published_year <= input$line_chart_year_input[2], ]
    conference_count <- data |> 
      group_by(published_year) |> 
      summarise(conference_count = n())
    line_chart <- plot_ly(conference_count, x = ~published_year, y = ~conference_count, type = "scatter", mode = "lines+markers",
                          text = ~paste("Año: ", published_year, "<br>Conferencias: ", conference_count),
                          marker = list(color = "#DD4B39", size = 10, opacity = 0.7),
                          line = list(color = "#DD4B39", width = 1.5))  
    line_chart <- line_chart |>  layout(title = "Cantidad de Conferencias TEDx por Año",
                                        xaxis = list(title = "Año"),
                                        yaxis = list(title = "Cantidad de Conferencias"),
                                        showlegend = FALSE)
    return(line_chart)
  })
  
  output$speakers_by_year_dummy_output <- renderUI({
    tagList()
  })
  
  
  output$info_plot <- renderPlotly({
    info_data <- head(Datos_texd, 10)  
    
    
    info_plot <- plot_ly(info_data, x = ~speaker, type = "bar",
                         marker = list(color = "#DD4B39"))
    
    info_plot <- info_plot |>  layout(title = "Top 10 Conferencistas por Vistas",
                                      xaxis = list(title = "Conferencista"),
                                      yaxis = list(title = "Vistas"))
    
    return(info_plot)
  })
  
  output$info_table <- renderUI({
    
    selectInput("info_metric_input", "Seleccionar Métrica", choices = c("views", "likes"), selected = "views")
  })
  
  
  observe({
    info_data <- head(Datos_texd, 10)  
    
    
    info_plot <- plot_ly(info_data, x = ~speaker, y = ~.data[[input$info_metric_input]], type = "bar",
                         marker = list(color = "#DD4B39"))
    
    info_plot <- info_plot |>  layout(title = paste("Top 10 Conferencistas por ", input$info_metric_input),
                                      xaxis = list(title = "Conferencista"),
                                      yaxis = list(title = input$info_metric_input))
    
    
    output$info_plot <- renderPlotly(info_plot)
  })
}


shinyApp(ui, server)