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
library(caret)
library(randomForest)

HouseData<-read_csv("../data.csv")
HouseData<-na.omit(HouseData)
PCs<-prcomp(~ ., data=HouseData, na.action=na.omit, scale=TRUE)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
#create a plot for summary
    myplot<-function(){
        g<-ggplot(data=HouseData, aes_string(x=input$var, y="MEDV"))
        g+geom_point()  
    }

    output$summaryplot <- renderPlotly({
        ggplotly(myplot())
        
    })
#add  function to save the picture
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
   #prient the summary results for selected variables 
    output$sum<-renderText({
        var<-input$var2
        sub<-HouseData[,var]
        tab<-apply(sub,2,summary)
        knitr::kable(tab,"html", digits = 1)
       
       

    })
#put selected data in a new dataframe for the unspervised models
    selectedData <- reactive({
        HouseData[, c(input$x, input$y)]
    })
 #create plot for unsupervise ldearing models   
output$ulplot<-renderPlot({
    if(input$RB=="PCA"){
    biplot(PCs, cex=1, xlim=c(-0.08,0.08))
   }
   if (input$RB=="Clustering"){
       hierCluster<-hclust(dist(data.frame(selectedData()[,1],selectedData()[,2])))
        plot(hierCluster,xlab="")
        }
    
})

#print unsuprvised learning results
output$ulresults<-renderPrint({
    if (input$RB=="PCA"){
     print(PCs)}
    if (input$RB=="Clustering"){
        hierCluster<-hclust(dist(data.frame(selectedData()[,1],selectedData()[,2])))
    print(hierCluster)}
    
})

#create a dataframe for supervised learning
selectedData2 <- reactive({
    HouseData[, c("MEDV",input$pre)]
})

#create a data frame for predictors, which are entered by users
predData<-reactive({
    data<-data.frame(CRIM=input$CRIM,
               ZN=input$ZN,
               INDUS=input$INDUS,
               CHAS=input$CHAS,
               NOX=input$NOX,
               RM=input$RM,
               AGE=input$AGE,
               DIS=input$DIS,
               RAD=input$RAD,
               TAX=input$TAX,
               PTRATIO=input$PTRATIO,
               B=input$B,
               LSTAT=input$LSTAT)
})

#only select predictors that users select for the model
predData2<-reactive({
    predData()%>% select(input$pre)
})

#create a tree model
tree<-reactive({
    train(MEDV ~., data=selectedData2(), method="rpart", trControl=trainControl(method="cv", number = 10), preProcess=c("center","scale"), tuneGrid=data.frame(cp=input$cp))
})

#create a random forest model
rf<-reactive({
    train(MEDV ~., data=selectedData2(), method="rf", trControl=trainControl(method="cv", number = 10), preProcess=c("center","scale"), tuneGrid=data.frame(mtry=input$mtry))
})

#prediction using tree model
tree_pred<-reactive({
    predict(tree(), predData2())
})

#prediction using random forest model
rf_pred<-reactive({
    predict(rf(), predData2())
})

# print out results based on users input
output$results <-renderPrint({
    set.seed(101)
    if (input$models=="Tree"){
        
        if(input$out=="Model Results"){
        print(tree())}
        if(input$out=="Prediction Results") {
            print(tree_pred())
        }
    }
    else {
       
        if(input$out=="Model Results"){
           print(rf()) 
        } else {
            print(rf_pred())
        }
        
    }
})

#create a data frame to be print out
datasetInput<-reactive({
    HouseData[,input$set]
})
#for the fifth tab data table
output$datatb<-DT::renderDataTable({
    datasetInput()
})

#for download csv file
output$downloadData <- downloadHandler(
    filename = function() {
        paste(input$set, ".csv", sep = "")
    },
    content = function(file) {
        write.csv(datasetInput(), file, row.names = FALSE)
    }
)

})
