dashboardPage(skin = "black",
  dashboardHeader(title = "Popularity of Arduino Projects",
                  titleWidth = 300),
  
  dashboardSidebar(
    sidebarUserPanel('by John', image = "arduino.jpg"),
    
    sidebarMenu(
      menuItem("Background", tabName = "background",
               icon = icon("th-large", lib = "glyphicon")),
      menuItem("Data Table", tabName = "dt",
               icon = icon("database")),
      menuItem("Exploration", tabName = "exploration",
               icon = icon("camera", lib = "glyphicon")),
      menuItem("Model Construction", tabName = "construction",
               icon = icon("refresh", lib = "glyphicon")),
      menuItem("Prediction", tabName = "prediction",
               icon = icon("sort", lib = "glyphicon"))
    )
  ),
  
  dashboardBody(tabItems(
    #background page
    tabItem(tabName = "background",
            fluidRow(box("From Arduino website: \"Arduino is an open-source electronics platform based on easy-to-use hardware and software.\"",
                "In other words: Arduino devices are microcontrollers and other hardware for educational and prototyping purposes.",
                         footer = "I love to build things using Arduino, but should I publish my amateur projects on https://create.arduino.cc/projecthub ?", title = "What is Arduino?",
                         width = '100%')),
            fluidRow(img(src="my_project.jpg", align = 'center', width = 300),
                     img(src="2018-01-21 16.31.42.jpg", align = 'center', width = 300)),
            fluidRow(box("I scraped the Arduino project hub and used statistics to get a sense of what kind of response I might receive as a rookie creator.",
                         footer = "I consider two main stat groups: project topics and creator experience. Are certain topics better-received? Does developer experience matter?",
                         width = '100%'))
    ),
    
    
    #data page
    tabItem(tabName = "dt",
            fluidRow(box(paste(names(use_data)[1], names(use_data)[2], names(use_data)[3],
                         names(use_data)[4], names(use_data)[5], names(use_data)[6],
                         names(use_data)[7], names(use_data)[8], names(use_data)[9],
                         "and Boolean columns for each topic.", sep = ', '),
                         title = "Variables"),
                     box(selectInput("bool_vect",
                                     label = "Select Topic Label Vector",
                                     choices = selected_topics,
                                     selected = "arduino"
                     ))),
            fluidRow(box(dataTableOutput("exploreTable"), width = '100%'))
            ),
    
    #scatterplot
    tabItem(tabName = "exploration",
            fluidRow(box(title = "Select Axes for Scatterplot to Investigate Linear Relationship",
                         width = '100%')),
            
            fluidRow(box(selectInput("xaxis",
                             label = "Select X-axis",
                             choices = names(use_data),
                             selected = "Followers")),
                      box(selectInput("yaxis",
                             label = "Select Y-axis",
                             choices = names(use_data),
                             selected = "RespectPerView"))),
            
            fluidRow(box(plotOutput("scatter"), width = '100%'))
            ),
    
    #construct model
    tabItem(tabName = "construction",
         fluidRow(box(checkboxGroupInput("checkgroup",
                                            h3("Select Predictors for Linear Model. Box-Cox Applied by Default"),
                                            inline = TRUE,
                                            choices = names(predict_data)[!(names(predict_data) == "RespectPerView")],
                                            selected = names(predict_data)[!(names(predict_data) == "RespectPerView")]),
                                            width = '100%')),   
            fluidRow(
              column(4,
                     dataTableOutput("VFIS")),
              column(8,
                     verbatimTextOutput("summary"))
            )),
    
    
    tabItem(tabName = "prediction",
            fluidRow(box(checkboxGroupInput("checkgroup2",
                                            h3("Select Topics of your Arduino Project"),
                                            inline = TRUE,
                                            choices = selected_topics),
                         width = '100%')),
            fluidRow(box(selectInput("followers",
                                     label = "Enter Number of Followers",
                                     choices = 0:max(use_data$Followers),
                                     selected = 0)),
                     box(selectInput("projects",
                                     label = "Enter Number of Projects",
                                     choices = 0:max(use_data$Projects),
                                     selected = 0))),
            fluidRow(infoBoxOutput("infobox", width = '100%'))
            
            
      
    )
            
    
  ))
)
