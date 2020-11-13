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
library(DT)
library(knitr)
library(kableExtra)
library(magrittr)


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
         # add content for the first infomation tab
           tabItem(tabName = "info",
                   fluidRow(
                       #add two columns
                       column(width=6,
                              h1("what is the data?"),
                              box(background = "purple", width = 12,
                                  h4("This is data set is for housing values in suburbs of Boston. This data comes from ", a(href = "https://www.kaggle.com/arslanali4343/real-estate-dataset/", "kaggle"),  "- originally from the tatLib library which is maintained at Carnegie Mellon University."),
                                  h4("It includes 506 records. It has 13 continuous attributes and 1 binary attribute"),
                                  h4(strong("CRIM:")," per capita crime rate by town. "),
                                  h4(strong("ZN:")," proportion of presidential land zoned for lots over 25,000 sq.ft."),
                                  h4(strong("INDUS:")," proportion of non-retail business acres per town."),
                                  h4(strong("CHAS:")," Charles River dummy variable (= 1 if tract bounds river; 0 otherwise)."),
                                  h4(strong("NOX:")," nitric oxides concentration (parts per 10 million)."),
                                  h4(strong("RM:")," average number of rooms per dwelling."),
                                  h4(strong("AGE:")," proportion of owner-occupied units built prior to 1940."),
                                  h4(strong("DIS:")," weighted distances to five Boston employment centres."),
                                  h4(strong("RAD:")," index of accessibility to radial highways."),
                                  h4(strong("TAX:")," full-value property-tax rate per $10,000.")
                                  
                                  
                              )
                           
                       ),
                       # second column
                       column(6,
                              h1("Purpose and Navigation of the App"),
                              box(background = "purple", width=12,
                                  h4("This app is used to explore the data set in several ways, including data exploration, data modeling, using unsupervised methods (i.e., PCA) and make a subset of the data and save it."),
                                  h4("This app has five tabs on the left. Using the tab can lead you to the page for the corresponding information. The Data Exploration tab presents summary table and graphic for the dataset. The PCA tab includes a PCA analysis for the data set. The Model tab including two supervised learning models. The Save tab allows the user to scroll through the data and save the data as a file.")
                                  )
                              )
                       
                   )
                  ),
           #the second tab for data exploration
           tabItem(tabName = "data",
                   fluidRow(
                       # first column for athe graphic
                       column(width = 6,
                              #box for variable selection for graphic
                              box(
                                  title = "Variable Selection for Graphic Below", width = NULL, solidHeader = TRUE, status = "primary",
                                  selectInput("var",h3("Select One Variable From the List Below"),choices=list("CRIM","ZN","INDUS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT","MEDV"),selected = "CRIM" )),
                              #graphic box
                              box(
                                  title = "Graphic", width = NULL, solidHeader = TRUE, status = "primary",
                                  plotOutput("summaryplot")
                               
                              ),
                              box(title="Save Plot", width = NULL, status = "primary",
                                  downloadButton(outputId = "down", label = "Download the Plot")
                                  )

                       ),
                       #second column for graphic and table
                       column(width = 6,
                            #box for varialbe selection for table
                              box(
                                  title = "Varible Selection for the Table Below", width = NULL, solidHeader = TRUE, status = "warning",
                                  selectInput("var2",h3("Select Variables From the List Below"),choices=list("CRIM","ZN","INDUS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT","MEDV"),selected = "CRIM", multiple = TRUE )
                              ),
                            #table box
                              box(
                                  title = "Table", width = NULL, solidHeader = TRUE, status = "warning",
                                  htmlOutput("sum")
                              )
                       )
           )) #second tab ends here
                       
               
          
                 
        
    )
))




### Dataset: https://www.kaggle.com/arslanali4343/real-estate-dataset