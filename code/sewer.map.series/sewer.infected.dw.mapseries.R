# Loading inputs for COVID-sewer maps, infected wastewater ----

# Read  DDW simulation for the entire outbreak between 03\21 to 04\08

options(scipen = 999)
#library(rJava)
#library(RNetLogo)
library(lubridate)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(highfrequency)
library(xts)
library(reshape2)
library(stringr)
library(purrr)
library(dygraphs)
library(tidyr)
library(readr)
library(tibble)
library(RcppRoll)


#Before running Netlogo calibration-validation file
#Make sure you have at least 20 GB of free RAM to rung the simulation

#Modify C:\Program Files\NetLogo 6.1.1\app\NetLogo.cfg
#[JVMOptions]
# there may be one or more lines, leave them unchanged
# Modify this line: -Xmx1024m to 20024m

# Required files to run dw.sms.abm.snt.2020.nlogo in Netlogo
# Remove old files and create new ones every time before running Netlogo

# file.remove("results/calibration.snt/manholes.snt.cal1.csv")
# file.remove("results/calibration.snt/dwpee.snt.cal1.csv")
# file.remove("results/calibration.snt/dwpoo.snt.cal1.csv")
# file.remove("results/calibration.snt/dwshower.snt.cal1.csv")
# file.remove("results/calibration.snt/dwkitchensink.snt.cal1.csv")
# file.remove("results/calibration.snt/dwwmachine.snt.cal1.csv")
# file.remove("results/calibration.snt/dwwashbasin.snt.cal1.csv")
# 
# file.create("results/calibration.snt/manholes.snt.cal1.csv")
# file.create("results/calibration.snt/dwpee.snt.cal1.csv")
# file.create("results/calibration.snt/dwpoo.snt.cal1.csv")
# file.create("results/calibration.snt/dwshower.snt.cal1.csv")
# file.create("results/calibration.snt/dwkitchensink.snt.cal1.csv")
# file.create("results/calibration.snt/dwwmachine.snt.cal1.csv")
# file.create("results/calibration.snt/dwwashbasin.snt.cal1.csv")


#Load SMS-ABM Netlogo outcomes ----
manholes.snt <- read_csv(
  "results/manholes.snt.cal1.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ","virus","vir.prev.inpoo",
    "manhole.id","wwp.id","seed","run","exp"))

# pee.snt <- read_csv(
#   "results/calibration.snt/dwpee.snt.cal1.csv",
#   col_names = c(
#     "ind.id","date.time","day.n","event.typ","virus",
#     "CVEGEO","wwp.id","seed","run","exp"))

poo.snt <- read_csv(
  "results/dwpoo.snt.cal1.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ","virus","vir.prev.inpoo",
    "CVEGEO","wwp.id","seed","run","exp"))

# kitchen.snt <- read_csv(
#   "results/calibration.snt/dwkitchensink.snt.cal1.csv",
#   col_names = c(
#     "ind.id","date.time","day.n","event.typ","virus",
#     "CVEGEO","wwp.id","seed","run","exp"))
# 
# shower.snt <- read_csv(
#   "results/calibration.snt/dwshower.snt.cal1.csv",
#   col_names = c(
#     "ind.id","date.time","day.n","event.typ","virus",
#     "CVEGEO","wwp.id","seed","run","exp"))
# 
# washingmachine.snt <- read_csv(
#   "results/calibration.snt/dwwmachine.snt.cal1.csv",
#   col_names = c(
#     "ind.id","date.time","day.n","event.typ","virus",
#     "CVEGEO","wwp.id","seed","run","exp"))
# 
# washbasin.snt <- read_csv(
#   "results/calibration.snt/dwwashbasin.snt.cal1.csv",
#   col_names = c(
#     "ind.id","date.time","day.n","event.typ","virus",
#     "CVEGEO","wwp.id","seed","run","exp"))

#Cehcking for duplicates
# manholes.snt[duplicated(manholes.snt),]
# pee.snt[duplicated(pee.snt),]
# poo.snt[duplicated(poo.snt),]
# kitchen.snt[duplicated(kitchen.snt),]
# shower.snt[duplicated(shower.snt),]
# washingmachine.snt[duplicated(washingmachine.snt),]
# washbasin.snt[duplicated(washbasin.snt),]

#Checking sensitivity analysis variables
# manholes.snt$run %>% unique()
# manholes.snt$exp %>% unique()
# manholes.snt$seed %>% unique()
# manholes.snt$manhole.id %>% unique()
# 
# pee.snt$run %>% unique()
# pee.snt$exp %>% unique()
# pee.snt$seed %>% unique()

#Datetime format for time-series data analysis
manholes.snt$date.time <- parse_date_time(
  manholes.snt$date.time, orders = c("%Y-%m-%d %H:%M:%S"))

# pee.snt$date.time <- parse_date_time(
#   pee.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

poo.snt$date.time <- parse_date_time(
  poo.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

# kitchen.snt$date.time <- parse_date_time(
#   kitchen.snt$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# shower.snt$date.time <- parse_date_time(
#   shower.snt$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# washingmachine.snt$date.time <- parse_date_time(
#   washingmachine.snt$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# washbasin.snt$date.time <- parse_date_time(
#   washbasin.snt$date.time, orders = c("%Y-%m-%d %H:%M"))


# manholes.snt %>% .$date.time %>% lubridate::hour(.) %>% unique()
# pee.snt %>% .$date.time %>% lubridate::hour(.) %>% unique()
# poo.snt %>% .$date.time %>% lubridate::hour(.) %>% unique()
# kitchen.snt %>% .$date.time %>% lubridate::hour(.) %>% unique()
# shower.snt %>% .$date.time %>% lubridate::hour(.) %>% unique()
# washingmachine.snt%>% .$date.time %>% lubridate::hour(.) %>% unique()
# washbasin.snt%>% .$date.time %>% lubridate::hour(.) %>% unique()

# Load SMS agents with ind.id ----
indiv_mipfp.id <- read_csv(
  "data/sms.agent.snt.csv",
  col_names = c("Sex","Age","Go_School","Go_Work",
                "Escolar_grade","Escolar_level","CVEGEO",
                "ind.id",'wwtp.conex'))

# Filter inhabitants connected to WWTP
indiv_mipfp.id<- indiv_mipfp.id %>% filter(wwtp.conex == 'y')
# head(indiv_mipfp.id)
# str(indiv_mipfp.id)

#Remove wwtp.conex column
indiv_mipfp.id <- indiv_mipfp.id %>% 
  .[,!(colnames(.) %in% c("wwtp.conex"))]

# Parametrization: (inner_join)DW.events & sms.agents ----

#Merge events & agents 
manholes.snt <- inner_join(manholes.snt, indiv_mipfp.id, by = "ind.id")
# pee.snt <- inner_join(pee.snt, indiv_mipfp.id, by = "ind.id")
poo.snt <- inner_join(poo.snt, indiv_mipfp.id, by = "ind.id")
# kitchen.snt <- inner_join(kitchen.snt, indiv_mipfp.id, by = "ind.id")
# shower.snt <- inner_join(shower.snt, indiv_mipfp.id, by = "ind.id")
# washingmachine.snt <- inner_join(washingmachine.snt, indiv_mipfp.id, by = "ind.id")
# washbasin.snt <- inner_join(washbasin.snt, indiv_mipfp.id, by = "ind.id")
blocks.snt<- rbind(
  poo.snt
  #,pee.snt,kitchen.snt,shower.snt,washingmachine.snt,washbasin.snt
  )

# DF inputs to execute parametrization
# blocks.snt
# manholes.snt

colnames(blocks.snt)
colnames(manholes.snt)
blocks.snt$event.typ %>%unique()
manholes.snt$event.typ %>%unique()

remove(poo.snt)
#   pee.snt,
#    kitchen.snt,
#    shower.snt,
#    washingmachine.snt,
#    washbasin.snt
   

#Define tag version base on temporal execution of parametrization
ver.tim <- Sys.time() %>% gsub(":",".",.) %>% 
  gsub("-","",.)%>% gsub(" ",".",.)

#Execute parametrization
#source("code/dw.pollutant.loads.by.events.global.infectedpoo.r")

#Jump parametrization and continue without pollution
manholes.snt.pol <-manholes.snt
blocks.snt.pol <- blocks.snt

#Check parametrization
# colnames(blocks.snt.pol)
# colnames(manholes.snt.pol)
# blocks.snt.pol$event.typ %>%unique()
# manholes.snt.pol$event.typ %>%unique()
# blocks.snt.pol$Age %>%unique()
# manholes.snt.pol$Age %>%unique()

#remove un-used var
remove(blocks.snt,manholes.snt,indiv_mipfp.id)

# Results from DW parametrization
# blocks.snt.pol
# manholes.snt.pol

# blocks.snt.pol$event.typ |> unique()
# manholes.snt.pol$event.typ |> unique()
# 
# summary(blocks.snt.pol)
# summary(manholes.snt.pol)

# manholes.snt.pol %>% .$date.time %>% lubridate::hour(.) %>% unique()
# blocks.snt.pol %>% .$date.time %>% lubridate::hour(.) %>% unique()

