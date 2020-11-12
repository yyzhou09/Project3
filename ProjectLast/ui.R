#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(skin="purple",
              #add title
    dashboardHeader(title="ST 558 Final Project"),
    #add tabs
    dashboardSidebar(sidebarMenu(
        menuItem("Information", tabName = "info", icon = icon("info")),
        menuItem("Data Exploration", tabName = "data", icon = icon("eye")),
        menuItem("PCA",tabName="pca", icon=icon("sitemap")),
        menuItem("Model", tabName = "model", icon = icon("laptop")),
        menuItem("Save File", tabName = "save", icon = icon("save"))
    )),
    dashboardBody()
)



### Dataset: https://www.kaggle.com/arslanali4343/real-estate-dataset