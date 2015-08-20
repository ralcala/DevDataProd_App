library(shiny)
library(caret)
library(e1071)

data(iris)

training <- iris
testing  <- iris

shinyServer(function(input, output) {
    observeEvent(input$exitapp, {
        stopApp(-1)
    })

#     pre_process <- reactive({
#         pre_obj <- switch(input$pre_processing,
#             "raw"        = preProcess(training, method = "pca"),
#             "normalize"  = preProcess(training, method = "pca"),
#             "standarize" = preProcess(training, method = "pca"),
#             "pca"        = preProcess(training, method = "pca")
#         )
#
#         predict(pre_obj, training)
#     })

    classifier <- reactive({
        method <- switch(input$classifier,
            "lda" = "lda",
            "qda" = "qda",
            "svm" = "rf",
            "dt"  = "rpart",
            "nb"  = "nb"
        )

        train(Species ~ ., data = training, method = method)
    })

    evaluation <- reactive({
        switch(input$evaluation,
            "Training" = "",
            "Cross-Validation" = "",
            "Testing" = ""
        )
    })

    prediction <- reactive({
        #training <- pre_process()
        model    <- classifier()
        pred     <- predict(model, testing)

        return(pred)
    })

    tab_pred <- reactive(
        table(prediction(), iris$Species)
    )

    output$result <- renderPlot({
        plot(iris$Sepal.Length, iris$Sepal.Width, col = prediction(), pch = 20, main = "Classification result", xlab = "Sepal length", ylab = "Sepal width")
        grid()
    })

    output$conf_matrix <- renderTable(
        confusionMatrix(prediction(), iris$Species)$accuracy
    )

    output$table <- renderTable(
        tab_pred()
    )

    output$accuracy <- renderText({
        sum(diag(tab_pred())) / length(iris$Species)
    })
})
