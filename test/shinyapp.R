library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  navbarPage("",
             tabPanel("tab",
                      div( id ="Sidebar",sidebarPanel(
                      )),
                      
                      
                      mainPanel(actionButton("showSidebar", "Show sidebar"),
                                actionButton("hideSidebar", "Hide sidebar")
                      )
             )
  )
)

server <-function(input, output, session) {
  observeEvent(input$showSidebar, {
    shinyjs::show(id = "Sidebar")
  })
  observeEvent(input$hideSidebar, {
    shinyjs::hide(id = "Sidebar")
  })
}

shinyApp(ui, server)  
