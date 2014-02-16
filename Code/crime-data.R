#
# crime-date.R, 16 Feb 14
#
# Author: Bob Kemp

library(parallel)

source("parking-lib.R")

parking.bays.filename <- "WCC-ParkingCashlessBayLocations.csv"
crime.data.filename <- "policecrimedata.csv"

mc.cores <- 4

crime.data <- read.csv(crime.data.filename, header=T)

crime.data$crime_category <- as.character(crime.data$crime_category)
crime.data$crime_category[
    crime.data$crime_category %in% c("theft-from-the-person", "robbery")] <- "theft"

if (!exists("parking.bays")) {
  all.parking.data <- read.csv(parking.bays.filename, header=T)
  parking.bays <- all.parking.data[, c("LocationKey", "Lat", "Long")]
  rm(all.parking.data)

  parking.bays <- parking.bays[complete.cases(parking.bays), ]
  parking.bays$Lat <- as.numeric(parking.bays$Lat)
  parking.bays$Long <- as.numeric(parking.bays$Long)
}

nbays <- nrow(parking.bays)
ncrime <- nrow(crime.data)

crime.calc <- function(idx, crime.type) {
  return (as.numeric(crime.weight(crime.data, parking.bays$Lat[idx], parking.bays$Long[idx], crime.type)));
}

calc.crime.weight <- function(...) {
  return (mclapply(1:nbays, crime.calc, mc.cores=mc.cores, ...))
}

write.crime.weights <- function() {
  write.csv(parking.bays, "parking-bays-crime-weights.csv", row.names=F)
}

normalise.crime.statistic <- function(ws) {
  ws <- log(as.numeric(ws));
  rg <- range(ws)

  return (100 * (ws - rg[[1]]) / (rg[[2]] - rg[[1]]));
}

parking.bays$crime.weight.theft <- calc.crime.weight(crime.type = "theft")
parking.bays$crime.weight.vehicle <- calc.crime.weight(crime.type = "vehicle-crime")
parking.bays$crime.weight.violent <- calc.crime.weight(crime.type = "violent-crime")

parking.bays$crime.weight.theft <- normalise.crime.statistic(parking.bays$crime.weight.theft)
parking.bays$crime.weight.vehicle <- normalise.crime.statistic(parking.bays$crime.weight.vehicle)
parking.bays$crime.weight.violent <- normalise.crime.statistic(parking.bays$crime.weight.violent) 
