#
# combine-street.R, 15 Feb 14

# Merge the parking data for each street

library(plyr)


combine_day=function(df)
{
# How many parking slots are available in each quarter?
m_sp=num_spaces*num_quarters

# Add up number in use in each quarter
ta=NULL
for (i in 1:nrow(df))
   ta=c(ta, seq(df$start[i], df$end[i]))
t=table(ta)

tname=as.numeric(names(t))
m_sp[tname]=m_sp[tname]-t

#print(ta)
#print(t)
#print(m_sp)

return(data.frame(free_space=m_sp, quarter=quarter_hr))
}

# Convert time of day to time measured in 15 mins from 00:00
mk_time=function(hr_min)
{
start=as.numeric(as.POSIXct("00:00", format="%H:%M"))
t=(as.numeric(as.POSIXct(hr_min, format="%H:%M"))-start) %/% (60*15)
return(t)
}


process_street=function(street_name)
{
parking=read.csv(paste0(root_src, street_name), header=FALSE, as.is=TRUE)
t=subset(parking_loc, LocationKey == street_name)
num_spaces <<- t$Spaces

print(c(street_name, num_spaces))

names(parking)=c("amount", "date", "dofw", "start", "end")
parking$date=as.Date(parking$date, format="%Y-%m-%d")
parking$start=mk_time(parking$start)
parking$end=mk_time(parking$end)

merge_park=ddply(parking, .(date,dofw), combine_day)

write.csv(merge_park, paste0(root_dest, street_name, ".csv"), row.names=FALSE)

return(0)
}


# From 08:00 to 20:00, no make it 24 hr (some data appears at odd times)
quarter_hr=seq(1, 24*4-1)
num_quarters=rep(1, 24*4-1)
root="c:/Web/AllIotData/"
root_src=paste0(root, "street/")
root_dest=paste0(root, "street.sum/")

#parking_loc=read.csv(paste0(root_src, "ParkingBatLocations.csv"), as.is=TRUE)
parking_loc=read.csv(paste0(root, "WCC-ParkingCashlessBayLocations.csv"), as.is=TRUE)


# Data format
# date,dofw,start,end,spaces,street

#all_parking=read.csv("c:/Web/pred-park.csv", as.is=TRUE)
#all_parking=read.csv("c:/Web/all_parking.csv", as.is=TRUE)

street_list=list.files(root_src)

t=aaply(street_list, 1, process_street)


