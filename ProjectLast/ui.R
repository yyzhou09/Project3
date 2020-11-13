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
    dashboardBody(
        tabItems(
           tabItem(tabName = "info",
                   fluidRow(
                       #add two columns
                       column(width=6,
                              h1("what is the data?"),
                              box(background = "purple", width = 12,
                                  h4("This is data set is for housing values in suburbs of Boston."),
                                  h4("It includes 506 records. It has 13 continuous attributes and 1 binary attribute"),
                                  h4("CRIM: per capita crime rate by town. "),
                                  h4("ZN: proportion of presidential land zoned for lots over 25,000 sq.ft."),
                                  h4("INDUS: proportion of non-retail business acres per town."),
                                  h4("CHAS: Charles River dummy variable (= 1 if tract bounds river; 0 otherwise)."),
                                  h4("NOX: nitric oxides concentration (parts per 10 million)."),
                                  h4("RM: average number of rooms per dwelling."),
                                  h4("AGE: proportion of owner-occupied units built prior to 1940."),
                                  h4("DIS: weighted distances to five Boston employment centres."),
                                  h4("RAD: index of accessibility to radial highways."),
                                  h4("TAX: full-value property-tax rate per $10,000.")
                                  
                                  
                              )
                           
                       ),
                       column(6,
                              h1("Purpose and Navigation of the App"),
                              box(background = "purple", width=12,
                                  h4("This app is used to explore the data set in several ways, including data exploration, data modeling, using unsupervised methods (i.e., PCA) and make a subset of the data and save it."),
                                  h4("This app has five tabs on the left. Using the tab can lead you to the page for the corresponding information. The Data Exploration tab presents summary table and graphic for the dataset. The PCA tab includes a PCA analysis for the data set. The Model tab including two supervised learning models. The Save tab allows the user to scroll through the data and save the data as a file.")
                                  )
                              )
                       
                   )
                  )
                 
        
    )
)
)



### Dataset: https://www.kaggle.com/arslanali4343/real-estate-dataset