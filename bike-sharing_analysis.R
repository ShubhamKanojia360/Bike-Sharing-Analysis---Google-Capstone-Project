install.packages("tidyverse")
install.packages("here")
install.packages("skimr")
install.packages("janitor")
install.packages("lubridate")

library("tidyverse")
library("here")
library("skimr")
library("janitor")
library(lubridate)
library(dplyr)



Trips_Apr20 <- read_csv('202004-divvy-tripdata.csv')
Trips_May20 <- read_csv('202005-divvy-tripdata.csv')
Trips_June20 <- read_csv('202006-divvy-tripdata.csv')
Trips_July20 <- read_csv('202007-divvy-tripdata.csv')
Trips_Aug20 <- read_csv('202008-divvy-tripdata.csv')
Trips_Sep20 <- read_csv('202009-divvy-tripdata.csv')
Trips_Oct20 <- read_csv('202010-divvy-tripdata.csv')
Trips_Nov20 <- read_csv('202011-divvy-tripdata.csv')
Trips_Dec20 <- read_csv('202012-divvy-tripdata.csv')
Trips_Jan21 <- read_csv('202101-divvy-tripdata.csv')
Trips_Feb21 <- read_csv('202102-divvy-tripdata.csv')
Trips_Mar21 <- read_csv('202103-divvy-tripdata.csv')
Trips_Apr21 <- read_csv('202104-divvy-tripdata.csv')

#checking columns in these datasets

colnames(Trips_Apr20)
colnames(Trips_May20)
colnames(Trips_June20)
colnames(Trips_July20)
colnames(Trips_Aug20)
colnames(Trips_Sep20)
colnames(Trips_Oct20)
colnames(Trips_Nov20)
colnames(Trips_Dec20)
colnames(Trips_Jan21)
colnames(Trips_Feb21)
colnames(Trips_Mar21)
colnames(Trips_Apr21)


#inspecting the data
str(Trips_Apr20)
str(Trips_May20)
str(Trips_June20)
str(Trips_July20)
str(Trips_Aug20)
str(Trips_Sep20)
str(Trips_Oct20)
str(Trips_Nov20)
str(Trips_Dec20)
str(Trips_Jan21)
str(Trips_Feb21)
str(Trips_Mar21)
str(Trips_Apr21)


#we can compare column datatype across all dataframe by using compare_df_cols when we have large dataset

compare_df_cols(Trips_Apr20, Trips_May20, Trips_June20, Trips_July20,
                Trips_Aug20, Trips_Sep20, Trips_Oct20, Trips_Nov20, Trips_Dec20,
                Trips_Jan21, Trips_Feb21, Trips_Mar21, Trips_Apr21, return = "mismatch")

#Convert end_station_id and start_station_id to character so that they can stack correctly
Trips_Apr20 <- mutate(Trips_Apr20, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))
Trips_May20 <- mutate(Trips_May20, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))
Trips_June20 <- mutate(Trips_June20, end_station_id =
                         as.character(end_station_id), start_station_id =
                         as.character(start_station_id))
Trips_July20 <- mutate(Trips_July20, end_station_id =
                         as.character(end_station_id), start_station_id =
                         as.character(start_station_id))
Trips_Aug20 <- mutate(Trips_Aug20, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))
Trips_Sep20 <- mutate(Trips_Sep20, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))
Trips_Oct20 <- mutate(Trips_Oct20, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))
Trips_Nov20 <- mutate(Trips_Nov20, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))
Trips_Apr21 <- mutate(Trips_Apr21, end_station_id =
                        as.character(end_station_id), start_station_id =
                        as.character(start_station_id))

#check for mismatch again
compare_df_cols(Trips_Apr20, Trips_May20, Trips_June20, Trips_July20,
                Trips_Aug20, Trips_Sep20, Trips_Oct20, Trips_Nov20, Trips_Dec20,
                Trips_Jan21, Trips_Feb21, Trips_Mar21, Trips_Apr21, return = "mismatch")
#no mismatches
#add all dataframes into ONE
all_trips <- bind_rows(Trips_Apr20, Trips_May20, Trips_June20, Trips_July20,
                       Trips_Aug20, Trips_Sep20, Trips_Oct20, Trips_Nov20, Trips_Dec20,
                       Trips_Jan21, Trips_Feb21, Trips_Mar21, Trips_Apr21)

#delete unwanted columns
all_trips <- all_trips %>%
  select(-c(start_lat, start_lng, end_lat, end_lng))

#rename the columns
all_trips <- all_trips %>% rename( trip_id= ride_id,
                                   ride_type =rideable_type
                                  ,start_time = started_at,end_time =ended_at
                                  ,from_station_name = start_station_name
                                  ,from_station_id = start_station_id
                                  ,to_station_name = end_station_name
                                  ,to_station_id = end_station_id
                                  ,usertype = member_casual)

#DATA CLEANING 

colnames(all_trips)     #List of column names

dim(all_trips)          #Dimensions of the data frame

head(all_trips)         #See the first 6 rows of data frame in a tibble

str(all_trips)          #See list of columns and data types (numeric, character, etc)

summary(all_trips)      #Statistical summary of data

skim(all_trips)         #get summary of data, check missing data


#Add columns that list the date, month, day, and year of each ride

all_trips$date <- as.Date(all_trips$start_time) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")


#Add a "ride_length" calculation to all_trips (in seconds)

all_trips$ride_length <- difftime(all_trips$end_time,all_trips$start_time)


#Convert "ride_length" from Factor to numeric so we can run calculations on the data

is.factor(all_trips$ride_length)

all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)



#The dataframe includes a few hundred entries when bikes were taken out of docks 
#and checked for quality by Divvy or ride_length was negative
#REMOVE THESE ROWS

skim(all_trips$ride_length)

all_trips_v2 <- all_trips[!(all_trips$ride_length<0),]
skim(all_trips_v2)


#DATA ANALYSIS

summary(all_trips_v2$ride_length)

#further analysis done via Tableau
#exporting cleaned data set as a csv file

write.csv(all_trips_v2, "bike-data.csv")









