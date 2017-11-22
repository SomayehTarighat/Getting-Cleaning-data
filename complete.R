complete <- function(directory, id = 1:332){
            directory <- setwd("C:/Users/Somayeh/Documents/Coursera/specdata")
            allfiles <- list.files(directory, full.names = TRUE)
            merged <- data.frame()
            for(i in id){
              data <- read.csv(allfiles[i], header = TRUE)
              #need to delete rows with incomplete cases
              data <- na.omit(data)
              nobs <- nrow(data)    #counts all rows with complete cases
              merged <- rbind(merged, data.frame(id, nobs))
            }
            return(merged)
}
