library(shinydashboard)

header <- dashboardHeader(title = "Iris classification")

sidebar <- dashboardSidebar(
    div(class = "logo",
        img(src = "images/classification.png")
    ),
    br(),
    sidebarMenu(
        menuItem("Help", tabName = "help", icon = icon("life-buoy")),
        menuItem("Classifiers", tabName = "classification", icon = icon("cogs")),
        menuItem("About", tabName = "about", icon = icon("info-circle"))
    ),
    br(),
    br(),
    br(),
    div(class = "exit",
        actionButton("exitapp", "Exit", icon = icon("close"))
    )
)

body <- dashboardBody(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css")
    ),
    tabItems(
        tabItem(tabName = "help",
            h2("Help and starting guide"),
            p("This is shoret a direct startiing guide to use the application. The main idea is to test several pre-processing methods and a few classifiers and see several classification metrics using different criterias for validation (same dataset, cross-validation and hold out/testing dataset)."),
            p("The application is based in the Shiny and ShinyDashboards packages from RStudio. It's ", a("hosted at ShinyApps.io", href = "https://ralcala.shinyapps.io/DevDataProd_App"), " from RStudio."),
            p("On the left part you'll find a sidebar with 3 menus:"),
            tags$ul(
                tags$li("Help"),
                tags$li("Classification"),
                tags$li("About")
            ),
            p("This is the help page associated with the Help menu."),
            p("The Classification page host the main application content: pre-processing options, classification algorithms and validation settings."),
            p("The About menu shows a small information page about the application and the author."),
            h3("How to use the app"),
            p("In the classification panel there will be 3 boxes for configuring the task:"),
            tags$ol(
                tags$li(
                    p("Pre-processing: how to modify the data before classifying."),
                    tags$ul(
                        tags$li("Raw (no transformation). ", em("This is the default.")),
                        tags$li("Normalization. Range 0..1"),
                        tags$li("Standarization. Mean 0, SD 1."),
                        tags$li("PCA (retain all components).")
                    ),
                    br()
                ),
                tags$li(
                    p("Next we have to choose which algorithm to use."),
                    tags$ul(
                        tags$li("LDA (Linear Discriminant). ", em("This is the default.")),
                        tags$li("QDA (Quadratic Discriminant)."),
                        tags$li("SVM /Suport Vector Machine)."),
                        tags$li("Decission Tree."),
                        tags$li("Naïve Bayes.")
                    ),
                    br()
                ),
                tags$li(
                    p("Finally an evaluation dataset must be selected."),
                    tags$ul(
                        tags$li("Training"),
                        tags$li("Testing. ", em("This is the default and best one."))
                    )
                )
            ),
            h3("What results are shown?"),
            p("First, a plot using the sepal attributes (height and width) is rendered with the color corresponding to the predicted Specie."),
            p("On the right side of the plot the confusion matrix and the accuracy metric will be shown. The app has been done intentuionally easy to use.")
        ),
        tabItem(tabName = "classification",
            h2("Classification"),
            fluidRow(
                box(title = "Pre-processing", width = 4, solidHeader = TRUE, status = "primary", collapsible = TRUE,
                    radioButtons("pre_processing", "Data processing:", c(
                        "Raw."        = "raw",
                        "Normalize."  = "normalize",
                        "Standarize." = "standarize",
                        "PCA."        = "pca"
                    )),
                    footer = "Will be applied to the data before classifying."
                ),
                box(title = "Classifiers", width = 4, solidHeader = TRUE, status = "primary", collapsible = TRUE,
                    selectInput("classifier", "Algorithm / ensemble method:", choices = c(
                        "LDA (Linear Discriminant)"    = "lda",
                        "QDA (Quadratic Discriminant)" = "qda",
                        "SVM (Support Vector Machine)" = "svm",
                        "Decission Tree" = "dt",
                        "Naïve Bayes"    = "nb"
                    )),
                    footer = "The defaults options for each algorithm / method will be used."
                ),
                box(title = "Evaluation", width = 4, solidHeader = TRUE, status = "primary", collapsible = TRUE,
                    radioButtons("evaluation", "Dataset to use:", selected = "testing", c(
                        "Training."         = "training",
                        #"Cross-Validation" = "cv",
                        "Testing."          = "testing"
                    )),
                    footer = "10 folds for cross-validation and 30 % for testing will be used."
                )
            ),
            fluidRow(
                column(width = 8,
                    plotOutput("result")
                ),
                column(width = 4,
                    tableOutput("conf_matrix"),
                    p(strong("Accuracy: "), textOutput("accuracy"))
                )
            )
        ),
        tabItem(tabName = "about",
            h2("About the app"),
            p("This app has been created in the context of the ", em("Developing Data Products"), " course in the Data Science Specialization from Coursera.org"),
            p("It has been created by ", strong("Roberto J. Alcalá Sánchez"), " and the related pitch presentation can be found in ", a("RPubs", href = "http://rpubs.com/ralcala/DevDataProd_Slides"), " and in ", a("GitHub Pages", href = "http://ralcala.github.io/DevDataProd_Slides"), ".")
        )
    )
)

shinyUI(dashboardPage(
    header,
    sidebar,
    body
))
