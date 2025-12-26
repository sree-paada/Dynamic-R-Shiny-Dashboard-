library(shiny)
library(shinydashboard)
library(dplyr)
library(rlang)
library(readr)
library(tidyverse)
library(ggplot2)
library(shinyjs)

winsorize <- function(x, lower = 0.05, upper = 0.95) {
  qnt <- quantile(x, probs = c(lower, upper), na.rm = TRUE)
  x[x < qnt[1]] <- qnt[1]  
  x[x > qnt[2]] <- qnt[2]  
  return(x)
}


generate_dynamic_dashboard <- function(data, transformations_q1 = list(), plots_q1 = list(), transformations_q2 = list(), plots_q2 = list(), filters = character(), label_map = list(), dashboard_title, q1_page, q2_page) {
  
  ui <- dashboardPage(
    dashboardHeader(title = tags$span(dashboard_title, style = "font-size: 18px; white-space: nowrap; overflow: hidden;")),
    dashboardSidebar(
      useShinyjs(), 
      div(style = "padding: 15px;",
          h3("Dashboard Pages"),
          sidebarMenu(
            menuItem(q1_page, tabName = "Question1", icon = icon("chart-line")),
            menuItem(q2_page, tabName = "Question2", icon = icon("chart-bar"))
          )),
      width = 300,  # Adjust sidebar width
      div(style = "padding: 15px;",
          h3("Preprocessing Options"),
          checkboxInput("remove_duplicates", "Remove Duplicates", TRUE),
          checkboxInput("remove_nulls", "Remove Null Values", TRUE),
          checkboxInput("robust_scaling", "Apply Robust Scaling for Outliers", TRUE),
          actionButton("apply_preprocessing", "Apply Preprocessing")
      )
    ),
    dashboardBody(
      fluidRow(
        lapply(filters, function(f) {
          column(4, selectInput(inputId = f,
                                label = paste("Select", if (!is.null(label_map[[f]])) label_map[[f]] else f),
                                choices = unique(data[[f]]),
                                selected = unique(data[[f]])[1],
                                multiple = TRUE))
        })
      ),
      tabItems(
        tabItem(tabName = "Question1",
                fluidRow(
                  lapply(seq_along(plots_q1), function(i) {
                    box(width = 12, plotOutput(paste0("plot1_", i)))
                  })
                )
        ),
        tabItem(tabName = "Question2",
                fluidRow(
                  lapply(seq_along(plots_q2), function(i) {
                    box(width = 12, plotOutput(paste0("plot2_", i)))
                  })
                )
        )
      )
    )
  )
  
  server <- function(input, output, session) {
    
    processed_data <- reactiveVal(data)

    observeEvent(input$apply_preprocessing, {
      df <- data
      
      if (input$remove_duplicates) {
        df <- df[!duplicated(df), ]
      }
      
      if (input$remove_nulls) {
        df <- df[complete.cases(df), ]
      }
      
      if (input$robust_scaling) {
        df[] <- lapply(df, function(x) if (is.numeric(x)) winsorize(x) else x)
      }

      processed_data(df)
    })
    
    filtered_data <- reactive({
      df <- processed_data()
      for (f in filters) {
        selected <- input[[f]]
        if (!is.null(selected) && length(selected) > 0) {
          df <- df %>% filter(.data[[f]] %in% selected)
        }
      }
      df
    })
    
    lapply(seq_along(plots_q1), function(i) {
      output[[paste0("plot1_", i)]] <- renderPlot({
        df_q1 <- filtered_data()
        for (t in transformations_q1[[i]]) {
          df_q1 <- t(df_q1)
        }
        plots_q1[[i]](df_q1)
      })
    })
    
    lapply(seq_along(plots_q2), function(i) {
      output[[paste0("plot2_", i)]] <- renderPlot({
        df_q2 <- filtered_data()
        for (t in transformations_q2[[i]]) {
          df_q2 <- t(df_q2)
        }
        plots_q2[[i]](df_q2)
      })
    })
  }
  
  shinyApp(ui, server)
}

