## Use case
For dataset containing location (i.e. Lat and Lon), time, ... columns with the need of knowing actual timezone to potentially be converted to a specific timezone, such as UTC


## Function
This function accepts decimal Lat and Lon as inputs and returns [standard timezone ID](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) using [Google Maps API](https://developers.google.com/maps/).

```{r}
library(httr)
library(jsonlite)

LocationToTimezone <- function(Lat, Lon) {
  raw.result <- GET(url = paste("https://maps.googleapis.com/maps/api/timezone/json?location=", Lat, ",", Lon, "&timestamp=1458000000&key=", sep=""))
  result <- fromJSON(rawToChar(raw.result$content))
  
  if(result$status != "INVALID_REQUEST") { 
    return(result$timeZoneId) 
  } else {
    return(result$status)
  }
}
```

## Examples

```{r}
LocationToTimezone(47.561389, -52.7125)
[1] "America/St_Johns"
```

```{r}
LocationToTimezone(53.620893, -123.830113)
[1] "America/Vancouver"
```

For invalid inputs `NULL` will be returned.
```{r}
LocationToTimezone(01.01, -01.01)
NULL
```

This function can be applied to a dataframe (e.g. _data_ with Lat and Lon columns) using ```mapply``` as described in the following.

In this example, 'data' looks like this:
```{r}
head(data)
test   latitude  longitude  class
     4 42.54624   1.601554  A
     2 23.42408  53.847818  C
     8 33.93911  67.709953  B
     6 17.06082 -61.796428  A
     1 18.22055 -63.068615  B
     7 41.15333  20.168331  A
```
Here, ```LocationToTimezone``` is applied to _data_ using ```mapply```:
```{r}
results <- mapply(LocationToTimezone, data$latitude, data$longitude)
```

Finally, the resulting timezones are as follows:
```{r}
head(results)
[[1]]
[1] "Europe/Andorra"

[[2]]
[1] "Asia/Dubai"

[[3]]
[1] "Asia/Kabul"

[[4]]
[1] "America/Antigua"

[[5]]
[1] "America/Anguilla"

[[6]]
[1] "Europe/Tirane"
```

## Warning message
You might get the following warning message due to incompatibilities coming from operating system, which can be ignored.

```{r}
## Warning in strptime(x, fmt, tz = "GMT"): unknown timezone 'zone/tz/2017c.
## 1.0/zoneinfo/America/St_Johns'
```

## Limits
[Google Maps API](https://developers.google.com/maps/) has the following usage [limits](https://developers.google.com/maps/documentation/timezone/usage-limits):

* 2,500 free requests per day
* 50 requests per second
