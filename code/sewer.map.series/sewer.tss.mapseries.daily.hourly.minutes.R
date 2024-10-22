# Processing for TSS-sewer maps ----
# Pre-requirement: code/sewer.tss.load.dw.mapseries.r

# Load results ----

pipes_tbl = read_sf("data/pipes.snt.tbl.shp")
households_tbl = read_sf("data/households.snt.wgs84.shp")

mh.out.12min.snt.tss.df <- read_csv('results/mh.out.12min.snt.df.tss.csv')
#mh.out.60min.snt.df <- read_csv('results/calibration.snt/mh.out.60min.snt.df.csv')
#manholes.snt.pol <- read_csv('results/manholes.snt.pol.df.csv')

#manholes.snt.pol.daily.poo <- read_csv(
#  'results/calibration.snt/manholes.snt.vir.df.poo.03.21.to.04.08.csv')

# Matching ID manholes ---- 

# col names (results and shape file ids)
mholes_tbl = read_sf("data/manholes.snt.height.shp")
mholes_tbl = rename(mholes_tbl, manhole.id = manhole_id)

#Filtering blocks of interest
blocks_tbl = read_sf("data/13m.loc.snt.2020.mz800.wgs84.shp")
blocks_tbl_f = blocks_tbl|>
  filter(wwtp.conex == 'y' & TIPOMZA =='Típica')

# Join shapes and time-series resolutions

#mholes06m_tbl <- inner_join(mholes_tbl,mh.out.06min.snt.df, by = "manhole.id")
mholes12m_tbl.tss <- inner_join(mholes_tbl,mh.out.12min.snt.tss.df, by = "manhole.id")
#mholes60m_tbl <- inner_join(mholes_tbl,mh.out.60min.snt.df, by = "manhole.id")

# Faceted maps plotting DW spatial variability----


#Filtering dates of interest: 180 min
mholes12m_tbl_f.tss = mholes12m_tbl.tss |>
  filter (date.time < as.POSIXct("2022-03-21 12:00:00", tz='UTC') &
            date.time >= as.POSIXct("2022-03-21 09:00:00", tz='UTC')
  )

# mholes60m_tbl_f = mholes60m_tbl |>
#   filter (date.time < as.POSIXct("2022-03-21 16:00:00", tz='UTC') &
#             date.time >= as.POSIXct("2022-03-21 09:00:00", tz='UTC')
#   )

#Head tail breaks
# classIntervals(mholes12m_tbl_f$tss.mgl,
#                style = "headtails", thr = 0.5)

# Infected stool mapping ----

#Early COVID detection at 21 March ------------------------------
# 
# #Targeting mean infected stool events between 9 and 10#-------------------------------------------------------------
# stool.infected <- manholes.snt.pol|>
#   filter(virus == 'Infected'&
#            event.typ =="poo"&
#            date.time <= as.POSIXct("2022-03-21 10:30:00", tz='UTC') &
#            date.time >= as.POSIXct("2022-03-21 08:55:00", tz='UTC'))|>
#   mutate(inf.stool=1)
# 
# #Aggregate by manholes at 6 min. Mean events
# 
# stool.infected$date.time <- align.time(
#   as.POSIXct(stool.infected$date.time), 6 * 60) # temporal res in min=6
# 
# stool.infected.manholes <- aggregate(
#   inf.stool ~format(as.POSIXct(stool.infected$date.time), "%Y-%m-%d %H:%M")+
#     stool.infected$manhole.id,
#   data= stool.infected,
#   FUN = sum)%>% as_tibble()
# 
# colnames(stool.infected.manholes) <-c(
#   "date.time","manhole.id","stool.infected")
# 
# stool.infected.manholes$date.time <- parse_date_time(
#   stool.infected.manholes$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# stool.infected.manholes
# stool.infected.manholes$stool.infected|>unique()
# 
# # Join shapes and time-series resolutions
# mholes06m_tbl.stool <- inner_join(
#   mholes_tbl,stool.infected.manholes, by = "manhole.id")
# 
# 
# #Targeting mean infected stool events between 11:00 and 12:30#-------------------------------------------------------------
# stool.infected <- manholes.snt.pol|>
#   filter(virus == 'Infected'&
#            event.typ =="poo"&
#            date.time <= as.POSIXct("2022-03-21 12:37:00", tz='UTC') & #12:37:00
#            date.time >= as.POSIXct("2022-03-21 11:05:00", tz='UTC'))|>  #11:05:00
#   mutate(inf.stool=1)
# 
# #Aggregate by manholes at 6 min. Mean events
# 
# stool.infected$date.time <- align.time(
#   as.POSIXct(stool.infected$date.time), 6 * 60) # temporal res in min=6
# 
# stool.infected.manholes <- aggregate(
#   inf.stool ~format(as.POSIXct(stool.infected$date.time), "%Y-%m-%d %H:%M")+
#     stool.infected$manhole.id,
#   data= stool.infected,
#   FUN = sum)%>% as_tibble()
# 
# colnames(stool.infected.manholes) <-c(
#   "date.time","manhole.id","stool.infected")
# 
# stool.infected.manholes$date.time <- parse_date_time(
#   stool.infected.manholes$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# stool.infected.manholes
# stool.infected.manholes$stool.infected|>unique()
# 
# # Join shapes and time-series resolutions
# mholes06m_tbl.stool.1pm <- inner_join(
#   mholes_tbl,stool.infected.manholes, by = "manhole.id")
# 
# 
# #PEAK COVID detection at 27 MARCH ------------------------------
# 
# #Targeting mean infected stool events between 9 and 10#-------------------------------------------------------------
# stool.infected <- manholes.snt.pol|>
#   filter(virus == 'Infected'&
#            event.typ =="poo"&
#            date.time <= as.POSIXct("2022-03-27 10:27:00", tz='UTC') &
#            date.time >= as.POSIXct("2022-03-27 08:55:00", tz='UTC'))|>
#   mutate(inf.stool=1)
# 
# #Aggregate by manholes at 6 min. Mean events
# 
# stool.infected$date.time <- align.time(
#   as.POSIXct(stool.infected$date.time), 6 * 60) # temporal res in min=6
# 
# stool.infected.manholes <- aggregate(
#   inf.stool ~format(as.POSIXct(stool.infected$date.time), "%Y-%m-%d %H:%M")+
#     stool.infected$manhole.id,
#   data= stool.infected,
#   FUN = sum)%>% as_tibble()
# 
# colnames(stool.infected.manholes) <-c(
#   "date.time","manhole.id","stool.infected")
# 
# stool.infected.manholes$date.time <- parse_date_time(
#   stool.infected.manholes$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# stool.infected.manholes
# stool.infected.manholes$stool.infected|>unique()
# 
# # Join shapes and time-series resolutions
# mholes06m_tbl.stool.peak <- inner_join(
#   mholes_tbl,stool.infected.manholes, by = "manhole.id")
# 
# # DW composition of Infected stool : 10 min sampling ----
# #Targeting DW composition infected stool at selected manholes
# dw.composition.mh460 <- manholes.snt.pol|>
#   filter( manhole.id == 460&
#             date.time <= as.POSIXct("2022-03-21 09:55:00", tz='UTC') &
#             date.time >= as.POSIXct("2022-03-21 09:45:00", tz='UTC'))
# 
# 
# #PEAK COVID detection at April 1 ------------------------------
# 
# #Targeting mean infected stool events between 9 and 10#-------------------------------------------------------------
# stool.infected <- manholes.snt.pol|>
#   filter(  event.typ =="poo"&
#              date.time <= as.POSIXct("2022-04-01 10:30:00", tz='UTC') &
#              date.time >= as.POSIXct("2022-04-01 08:55:00", tz='UTC'))|>
#   filter(virus == "Infected"|virus=="Recovered")|>
#   mutate(inf.stool=1)
# 
# #Aggregate by manholes at 6 min. Mean events
# 
# stool.infected$date.time <- align.time(
#   as.POSIXct(stool.infected$date.time), 6 * 60) # temporal res in min=6
# 
# stool.infected.manholes <- aggregate(
#   inf.stool ~format(as.POSIXct(stool.infected$date.time), "%Y-%m-%d %H:%M")+
#     stool.infected$manhole.id,
#   data= stool.infected,
#   FUN = sum)%>% as_tibble()
# 
# colnames(stool.infected.manholes) <-c(
#   "date.time","manhole.id","stool.infected")
# 
# stool.infected.manholes$date.time <- parse_date_time(
#   stool.infected.manholes$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# stool.infected.manholes
# stool.infected.manholes$stool.infected|>unique()
# 
# # Join shapes and time-series resolutions
# mholes06m_tbl.stool.recovering <- inner_join(
#   mholes_tbl,stool.infected.manholes, by = "manhole.id")
# 
# 
# #NEW
# 
# #Aggregate by manholes at 60 min. Mean events
# stool.infected <- manholes.snt.pol|>
#   filter(  event.typ =="poo"&#run ==2&
#              date.time <= as.POSIXct("2022-04-01 15:00:00", tz='UTC') &
#              date.time >= as.POSIXct("2022-04-01 07:00:00", tz='UTC'))|>
#   filter(virus == "Infected"|virus=="Recovered")|>
#   mutate(inf.stool=1)
# 
# stool.infected$date.time <- align.time(
#   as.POSIXct(stool.infected$date.time), 60 * 60) # temporal res in min=6
# 
# stool.infected.manholes <- aggregate(
#   inf.stool ~format(as.POSIXct(stool.infected$date.time), "%Y-%m-%d %H:%M")+
#     stool.infected$manhole.id,
#   data= stool.infected,
#   FUN = sum)%>% as_tibble()
# 
# colnames(stool.infected.manholes) <-c(
#   "date.time","manhole.id","stool.infected")
# 
# stool.infected.manholes$date.time <- parse_date_time(
#   stool.infected.manholes$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# stool.infected.manholes
# stool.infected.manholes$stool.infected|>unique()
# 
# # Join shapes and time-series resolutions
# mholes60m_tbl.stool.recovering <- inner_join(
#   mholes_tbl,stool.infected.manholes, by = "manhole.id")
# 
# 
# #Full outbreak of daily infected wastewater  ------------------------------
# 
# manholes.snt.pol.daily.poo
# 
# #Aggregate by manholes at 24 horus (1440 min.) Mean events
# stool.infected <- manholes.snt.pol.daily.poo|>
#   filter(  event.typ =="poo"#run ==2&
#            )|>
#   filter(vir.prev.inpoo == "disease.in.poo")|>
#   mutate(inf.stool=1)
# 
# stool.infected$date.time <- align.time(
#   as.POSIXct(stool.infected$date.time), 1440 * 60) # temporal res in min=6
# 
# stool.infected.manholes <- aggregate(
#   inf.stool ~format(as.POSIXct(stool.infected$date.time), "%Y-%m-%d %H:%M")+
#     stool.infected$manhole.id,
#   data= stool.infected,
#   FUN = sum)%>% as_tibble()
# 
# colnames(stool.infected.manholes) <-c(
#   "date.time","manhole.id","stool.infected")
# 
# stool.infected.manholes$date.time <- parse_date_time(
#   stool.infected.manholes$date.time, orders = c("%Y-%m-%d %H:%M"))
# 
# stool.infected.manholes
# stool.infected.manholes$stool.infected|>unique()
# 
# # Join shapes and time-series resolutions
# mholes24h_tbl.stool.recovering <- inner_join(
#   mholes_tbl,stool.infected.manholes, by = "manhole.id")
