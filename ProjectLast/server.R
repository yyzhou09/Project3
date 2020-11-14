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
library(plotly)

HouseData<-read_csv("../data.csv")
PCs<-prcomp(~ ., data=HouseData, na.action=na.omit, scale=TRUE)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    myplot<-function(){
        g<-ggplot(data=HouseData, aes_string(x=input$var, y="MEDV"))
        g+geom_point()  
    }

    output$summaryplot <- renderPlotly({
        ggplotly(myplot())
        
    })

    output$down <- downloadHandler(
        filename =  function() {
            paste0(input$var, ".png")
        },
        # content is a function with argument file. content writes the plot to the device
        content = function(file) {
            
                png(file, width = 980, height = 400, units = "px", pointsize = 12, bg = "white", res = NA) # open the png device
                print(myplot())
            dev.off()  # turn the device off
            
        }, 
        contentType = 'image/png'
    )
    
    output$sum<-renderText({
        var<-input$var2
        sub<-HouseData[,var]
        tab<-apply(sub,2,summary)
        knitr::kable(tab,"html", digits = 1)
       
       

    })
#put selected data in a new dataframe
    selectedData <- reactive({
        HouseData[, c(input$x, input$y)]
    })
    
output$ulplot<-renderPlot({
    if(input$RB=="PCA"){
    biplot(PCs, cex=1, xlim=c(-0.08,0.08))
   }
   if (input$RB=="Clustering"){
       hierCluster<-hclust(dist(data.frame(selectedData()[,1],selectedData()[,2])))
        plot(hierCluster,xlab="")
        }
    
})

output$ulresults<-renderPrint({
    if (input$RB=="PCA"){
     print(PCs)}
    if (input$RB=="Clustering"){
        hierCluster<-hclust(dist(data.frame(selectedData()[,1],selectedData()[,2])))
    print(hierCluster)}
    
})

})
