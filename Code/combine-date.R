#
# combine-date.R, 15 Feb 14

# Take csv created by combine-street.R and calculate a mean/sd
# for every quarter hour or every day of the week.

library(plyr)

mean_sd=function(df)
{
m=mean(pmax(0, df$free_space), na.rm=TRUE)
s=sd(df$free_space, na.rm=TRUE)

return(data.frame(expected=m, dev=s))
}


process_street=function(street_name)
{
print(street_name)

parking=read.csv(paste0(root_src, street_name), as.is=TRUE)
# ignore date
parking$date=NULL

# print(head(parking))
t=ddply(parking, .(dofw, quarter), mean_sd)

write.csv(t, paste0(root_dest, street_name, ".txt"), row.names=FALSE)

return(0)
}


# date,dofw,spaces,quarter

quarter_hr=seq(1, 24*4-1)
num_quarters=rep(1, 24*4-1)
root="c:/Web/AllIotData/"
root_src=paste0(root, "street.sum/")
root_dest=paste0(root, "street.txt/")

street_list=list.files(root_src)

t=aaply(street_list, 1, process_street)

