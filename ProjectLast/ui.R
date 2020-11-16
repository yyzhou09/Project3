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
library(plotly)
library(caret)
library(rpart)
library(randomForest)

# Define UI for application that draws a histogram
dashboardPage(skin="purple",
              #add title
    dashboardHeader(title="ST 558 Final Project"),
    #add tabs
    dashboardSidebar(sidebarMenu(
        menuItem("Information", tabName = "info", icon = icon("info")),
        menuItem("Data Exploration", tabName = "data", icon = icon("eye")),
        menuItem("Unsupervised Learning",tabName="UL", icon=icon("sitemap")),
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
                                  h4("This app has five tabs on the left. Using the tab can lead you to the page for the corresponding information. The Data Exploration tab presents summary table and graphic for the dataset. The Unsupervised Learning tab includes a PCA or a cluster analysis for the data set based on the user's selection. The Model tab including two supervised learning models. The users can select if they want to use the Tree Prediction Model or the Random Forest Model. They can also select tuning paramters and variables they want to use to predict the MEDV value. They can choose the output (model results vs. prediction results). The Save tab allows the user to scroll through the data and save the data as a file.")
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
                                  plotlyOutput("summaryplot")                                       
                               
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
           )),
           #second tab ends here
                       
           # third tab for unspurvised learning
           tabItem(tabName = "UL",
                   fluidRow(
                       column(6,
                              box(title = "Results", width = NULL, solidHeader = TRUE, status = "warning",
                                verbatimTextOutput("ulresults")
                                  
                              )),
                       column(6, 
                              box(title = "Unsupervise Learning Plot", width = NULL, solidHeader = TRUE, status = "warning",
                                  plotOutput("ulplot",
                                             click = "plot_click",
                                             dblclick = "plot_dblclick",
                                             hover = "plot_hover",
                                             brush = "plot_brush"
                                  )
                              ),
                              box(title = "Select the Method", width = NULL, solidHeader = TRUE, status = "warning",
                                  radioButtons("RB",h3("Select a Choice Below"), choices=list("PCA","Clustering"), selected="PCA"),
                                  conditionalPanel(condition="input.RB=='Clustering'",
                                  selectInput("x","Select X Value", c("CRIM","ZN","INDUS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT","MEDV"), selected="CRIM"),
                                  selectInput("y","Select Y Value", c("CRIM","ZN","INDUS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT","MEDV"),  selected="ZN"))
                                  )
                                  
                   )
                       )
           ),
          
        #third tab ends here
    #fourth tab for supervised learning models, a tree model and a random forst model
    tabItem(tabName = "model",
            fluidRow(
                
                       #box to build the model
                       box(title = "Model Selection", width = NULL, solidHeader = TRUE, status = "warning", splitLayout(
                           radioButtons("models","Select a Model", choices = list("Tree", "Random Forest"), selected = "Tree"),
                           radioButtons("out","Select a Result Output", choices = list("Model Results","Prediction Results")),
                           selectInput("pre","Select Predictors", c("CRIM","ZN","INDUS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT"), selected="CRIM", multiple = TRUE),
                           conditionalPanel(condition="input.models=='Tree'",
                                            numericInput("cp", "complexity parameter", min=0.001, max = 1, value=0.01)
                                            ),
                           conditionalPanel(condition="input.models=='Random Forest'",
                                            numericInput("mtry","mtry", min = 1, max=12, value=1, step = 1))
                           
    
                       )),
                       
                      
                
                       #box to enter predictors values
                       box(title="Enter Predictor Values", width = NULL, solidHeader = TRUE, status = "primary",splitLayout(
                           numericInput("CRIM","CRIM",0),
                           numericInput("ZN","ZN",0),
                           numericInput("INDUS","INDUS",0),
                           numericInput("CHAS","CHAS 0 or 1", 0, min = 0, max=1, step =1),
                           numericInput("NOX", "NOX", 0),
                           numericInput("RM","RM",0),
                           numericInput("AGE","AGE", 0),
                           numericInput("DIS","DIS",0),
                           numericInput("RAD", "RAD",0),
                           numericInput("TAX", "TAX",0),
                           numericInput("PTRATIO", "PTRATIO",0),
                           numericInput("B","B",0),
                           numericInput("LSTAT","LSTAT",0)
                           
                       )),
                       #box to print results for model or prediction
                       box(title="Results", width = NULL, solidHeader = TRUE, status="primary",
                           verbatimTextOutput("results")
                           
                       ))
            ) #forth teb ends here
    
)))




### Dataset: https://www.kaggle.com/arslanali4343/real-estate-dataset