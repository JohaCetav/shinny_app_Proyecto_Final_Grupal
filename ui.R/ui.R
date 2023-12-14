# Proyecto Final Shihy
# Integrantes:
# Nancy López
# Rebeca Rodríguez
# Johanna Salazar
# Instructora:
# Kimberley Orozco

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "Charlas TEDx"),
  dashboardSidebar(
    tags$head(
      tags$style(
        HTML(
          ".irs .irs-line, .irs .irs-single, .irs .irs-bar {
            background-color: #DD4B39 !important;
          }"
        )
      )
    ),
    sidebarMenu(
      menuItem("Duración/Vistas", tabName = "scatter_tab"),
      menuItem("Views por año", tabName = "line_tab"),
      menuItem("Conferencistas por Año", tabName = "speakers_tab"),
      menuItem("Tabla General", tabName = "table_tab")
    )
  ),
  dashboardBody(
    useShinyjs(),
    tabItems(
      tabItem("scatter_tab",
              sidebarLayout(
                sidebarPanel(
                  selectInput("scatter_event_input", "Seleccionar event", 
                              choices = c("Todos", unique(Datos_texd$event))),
                  htmlOutput("scatter_dummy_output")
                ),
                mainPanel(
                  plotlyOutput("scatter_plot")
                )
              )
      ),
      tabItem("line_tab",
              sidebarLayout(
                sidebarPanel(
                  sliderInput("line_year_input", "Seleccionar año", 
                              min = min(Datos_texd$published_year), 
                              max = max(Datos_texd$published_year), 
                              value = c(min(Datos_texd$published_year), max(Datos_texd$published_year)),
                              step = 1),
                  selectInput("line_metric_input", "Seleccionar métrica", 
                              choices = c("views", "likes"),
                              selected = "views"),
                  htmlOutput("line_dummy_output")
                ),
                mainPanel(
                  plotlyOutput("line_plot"),
                  downloadButton("download_line_data", "Descargar Datos", class = "btn-danger")
                )
              )
      ),
      tabItem("speakers_tab",
              sidebarLayout(
                sidebarPanel(
                  htmlOutput("speakers_by_year_dummy_output"),
                  sliderInput("line_chart_year_input", "Seleccionar año", 
                              min = min(Datos_texd$published_year), 
                              max = max(Datos_texd$published_year), 
                              value = c(min(Datos_texd$published_year), max(Datos_texd$published_year)),
                              step = 1)
                ),
                mainPanel(
                  plotlyOutput("speakers_by_year_line_chart")
                )
              )
      ),
      tabItem("table_tab",
              mainPanel(
                selectInput("info_metric_input", "Seleccionar Métrica", choices = c("views", "likes"), selected = "views"),
                plotlyOutput("info_plot")
              )
      )
    )
  )
).   