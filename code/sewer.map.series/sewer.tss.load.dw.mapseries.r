# Loading inputs for TSS-sewer maps ----

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
  "results/manholes.snt.tss.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ",
    "manhole.id","wwp.id","seed","run","exp"))

poo.snt <- read_csv(
  "results/dwpoo.snt.tss.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ",
    "CVEGEO","wwp.id","seed","run","exp"))

pee.snt <- read_csv(
  "results/dwpee.snt.tss.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ",
    "CVEGEO","wwp.id","seed","run","exp"))

kitchen.snt <- read_csv(
  "results/dwkitchensink.snt.tss.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ",
    "CVEGEO","wwp.id","seed","run","exp"))

shower.snt <- read_csv(
  "results/dwshower.snt.tss.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ",
    "CVEGEO","wwp.id","seed","run","exp"))

washbasin.snt <- read_csv(
  "results/dwwashbasin.snt.tss.csv",
  col_names = c(
    "ind.id","date.time","day.n","event.typ",
    "CVEGEO","wwp.id","seed","run","exp"))

# washingmachine.snt <- read_csv(
#   "results/dwwmachine.snt.tss.csv",
#   col_names = c(
#     "ind.id","date.time","day.n","event.typ",
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

poo.snt$date.time <- parse_date_time(
  poo.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

pee.snt$date.time <- parse_date_time(
  pee.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

kitchen.snt$date.time <- parse_date_time(
  kitchen.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

shower.snt$date.time <- parse_date_time(
  shower.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

# washingmachine.snt$date.time <- parse_date_time(
#   washingmachine.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

washbasin.snt$date.time <- parse_date_time(
  washbasin.snt$date.time, orders = c("%Y-%m-%d %H:%M"))

#Define validation hours
dt.val <- tibble(
  start = c(
  '2022:03:19 07:45',
  '2022:03:20 07:45',
  '2022:03:21 07:45',
  '2022:03:22 07:45',
  '2022:03:23 07:45',
  '2022:03:24 07:45',
  '2022:03:25 07:45',
  '2022:03:26 07:45',
  '2022:03:27 07:45',
  '2022:03:28 07:45',
  '2022:03:29 07:45',
  '2022:03:30 07:45',
  '2022:03:31 07:45',
  '2022:04:01 07:45'),
  end =c(
    '2022:03:19 12:12',
    '2022:03:20 12:12',
    '2022:03:21 12:12',
    '2022:03:22 12:12',
    '2022:03:23 12:12',
    '2022:03:24 12:12',
    '2022:03:25 12:12',
    '2022:03:26 12:12',
    '2022:03:27 12:12',
    '2022:03:28 12:12',
    '2022:03:29 12:12',
    '2022:03:30 12:12',
    '2022:03:31 12:12',
    '2022:04:01 12:12')
    )

#Set date time hours
dt.val$start <- parse_date_time(
  dt.val$start, orders = c("%Y-%m-%d %H:%M"))

dt.val$end <- parse_date_time(
  dt.val$end, orders = c("%Y-%m-%d %H:%M"))

dt.val

#Filter validation hours
#Selecting Monday for sensitivity analysis
filter.val.range <- function(
    var.df = manholes.snt,
    dt.val = dt.val,
    name.out = 'manholes.snt'
) {
  # d1<- var.df %>%
  #   .[.$date.time >= dt.val[1,1] & .$date.time <= dt.val[1,2], ]
  # 
  # d2<- var.df %>%
  # .[.$date.time >= dt.val[2,1] & .$date.time <= dt.val[2,2], ]

  d3<- var.df %>%
    .[.$date.time >= dt.val[3,1] & .$date.time <= dt.val[3,2], ]

  d4<- var.df %>%
    .[.$date.time >= dt.val[9,1] & .$date.time <= dt.val[9,2], ]

  d5<- var.df %>%
  .[.$date.time >= dt.val[14,1] & .$date.time <= dt.val[14,2], ]

  d1.5<- rbind(d3,d4,d5) #d1,d2,

  assign(name.out,d1.5,
         envir = globalenv())
}

filter.val.range(var.df = manholes.snt,
                 dt.val = dt.val,
                 name.out = 'manholes.snt')

filter.val.range(var.df = poo.snt,
                 dt.val = dt.val,
                 name.out = 'poo.snt')

filter.val.range(var.df = pee.snt,
                 dt.val = dt.val,
                 name.out = 'pee.snt')

filter.val.range(var.df = kitchen.snt,
                 dt.val = dt.val,
                 name.out = 'kitchen.snt')

filter.val.range(var.df = shower.snt,
                 dt.val = dt.val,
                 name.out = 'shower.snt')

# filter.val.range(var.df = washingmachine.snt,
#                  dt.val = dt.val,
#                  name.out = 'washingmachine.snt')

filter.val.range(var.df = washbasin.snt,
                 dt.val = dt.val,
                 name.out = 'washbasin.snt')


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
poo.snt <- inner_join(poo.snt, indiv_mipfp.id, by = "ind.id")

pee.snt <- inner_join(pee.snt, indiv_mipfp.id, by = "ind.id")
kitchen.snt <- inner_join(kitchen.snt, indiv_mipfp.id, by = "ind.id")
shower.snt <- inner_join(shower.snt, indiv_mipfp.id, by = "ind.id")
#washingmachine.snt <- inner_join(washingmachine.snt, indiv_mipfp.id, by = "ind.id")
washbasin.snt <- inner_join(washbasin.snt, indiv_mipfp.id, by = "ind.id")

blocks.snt<- rbind(pee.snt,poo.snt,kitchen.snt,
                   shower.snt,washbasin.snt)#,washingmachine.snt

# DF inputs to execute parametrization
# blocks.snt
# manholes.snt
# 
# colnames(blocks.snt)
# colnames(manholes.snt)
# blocks.snt$event.typ %>%unique()
# manholes.snt$event.typ %>%unique()

remove(
  pee.snt,
  poo.snt,
  kitchen.snt,
  shower.snt,
  #washingmachine.snt,
  washbasin.snt)

#Define tag version base on temporal execution of parametrization
ver.tim <- Sys.time() %>% gsub(":",".",.) %>% 
  gsub("-","",.)%>% gsub(" ",".",.)

#Execute parametrization
source(
"code/sewer.map.series/dw.pollutant.loads.by.events.global.snt.calibration.r")

#Check parametrization
# colnames(blocks.snt.pol)
# colnames(manholes.snt.pol)
# blocks.snt.pol$event.typ %>%unique()
# manholes.snt.pol$event.typ %>%unique()
# blocks.snt.pol$Age %>%unique()
# manholes.snt.pol$Age %>%unique()

#remove un-used var
remove(dt.val,blocks.snt,manholes.snt,indiv_mipfp.id)

# Results from DW parametrization
# blocks.snt.pol
# manholes.snt.pol
# 
# blocks.snt.pol$event.typ |> unique()
# manholes.snt.pol$event.typ |> unique()
# 
# summary(blocks.snt.pol)
# summary(manholes.snt.pol)
# 
# manholes.snt.pol %>% .$date.time %>% lubridate::hour(.) %>% unique()
# blocks.snt.pol %>% .$date.time %>% lubridate::hour(.) %>% unique()

#Saving results - Needed for framework
write_csv(manholes.snt.pol,'results/manholes.snt.pol.df.tss.csv')

#> Fun: var.SPT resolutions DW- COD.TSS.VOL   <------------------------------ =================================

dw.var.spt.resol.processing.plots <- function(
    tem.res.in.min.int = 12,
    mh.loc.pol = manholes.snt.pol,
    #wwtp.loc.pol = wwtp.snt.pol,
    #blo.loc.pol = blocks.snt.pol,
    date.1.str = "2022-03-19",
    date.2.str = "2022-03-20",
    date.3.str = "2022-03-21",
    date.4.str = "2022-03-22",
    date.5.str = "2022-03-23",
    #blo.out.res.loc.df = 'blo.out.12min.snt.df',
    mh.out.res.loc.df = 'name'
    #wwtp.out.res.loc.df = 'wwtp.out.12min.snt.df',
    #wwtp.mh.blo.out.res.loc.plot = 'wwtp.mh.blo.out.12min.snt.plot'
){
  
  # Manholes  ------------------------------
  
  mh.loc.pol.min <- mh.loc.pol
  mh.loc.pol.min$date.time <- align.time(as.POSIXct(mh.loc.pol.min$date.time), tem.res.in.min.int * 60)
  
  
  #Pollutants concentration applies mean values in a time window
  #This applies when the concentration from two events is combined:Target question
  dw.manholes.minute.cod <- aggregate(cod.mgl ~
                                        format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
                                        mh.loc.pol.min$manhole.id,
                                      data= mh.loc.pol.min,
                                      FUN = mean)%>% as_tibble()
  
  dw.manholes.minute.tss <- aggregate(tss.mgl ~
                                        format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
                                        mh.loc.pol.min$manhole.id,
                                      data= mh.loc.pol.min,
                                      FUN = mean)%>% as_tibble()
  
  #Liters apply the sum of the values in a time window
  #This applies when the total amount of DW production is the target
  dw.manholes.minute.lts <- aggregate(lts.vol ~ 
                                        format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
                                        mh.loc.pol.min$manhole.id,
                                      data= mh.loc.pol.min,
                                      FUN = 'sum')%>% as_tibble()
  
  # dw.manholes.minute.cod.min <- aggregate(cod.mgl ~
  #                                           format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
  #                                           mh.loc.pol.min$manhole.id,
  #                                         data= mh.loc.pol.min,
  #                                         FUN = roll_min)%>% as_tibble()
  # 
  # dw.manholes.minute.tss.min <- aggregate(tss.mgl ~
  #                                           format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
  #                                           mh.loc.pol.min$manhole.id,
  #                                         data= mh.loc.pol.min,
  #                                         FUN = roll_min)%>% as_tibble()
  # 
  # dw.manholes.minute.cod.max <- aggregate(cod.mgl ~
  #                                           format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
  #                                           mh.loc.pol.min$manhole.id,
  #                                         data= mh.loc.pol.min,
  #                                         FUN = roll_max)%>% as_tibble()
  # 
  # dw.manholes.minute.tss.max <- aggregate(tss.mgl ~
  #                                           format(as.POSIXct(mh.loc.pol.min$date.time), "%Y-%m-%d %H:%M")+ 
  #                                           mh.loc.pol.min$manhole.id,
  #                                         data= mh.loc.pol.min,
  #                                         FUN = roll_max)%>% as_tibble()
  
  #Merged COD TSS LTS by space-time
  mh.out.res.name.df <- inner_join(dw.manholes.minute.cod,dw.manholes.minute.tss)
  mh.out.res.name.df <- inner_join(mh.out.res.name.df,dw.manholes.minute.lts)
  
  # mh.out.res.name.df.mix <- cbind(dw.manholes.minute.cod.min,dw.manholes.minute.cod.max)
  # mh.out.res.name.df.mix <- cbind(mh.out.res.name.df.mix,dw.manholes.minute.tss.min)
  # mh.out.res.name.df.mix <- cbind(mh.out.res.name.df.mix,dw.manholes.minute.tss.max)

  
  colnames(mh.out.res.name.df) <-c("date.time","manhole.id","cod.mgl","tss.mgl","lts.vol")
   mh.out.res.name.df$date.time <- parse_date_time(mh.out.res.name.df$date.time, orders = c("%Y-%m-%d %H:%M"))
  
  
  # colnames(mh.out.res.name.df.mix) <-c(
  #   "date.time","manhole.id","cod.mgl.min","cod.mgl.max","tss.mgl.min","tss.mgl.max")
  # mh.out.res.name.df.mix$date.time <- parse_date_time(
  #   mh.out.res.name.df.mix$date.time, orders = c("%Y-%m-%d %H:%M")) 
  
  remove(
    mh.loc.pol.min,
    dw.manholes.minute.cod,
    dw.manholes.minute.tss,
    dw.manholes.minute.lts
  )
  
  
  
  #Saving results
  # 
  # assign(blo.out.res.loc.df, blo.out.res.name.df,
  #        envir = globalenv())
  
  assign(mh.out.res.loc.df,mh.out.res.name.df,
         envir = globalenv())
  

}


#> Avg. T.res:x5 DW- COD.TSS.VOL   <------------------------------ =================================

#> Minutes (12 min) DW- COD.TSS.VOL
dw.var.spt.resol.processing.plots(
  tem.res.in.min.int = 12,
  mh.loc.pol = manholes.snt.pol,
  date.1.str = "2022-03-19",
  date.2.str = "2022-03-20",
  date.3.str = "2022-03-21",
  date.4.str = "2022-03-22",
  date.5.str = "2022-03-23",
  mh.out.res.loc.df = 'mh.out.12min.snt.tss.df'
  #wwtp.loc.pol = wwtp.snt.pol,
  #blo.loc.pol = blocks.snt.pol,
  #blo.out.res.loc.df = 'blo.out.12min.snt.df',
  #wwtp.out.res.loc.df = 'wwtp.out.12min.snt.df',
  #wwtp.mh.blo.out.res.loc.plot = 'wwtp.mh.blo.out.12min.snt.plot'
)

# Exporting Avg.70.sim results ----

#Checking results
# mh.out.06min.snt.df %>% .$date.time %>% lubridate::hour(.) %>% unique()
mh.out.12min.snt.tss.df %>% .$date.time %>% lubridate::hour(.) %>% unique()
# mh.out.30min.snt.df %>% .$date.time %>% lubridate::hour(.) %>% unique()
# mh.out.60min.snt.df %>% .$date.time %>% lubridate::hour(.) %>% unique()
# mh.out.180min.snt.df %>% .$date.time %>% lubridate::hour(.) %>% unique()

#Adding max an min to final results

#mh.out.06min.snt.df <- mh.runs.06.all
#mh.out.12min.snt.df <- mh.runs.12.all
#mh.out.30min.snt.df <- mh.runs.30.all
#mh.out.60min.snt.df <- mh.runs.60.all
#mh.out.180min.snt.df <- mh.runs.180.all

#Files for processing model validation
#write_csv(mh.out.06min.snt.df,'results/calibration.snt/mh.out.06min.snt.df.csv')
write_csv(mh.out.12min.snt.tss.df,'results/mh.out.12min.snt.df.tss.csv')
#write_csv(mh.out.30min.snt.df,'results/calibration.snt/mh.out.30min.snt.df.csv')
#write_csv(mh.out.60min.snt.df,'results/calibration.snt/mh.out.60min.snt.df.csv')
#write_csv(mh.out.180min.snt.df,'results/calibration.snt/mh.out.180min.snt.df.csv')

#Removing unused variables for validation after exporting files
#Keep ver.tim variable
remove(
       blocks.snt.pol,
       manholes.snt.pol,
       filter.val.range,
       dw.var.spt.resol.processing.plots
       # mh.out.06min.snt.df,
       # mh.out.12min.snt.df,
       # mh.out.30min.snt.df,
       # mh.out.60min.snt.df,
       # mh.out.180min.snt.df,
       )

#clean memory
gc()

#Execute validation: correlation tables
#source("code/dw.abm.validation.snt.cal.val.1.R")


