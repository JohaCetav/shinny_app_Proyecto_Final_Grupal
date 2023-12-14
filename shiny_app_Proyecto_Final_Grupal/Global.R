# Proyecto Final Shihy
# Integrantes:
# Nancy López
# Rebeca Rodríguez
# Johanna Salazar
# Instructora:
# Kimberley Orozco


library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(readr)
library(DT)
library(plotly)
library(shinyalert)
library(shinyjs)

# Leer los datos
Datos_texd <- read.csv("Datos/datos_TEDx.csv")


