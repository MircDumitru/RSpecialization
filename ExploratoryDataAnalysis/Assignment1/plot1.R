df <- read.table('.././data/household_power_consumption.txt', header = TRUE, sep = ';')
print(dim(df))
#print(head(df))
print(names(df))

# Get the concatenation of the Date and Time columns
datecol <- paste(df$Date, df$Time)
# Check the class
print(class(datecol))
# Check the dimension
print(dim(df))
# Check the first elements 
print(datecol[1:10])

# Transform it into date class
datecol <- strptime(datecol, "%d/%m/%Y %H:%M:%S", tz = "EST")
# Check the class
print(class(datecol))
# Check the dimension
print(dim(df))
# Check the first elements 
print(datecol[1:10])

# Drop the Date $ Time variables, add the new DataTime variable 
df <- df[,-(1:2)]
df$DateTime <- datecol
# Check the dimension
print(dim(df))
#print(head(df))

start_point <- strptime("2007-02-01 00:00:01", "%Y-%m-%d %H:%M:%S", tz = "EST")
end_point <- strptime("2007-02-02 23:59:59", "%Y-%m-%d %H:%M:%S", tz = "EST")


df<-df[which (start_point < df$DateTime & df$DateTime < end_point), ]
# Check the dimension
print(dim(df))
#print(head(df))



## Plot 1 - Histogram
# hist(as.numeric(df$Global_active_power), col = 'red', 
#      main = 'Global Active Power',
#      xlab = 'Global Active Power (kilowats)')

## Plot 1 - Histogram via with
png(file = "plot1.png", width = 480, height = 480)
with(df,{
    hist(as.numeric(Global_active_power), col = 'red', 
         main = 'Global Active Power',
         xlab = 'Global Active Power (kilowats)')
})
dev.off()