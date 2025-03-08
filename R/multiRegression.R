#-------------------------------------------------------------------------------
# Multivariate linear regression for sensitivity analysis (LHS for parameter generation)
#-------------------------------------------------------------------------------
linearRegression <- function(objFunction, parameterValue, objCriteria){
  
  parameterValue <- as.data.frame(parameterValue)
  
  header <- strsplit(colnames(objFunction), split = "_")
  temp <- c()
  for (i in 1:length(header)){
    temp <- c(temp, header[[i]][1])
  }
  
  temp <- which(temp %in% objCriteria)
  
  if (length(temp) > 1) {
    parameterValue$V1 <- rowSums(objFunction[,temp])
  } else {
    parameterValue$V1 <- objFunction[,temp]
  }
  
  temp <- summary(lm(V1 ~ ., parameterValue))
  
  tValue <- as.numeric(temp$coefficients[,3])
  tValue <- tValue[2:length(tValue)]
  
  pValue <- as.numeric(temp$coefficients[,4])
  pvalue <- pValue[2:length(pValue)]
  
  result <- matrix(c(tValue, pvalue), byrow = FALSE, ncol = 2)
  colnames(result) <-  c('t-stat', 'p-value')
  
  rowName <- c()    
  for (i in 1:nrow(result)){
    rowName <- c(rowName, paste('Parameter_', i, sep = ''))
  }
  
  rownames(result) <- rowName
  
  return(result)
  
}

#-------------------------------------------------------------------------------	
# Parameter generation by Latin Hypercube Sampling (LHS)
#-------------------------------------------------------------------------------	
lhsRange <- function(nIter, paramRange){
  
  nParam <- nrow(paramRange)
  paramSampling <- randomLHS(nIter, nParam)
  
  for (i in 1:nParam){
    paramSampling[,i] <- paramRange[i,1] +  paramSampling[,i] * 
      (paramRange[i,2] - paramRange[i,1])
  }
  
  paramSampling <- cbind(c(1:nrow(paramSampling)), paramSampling)
  return(paramSampling)
}

#-------------------------------------------------------------------------------	
# Generate random number for Sobol method
#-------------------------------------------------------------------------------	
runifSobol <- function(min, max, nrows, ncols){
  output <- data.frame(matrix(runif(ncols * nrows), nrow = nrows))
  
  for (i in 1:ncols){
    output[,i] <- min[i] + output[,i]*(max[i] - min[i])
  }
  
  return(output)
}


#-------------------------------------------------------------------------------	
# General function for working with parameter sensitivity
#-------------------------------------------------------------------------------	
sensitivityCommand <- function(minCol, maxCol, textCommand){
  
  
  myRCommand <-  morris(model = NULL, factors = 3, binf = c(1:3), bsup = c(2:4), r = 4, design = list(type = 'oat', levels = 5, grid.jump = 3))
  # Where the generated parameter values is store 
  # Must be in form of matrix with nrow = number of iteration, ncol = nparameter
  
  myRCommand$X
  
  # Command to evaluate parameter sensitivity
  tell(myRCommand, SWATobj)
  
  # Where the result is stored (must be a data frame)
  print(x)
  
}


#-------------------------------------------------------------------------------	
# Function to split input info to lines based on \n and remove comment
#-------------------------------------------------------------------------------
splitRemoveComment <- function(textCommand){

  if((nchar(textCommand) == 0) | (is.null(textCommand))){
     outText <- "No additional input for parameter sample was found"
  } else {
    textCommand <- gsub("minCol", "as.numeric(globalVariable$paraSelection$Min)", textCommand)  
    textCommand <- gsub("maxCol", "as.numeric(globalVariable$paraSelection$Max)", textCommand)
    textCommand <- gsub("nParam", "length(globalVariable$paraSelection$Max)", textCommand)
    textCommand <- gsub("objFuncValue", "globalVariable$objValue", textCommand)
    
    textCommand <- strsplit(textCommand, split = "\n", fixed = TRUE)[[1]]
    
    outText <- NULL
    count <- 1
    
    for (i in 1:length(textCommand)){
      temp <- trimws(textCommand[i])
      
      if ((substr(temp, 1, 1) != "#" &
           nchar(temp) != 0)) {
        outText[count] <- temp
        count <- count + 1
      }
    }
    
  }
  return(outText)
}

#-------------------------------------------------------------------------------	
# Function to split input info to lines based on \n and remove comment
#-------------------------------------------------------------------------------
evalTextCommand <- function(textCommand) {
  out <- tryCatch(
    {
      eval(parse(text = textCommand)) 
    },
    error=function(cond) {
      message("Error in eval")
      message(cond)
      return(NA)
    },
    warning=function(cond) {
      message("Warning")
      message(cond)
      return(NA)
    },
    finally={
    }
  )    
  return(out)
}






