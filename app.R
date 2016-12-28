library(shiny)
library(ggplot2)
library(dplyr)



all_species <- read.csv("./data/acoustic_shiny.csv") # creates a relative path to the dataset. The data must be in a folder labled "data" within the project folder. 
ui <- fluidPage(   # The ui defines the user inerface of the app. Each shiny apphas a UI and a server 
  titlePanel("Quick Acoustic Data Visualization"), #defines the title to appear in the app 
  sidebarLayout( # defines that the following will occur in a sidebar 
    sidebarPanel(
      radioButtons("species_input", "Select a species",    # here we are using buttons to choose which species you want to look at more closely
                   choices = c("Lano", "Laci", "Tabr", "Myca"), # species input is how reference the choice made here in the server. 
                   selected = "Lano"), # select a species is what will appear in the app. the four choices are the four most common species in the dataset
      img(src="SkyLions.png", height = 200, width = 200) # this adds the MBC Logo in the side panel
    ),
    
    
    # 
    mainPanel(  # here we have  the specs forthe main panel layout
      plotOutput("acoustic_viz") # for the main panel all we want is to have the plot output. 
    )
  )
)


server <- function(input, output) { #server is the place that you reference what is done in the app to the data 
  output$acoustic_viz <- renderPlot({ # here I specifiy that I want the output to be a plot 
    filtered <-  # here I am doing a tidyr but it is reactive to the species$input. What ever is selected in the app is what will be filtered 
      all_species %>% # here and used to produce the ggplot
      filter(Consensus == input$species_input)
    
  
   plot <- ggplot(filtered, aes(julian,n, colour = Consensus)) + geom_bar(stat="identity") # we use the filtered species to generate a ggplot
   plot <- plot + facet_wrap(~year,nrow = 2, scales = "free_y") 
   plot <- plot + theme_bw() + scale_y_continuous("Calls/Night") + scale_x_continuous("Julian Date")
   plot
  })
}

shinyApp(ui = ui, server = server) # The app must end with this call in order to work. 