#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(knitr)
library(kableExtra)
library(magrittr)

HouseData<-read_csv("../data.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    output$summaryplot <- renderPlot({
        
        g<-ggplot(data=HouseData, aes_string(x=input$var, y="MEDV"))
        g+geom_point()


    })
    output$sum<-renderText({
        var<-input$var2
        sub<-HouseData[,var]
        tab<-apply(sub,2,summary)
        knitr::kable(tab,"html", digits = 1)
       
       

    })

})
