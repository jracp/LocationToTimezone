# Created by Javad Rahimipour Anaraki on 26/01/18
# Ph.D. Candidate
# Department of Computer Science
# Memorial University of Newfoundland
<<<<<<< HEAD
# jra066 [AT] mun [DOT] ca | www.cs.mun.ca/~jra066
=======
jra066 [AT] mun [DOT] ca | www.cs.mun.ca/~jra066
>>>>>>> facb22bd45aa42eb69df8a5aa02204421b68353f

#   input: Latitude, Longtitude
#  output: Standard timezone ID
#========================Libraries=========================
library(httr)
library(jsonlite)
#====================Date/Time Converter==================
LocationToTimezone <- function(Lat, Lon) {
  raw.result <- GET(url = paste("https://maps.googleapis.com/maps/api/timezone/json?location=", Lat, ",", Lon, "&timestamp=1458000000&key=", sep=""))
  result <- fromJSON(rawToChar(raw.result$content))
  
  if(result$status != "INVALID_REQUEST") { 
    return(result$timeZoneId) 
  } else {
    return(result$status)
  }
}