source('matlab2df.R')
# Get the argument that indicates which matlab files should be converted
# Usage: Rscript process_flight 3
# where "3" is the flight number
args <- commandArgs(trailingOnly = TRUE)
id<-args[1]

rawdir <- paste('/home/ubuntu/raw', id, sep='')
resultdir <- paste('/home/ubuntu/result', id, sep='')
csvdir <- paste('/home/ubuntu/csv', id, sep='')
filenames <- list.files(rawdir, pattern="*.mat", full.names=TRUE)

#Do the work
lapply(filenames, function(filename) {
  basename <- gsub(".*/[0-9]{3}([0-9_]+).*", "\\1", filename)
  outputcsvname <- paste(csvdir, '/',basename, '.csv', sep='')
  if (file.exists(outputcsvname)) { 
    print(paste('Output file exists. Skipping ', filename, sep=''))
  }
  else {
    filesizeMB <- signif(file.info(filename)$size/1024^2, digits=2)
    position <- Position(function(x) {x == filename}, filenames)
    print(paste('Reading file', position, 'of', length(filenames), filesizeMB, 'MB'))
    startTime = Sys.time()
    df <- matlab2df(filename)
    stopTime = Sys.time()
    seconds <- signif(as.numeric(stopTime-startTime, units="secs"), digits=4)
    dfMB <- signif(object.size(df)/1024^2/8, digits=2)
    print(paste('  ...time=', seconds, 'seconds.', 'data frame has', nrow(df), 'rows and uses', dfMB, 'MB'))
    save(df, file=paste(resultdir, '/',basename, ".RData", sep=''))
    write.csv(df, paste(outputcsvname, sep=''), row.names = FALSE)         
  }
})
