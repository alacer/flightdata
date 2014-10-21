matlab2df <- function(filename) {
  #Unbugger MATLAB data
  # install.packages('R.matlab')
  library(R.matlab)
  library(stringr)
  
  data <- readMat(filename)
  
  df <- NULL
  newnames = list()
  
  xtract <- function(thelist, theindex) {
    #Return a vector of data
    as.vector(thelist[[theindex]])
  }
  
  onedo <- function(name, data, fun) {
    #Apply a function to one set of variable information. 
    #This includes its observational measurements and its meta-data
    
    #The data/meta-data is always in the same location
    dataIdx =1
    rateIdx =2
    unitsIdx =3
    descIdx =4
    alphaIdx =5
    
    #Get a variable and its metadata as an array
    iarray <- data[[name]]
    
    #Pull out the observation rate from a 1 element matrix
    rate = xtract(iarray, rateIdx)
    
    #Convert the observations to a vector of numbers
    observations = xtract(iarray, dataIdx)
    
    #Get the number of observations 
    num = length(observations)
    
    #Get long description of variable
    description = xtract(iarray, descIdx)
    
    #DEGBUG PRINT STATEMENT
    #print(paste(name,'description=', description, 'rate=' ,rate ))
    
    #Run the user-defined function
    fun(name=name, description=description, observations=observations, num=num, rate=rate)
  }
  
  #Find biggest sample rate
  allrates<-sapply(names(data), FUN=onedo, data=data, fun=function(name, description, observations, num, rate) {rate})
  maxrate <- max(allrates)
  
  #Iterate over every variable in the data set to extract its data.
  datalist <- lapply(names(data), FUN=onedo, data=data, fun=function(name, description, observations, num, rate) {
    
    #Create a new numeric vector to hold the measurements
    newobs = numeric()
    
    #Extract the observations, accounting for sample rate.
    for (idx in 1:num) {
      
      #Rely on maxrate, in the global environment.
      period = maxrate/rate
      
      #If the rate is less than one,  expand the number of observations
      #to a rate of 1 by copying the same element multiple times.
      start <- (idx-1)*period+1
      stop <- start+period-1
      newobs[start:stop] <- observations[idx]
      
    } 
    
    #Create better variables name by combining name and description
    longname <- paste(name, '-', gsub(' ', '_', description), sep='')
    
    #Return the values as a named list
    return(list(name = name, longname= longname, obs=newobs))
    
  })
  
  # Create a dataframe from the data.
  # Declare global variable to hold the data frame
  #(I could build the data frame in the previous call to lapply(). However, I want to keep the 
  #  short names for the column headers. Later I will rename the column headers to use long names.)
  df <- NULL
  # Construct data frame
  lapply(datalist, FUN=function(vardata) {
    name = vardata[['name']]
    obs = vardata[['obs']]
    if(is.null(df)) {    
      df <<- data.frame(obs)    
      #New column is always inserted in the first position. Rename it.
      names(df)[1] <<- name
    }
    else {
      df[, name] <<- obs
    }
  })
  
  #Sort the columns alphabetically
  df <- df[, sort(colnames(df))]
  
  #Recode factors
  # APFD: Auto Pilot Flight Director Status
  # The 3 modes of the Auto Pilot Flight Director are: 
  # 1 Automatic Mode - the pilot selects the mode (see LMOD, VMODE)
  # and the control signals are calculated by the AP and executed by the flight controllers. 
  # 2 Manual mode - the pilot uses the stick and pedals to command the airplane. 
  # 0 This could be a managed mode or the AP is turned off. Usually on the ground. 
  df$APFD <- factor(df$APFD, levels=0:2, labels=c('off', 'auto', 'manual'))
  
  # ATEN is AUTO THRUST ENGAGE STATUS.
  # 1 indicates that the auto throttle is engaged. 
  # That is the engine N1 target speed is automatically set based on
  # navigation commands (flight plan). 
  df$ATEN <- factor(df$ATEN, levels=0:1, labels=c('not_engaged', 'engaged'))
  
  # VMODE: Translational control for the plane controls the flight path of the 
  # airplane with respect to air data, heading and navigation signal. 
  # It provides outputs to an inner-loop controller that controls the pitch, 
  # roll and yaw of the airplane. There are two primary modes for translational
  # control: VMODE is the vertical mode and LMOD is the Lateral mode. Within
  # each mode, there are several selections a pilot can make. 
  # The enumerated integers of LMOD and VMODE reflect these selections. 
  # We are asking experts to get the exact enumeration codes. Here are some
  # examples to start the thinking: 
  #   In LMOD: the selection could be heading, instrument landing, capture, or follow pilot command
  #   In VMOD: the selection could be: speed, altitude, vertical speed, flight path, glide slope, or follow pilot commands. 
  #Aaron: ???If they don't know what the enumerations mean then I sure as heck don't???
  
  # The PH enumerated codes are: 
  # 0=Unknown
  # 1=Preflight
  # 2=Taxi
  # 3=Takeoff
  # 4=Climb
  # 5=Cruise
  # 6=Approach
  # 7=Rollout
  df$PH <- factor(df$PH, levels=0:7, labels=c('unknown','preflight','taxi','takeoff','climb','cruise','approach','rollout'))
  
  # If N1CO is set to 0, no such overrides are applied and the engine will try 
  # to follow N1-Command. Typically N1CO will be "1" during the initial climb 
  # and final approach phase of the flight. 
  df$N1CO <- factor(df$N1CO, levels=0:1, labels=c('no_override', 'override'))
  
  #Drop some columns:
  # -Database version
  # -Drop engine serial numbers
  # -Drop date/time fields. The year fields is 2165, the day field is 45.... 
  #  None of them make any sense. Keep the information by creating a composite of the date/timee data
  # (Save time series data that would preserve ordinality -- i.e. biggest value (i.e. year) first)
  pad <- function(input) {str_pad(input, width=2, pad="0")}
  df$TIME.SERIES <- paste(df$DATE.YEAR, pad(df$DATE.MONTH), pad(df$DATE.DAT), pad(df$GMT.HOUR), pad(df$GMT.MINUTE), pad(df$GMT.SEC), sep='')
  drop <- c("GMT.HOUR", "GMT.MINUTE", "GMT.SEC", "DATE.YEAR", "DATE.MONTH", "DATE.DAY")
  
  #DECIDED NOT TO DROP THESE FIELDS. LET DOWNSTREAM CONSUMERS DECIDE IF THESE 
  #FIELDS ARE NEEDED
  #, "DVER.1", "DVER.2", "ESN.1", "ESN.2", "ESN.3")
  
  df_reduced <- df[, !(names(df) %in% drop)]
  
  #Assign header that include both the name and the description
  #First, declar a little helper function that know how to extract the long name from the data list
  #If the short name is not found (which happens if I add a column), then return the short name.
  getlongname <- function(name, datalist) {
    val <- Find(function(x){x[["name"]] == name}, datalist)[["longname"]]
    if (is.null(val)) name else val
  }
  
  #Set a helper var for the names
  headers <- names(df_reduced)
  
  #Assign long names to data frame.
  for (idx in 1:length(headers))  {
    names(df_reduced)[idx] <- getlongname(headers[idx], datalist)
  }

  #return the data frame
  df_reduced  
}
