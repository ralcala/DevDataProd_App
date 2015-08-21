library(shiny)
library(caret)

# Loaded explicitely, otherwise deplyment in shinyapps.io wan't detect this dependencies
# and will not install them, so the app will fail.
library(e1071)
library(randomForest)
library(klaR)
library(kernlab)


data(iris)

#options(error = recover)
set.seed(1234)

in_train <- createDataPartition(iris$Species, p = 0.7, list = FALSE)
iris_train <- iris[ in_train, ]
iris_test  <- iris[-in_train, ]


shinyServer(function(input, output) {
    observeEvent(input$exitapp, {
        stopApp(-1)
    })

    pre_process <- reactive({
        switch(input$pre_processing,
            "raw"        = NULL,
            "normalize"  = preProcess(iris_train[, 1:4], method = "range"),
            "standarize" = preProcess(iris_train[, 1:4], method = c("center", "scale")),
            "pca"        = preProcess(iris_train[, 1:4], method = "pca", pcaComp = 4)
        )
    })

    classifier <- reactive({
        method <- switch(input$classifier,
            "lda" = "lda",
            "qda" = "qda",
            "svm" = "svmLinear",
            "dt"  = "rpart",
            "nb"  = "nb"
        )

        if (is.null(pre_process())) {
            data <- iris_train
        }
        else {
            data <- predict(pre_process(), iris_train[, 1:4])
            data$Species <- iris_train$Species
        }

        train(iris_train$Species ~ ., method = method, data = data)
    })

    evaluation <- reactive({
        switch(input$evaluation,
            "training"         = iris_train,
            #"Cross-Validation" = "",
            "testing"          = iris_test
        )
    })

    prediction <- reactive({
        if (is.null(pre_process())) {
            data <- evaluation()
        }
        else {
            data <- predict(pre_process(), evaluation()[, 1:4])
            data$Species <- evaluation()$Species
        }

        model <- classifier()
        pred  <- predict(model, data)

        return(pred)
    })

    tab_pred <- reactive(
        table(prediction(), evaluation()$Species)
    )

    output$result <- renderPlot({
        plot(iris$Sepal.Length, iris$Sepal.Width, col = prediction(), pch = 20, main = "Classification result", xlab = "Sepal length", ylab = "Sepal width")
        grid()
    })

    output$conf_matrix <- renderTable(
        tab_pred()
    )

    output$accuracy <- renderText({
        sum(diag(tab_pred())) / length(evaluation()$Species)
    })
})
