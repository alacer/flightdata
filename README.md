##NASA Flight Data

### Manifest
* CSV files representing one flight for one aircraft
* Zip files that include the raw data, intermediate results and output CSV files
* Zip file containing scripts used to process the data.
 * concat - Bash script to join all CSV files in a single directory
 * createdirs- Python create to create output directories for each flight
 * matlab2df.R - R script to convert matlab file to an RData and CSV file
 * package - Python script to concatenate a flight's worth or CSV files and then compress the output
 * process_flight.R - R script that drives the conversion of individual files via matlab2df.R
 * ttp.py - One of Alan's Python scripts
 * ttt.py - Another of Alan's Python scripts	
 * processing_choices.docx - A Word document. Discussion of how to process large amount of data
  
###Source Data
* The NASA DASH link site hosts information about many different planes.
 * Each plane is identified by a three digit number.
 * The ID is a partially anonymized tail number.
 * The IDs range from 652-687. That is 36 different aircraft.
 * Here is a link to the data: https://c3.nasa.gov/dashlink/members/4/resources/?type=ds
* Flights
 * For each aircraft, there is a zip file that represents a single flight.
 * Each aircraft is represented by about 8 flights.
 * Each zip file is about 800 MB in size.
 * Each zip file contains about 650 individual matlab files.
* Matlab data files
 * Each matlab file consists of different sensor readings or variables that have been sampled at different rates.
 * The names of the matlab files use a naming convention. 
* File names
 * The file names are fixed length can be parsed by the number of characters. For example, if a file is named “652200101092009.mat”, then:

    * 652 = tail ID
    * 2001 = year
    * 01 = month
    * 09 = day
    * 20 = hour
    * 09 = min
 * The dates and times are anonymized and are not relevant except for ordering the data.
* Source
  * Bryan Matthews, the data set’s curator, has posted an FAQ about the data
  * https://c3.nasa.gov/dashlink/resources/901/
 
### Processing Steps
* All zip files were decompressed into their own directory: raw1, raw2, … raw9
* Each matlab file was imported into R as a data frame.
* The maximum sampling rate in the file was determined. Sampling rates ranged from ¼ to 16 samples per second. This was determined for the first zip files, but range of other zip files is unknown.
* The data was expanded to match the maximum sampling rate. That is, is a quantity was sampled at a rate of 1 sample/second, it was copied 16 times so that it would look like it was sampled 16 times per second. 
* Originally, the code normalized all samples to a rate of 1. If a quantity was sampled 16 times a second, then 16 values were averaged to make a single sample. However, it was pointed out that this was “lossy”; information can lost when a bunch of values are averaged. The code was changed.
* Several date/time fields were collapsed in to one variable. The TIME.SERIES variables is the concatenation of DATE.YEAR, DATE.MONTH, DATE.DAY, GMT.HOUR, GMT.MINUTE, GMT.SECOND. The result is a string that looks like this: “20141014173156”  (10/1/2014, 17:30:56). 
* Some date/time values were invalid. For example, a month of 45 or the year 2165. For that reason, the original date values were not converted into date objects. Their original values were preserved instead. 
* A few categorical variables were converted from numerical values to factors. If the FAQ that accompanied the data explained the factors in a categorical variable, the variable was converted to a factor with the proper levels. 

###Output Data
* For each input directory (e.g. raw1), there are two output directories: one for csv files and one for RData binary files (e.g. csv1 and result1)
* There is a 1:1 correspondence between input matlab files and output files.
* The original filename was used as the file name for the output. However, the leading “687” was stripped. Thus “687201003041921.mat” becomes “201003041921.RData”.
* The uncompressed amount of data to represent entire aircraft’s data as CSV files is about 600 GB. It should compress down to about 21 GB. 
* Represented as binary RData files, a single flight can be represented in only 1 GB. 

###Warnings
* The TIME.SERIES variable cannot be used to order the records. All measurements for a given flight have the same timestamp. However, the row order of the data is significant; subsequent observations occur later in time.
* If two different zip files have two different maximum sampling rates, then the respective output files do not represent the same time series. That is, the amount of time represented by a single record in a file with a max sampling rate of 16 would be one-half the amount of time represented by a single record from a file where the max sampling rate was 32. 
* Base R does everything by copy-- cbind does not append one data frame to another; it creates a new data frame and copies the other data frames into it. This is a memory intensive operation. God help you if you ask R to cbind 650 RData files together.
* If I had to do it over again, I would do a few things differently. 
  * I would have picked an aircraft with a known anomaly.
  * I would have discard the fields DATE.YEAR, DATE.MONTH, DATE.DAY, GMT.HOUR, GMT.MINUTE, GMT.SECOND and used the date/time information in the filename for the TIME.SERIES variable. 
  * I would have used the name of the zip file (1, 2, … 9) to add a FLIGHT.NUMBER variable to the output data.
  * I would have added a variable named SAMPLE.RATE to record the original data’s sample rate.
