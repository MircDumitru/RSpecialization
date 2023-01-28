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


## Plot 4 - Multiple plots
png(file = "plot4.png", width = 480, height = 480)
par(mfcol = c(2,2), mar = c(7,5,2,1))

plot(df$DateTime, as.numeric(df$Global_active_power), 
     type = 'n', 
     ylab = 'Global Active Power',
     xlab = '')
with(df,{
    lines(DateTime, as.numeric(Global_active_power))
})

with(df,{
    plot(DateTime, as.numeric(Sub_metering_1), 
         type = 'n', 
         ylab = 'Energy sub metering',
         xlab = '')
    lines(DateTime, as.numeric(Sub_metering_1), 
          col = 'black')
    lines(DateTime, as.numeric(Sub_metering_2), 
          col = 'red')
    lines(DateTime, as.numeric(Sub_metering_3), 
          col = 'blue')
})
legend("topright", 
       legend = c("Sub_metering_1", 'Sub_metering_2', 'Sub_metering_3'), 
       lwd = 1, cex=1, box.lwd = 0, 
       col = c('black', 'red', 'blue'))


plot(df$DateTime, as.numeric(df$Voltage), 
     type = 'n', 
     ylab = 'Voltage',
     xlab = 'datetime')
with(df,{
    lines(DateTime, as.numeric(df$Voltage))
})

plot(df$DateTime, as.numeric(df$Global_reactive_power), 
     type = 'n', 
     ylab = 'Global_reactive_power',
     xlab = 'datetime')
with(df,{
    lines(DateTime, as.numeric(df$Global_reactive_power))
})
dev.off()