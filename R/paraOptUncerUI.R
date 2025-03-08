
# Graphical user interface for Optimization/Uncertainty

paraOptUncerUI <- function(id) {

  # NS(id) returns a namespace function, which was save as `ns` and will
  # invoke later.
  
  ns <- NS(id)
  
  tagList(
    
    fluidRow(
      
      #-------------------------------------------------------------------------
      # 1. Input behavioral threshold
      #-------------------------------------------------------------------------
      column(width = 10,
             numericInput("behThreshold", 
                          "1. Input behavioral threshold",
                          value = 0.5,
                          step = 0.05,
                          min = 0,
                          max = 1,
                          width = "25%"),
      ),
      
      column(width = 10,
             verbatimTextOutput("printMaxBehThreshold"),
      ),


      #-------------------------------------------------------------------------
      # 4. Input variable number to plot
      #-------------------------------------------------------------------------       
      column(width = 10,
             sliderInput("plotVarNumber", 
                         "2. Input variable number to plot", 
                         value = 1, 
                         min = 1, 
                         max = 2,
                         step = 1,
                         round = TRUE,
                         width = "25%"),
             ),
      
      column(width = 10,
             checkboxInput("checkPlotVariableNumber", 
                           "Display plot",
                           width = '100%'),
             ),

      conditionalPanel(
        
        condition = "input.checkPlotVariableNumber == 1",
        column(width = 10,
               actionButton("savePlotVariableNumber", "Click here to save plot"),
               plotlyOutput("PlotVariableNumber"),
               
        ),
      ),
      
      # Display behavioral simulation table
      column(width = 10,
             checkboxInput("checkTableBehaSim", "Display table of the above plot"),
      ),
      conditionalPanel(
        condition = "input.checkTableBehaSim== 1",
        column(width = 10,
               excelOutput("tableBehaSim", 
                           width = "100%", 
                           height = "1px"),
        ),
      ),

      # Display behavioral parameter range
      column(width = 10,
             checkboxInput("checkTableBehaParam", 
                           "Display table of behavioral parameter range"),
      ),
      conditionalPanel(
        condition = "input.checkTableBehaParam== 1",
        column(width = 10,
               excelOutput("tableBehaParam", 
                           width = "100%", 
                           height = "1px"),
        ),
      ),

      # Display behavioral parameter range
      column(width = 10,
             checkboxInput("checkPandRFactor", "Display p-factor and r-factor"),
      ),
      conditionalPanel(
        condition = "input.checkPandRFactor== 1",
        column(width = 10,
               verbatimTextOutput("printPandRFactor", placeholder = TRUE),
        ),
      ),

      #-------------------------------------------------------------------------
      # 4. Save result
      #-------------------------------------------------------------------------
      div( style = "margin-top: 5em",  
           column(width = 10,
                  HTML("<b>","3. Save all results","</b>"),
           ),
           column(width = 10,
                  actionButton("saveAllResults", "Click here save"),
           ),   
           
      ),      
      #--------------------------------------------------------------------------- 
    ),
    
  )
  
}
