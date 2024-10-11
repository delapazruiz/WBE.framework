# WWTP COVID tail time series for a day --------------------

covid.mh460.tail <- manholes.snt.pol|> 
  filter(manhole.id == 460&
           event.typ=="poo"&
           date.time <= as.POSIXct("2022-04-01 17:00:00", tz='UTC') &
           date.time >= as.POSIXct("2022-04-01 07:00:00", tz='UTC'))

covid.mh460.tail <- covid.mh460.tail|>
  filter(virus == "Infected"|virus=="Recovered")|>
  mutate(inf.stool=1)

covid.mh460.tail$date.time <- align.time(
  as.POSIXct(covid.mh460.tail$date.time), 12 * 60) # temporal res in min=6

covid.mh460.tail <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh460.tail$date.time), "%Y-%m-%d %H:%M")+
    covid.mh460.tail$manhole.id,
  data= covid.mh460.tail,
  FUN = sum)%>% as_tibble()

colnames(covid.mh460.tail) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh460.tail<- covid.mh460.tail[,-2]

covid.mh460.tail$date.time <- parse_date_time(
  covid.mh460.tail$date.time, orders = c("%Y-%m-%d %H:%M"))

covid.mh460.tail.noprevalence <- manholes.snt.pol|>
  filter( manhole.id == 460&
            virus=="Infected"&
            event.typ=="poo"&
            date.time <= as.POSIXct("2022-04-01 17:00:00", tz='UTC') &
            date.time >= as.POSIXct("2022-04-01 07:00:00", tz='UTC'))|>
  mutate(inf.stool=1)

covid.mh460.tail.noprevalence$date.time <- align.time(
  as.POSIXct(covid.mh460.tail.noprevalence$date.time), 12 * 60) # temporal res in min=6

covid.mh460.tail.noprevalence <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh460.tail.noprevalence$date.time), "%Y-%m-%d %H:%M")+
    covid.mh460.tail.noprevalence$manhole.id,
  data= covid.mh460.tail.noprevalence,
  FUN = sum)%>% as_tibble()

colnames(covid.mh460.tail.noprevalence) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh460.tail.noprevalence<- covid.mh460.tail.noprevalence[,-2]

covid.mh460.tail.noprevalence$date.time <- parse_date_time(
  covid.mh460.tail.noprevalence$date.time, orders = c("%Y-%m-%d %H:%M"))

# covid.mh460.tail
# covid.mh460.tail.noprevalence

covid.mh460.tail.yes.no.prevalence<- covid.mh460.tail.noprevalence |> left_join(covid.mh460.tail,by = "date.time")

colnames(covid.mh460.tail.yes.no.prevalence) <-c(
  "date.time","Infected","Infected+recovered")

# dyMultiColumn <- function(dygraph) {
#   dyPlotter(dygraph = dygraph,
#             name = "MultiColumn",
#             path = system.file("plotters/multicolumn.js",
#                                package = "dygraphs"))
# }


# M.h.258 COVID Peak time series for a day --------------------

covid.mh258.tail <- manholes.snt.pol|> 
  filter(manhole.id == 258&
           event.typ=="poo"&
           date.time <= as.POSIXct("2022-04-01 17:00:00", tz='UTC') &
           date.time >= as.POSIXct("2022-04-01 07:00:00", tz='UTC'))

covid.mh258.tail <- covid.mh258.tail|>
  filter(virus == "Infected"|virus=="Recovered")|>
  mutate(inf.stool=1)

covid.mh258.tail$date.time <- align.time(
  as.POSIXct(covid.mh258.tail$date.time), 12 * 60) # temporal res in min=6

covid.mh258.tail <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh258.tail$date.time), "%Y-%m-%d %H:%M")+
    covid.mh258.tail$manhole.id,
  data= covid.mh258.tail,
  FUN = sum)%>% as_tibble()

colnames(covid.mh258.tail) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh258.tail<- covid.mh258.tail[,-2]

covid.mh258.tail$date.time <- parse_date_time(
  covid.mh258.tail$date.time, orders = c("%Y-%m-%d %H:%M"))

covid.mh258.tail.noprevalence <- manholes.snt.pol|>
  filter( manhole.id == 258&
            virus=="Infected"&
            event.typ=="poo"&
            date.time <= as.POSIXct("2022-04-01 17:00:00", tz='UTC') &
            date.time >= as.POSIXct("2022-04-01 07:00:00", tz='UTC'))|>
  mutate(inf.stool=1)

covid.mh258.tail.noprevalence$date.time <- align.time(
  as.POSIXct(covid.mh258.tail.noprevalence$date.time), 12 * 60) # temporal res in min=6

covid.mh258.tail.noprevalence <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh258.tail.noprevalence$date.time), "%Y-%m-%d %H:%M")+
    covid.mh258.tail.noprevalence$manhole.id,
  data= covid.mh258.tail.noprevalence,
  FUN = sum)%>% as_tibble()

colnames(covid.mh258.tail.noprevalence) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh258.tail.noprevalence<- covid.mh258.tail.noprevalence[,-2]

covid.mh258.tail.noprevalence$date.time <- parse_date_time(
  covid.mh258.tail.noprevalence$date.time, orders = c("%Y-%m-%d %H:%M"))

# covid.mh258.tail
# covid.mh258.tail.noprevalence

covid.mh258.tail.yes.no.prevalence<- covid.mh258.tail.noprevalence |> left_join(covid.mh258.tail,by = "date.time")

colnames(covid.mh258.tail.yes.no.prevalence) <-c(
  "date.time","Infected","Infected+recovered")

# dyMultiColumn <- function(dygraph) {
#   dyPlotter(dygraph = dygraph,
#             name = "MultiColumn",
#             path = system.file("plotters/multicolumn.js",
#                                package = "dygraphs"))
# }

# Outbreak Tail: Mh+WWTP ------------

covid.wwtp.mh258.tail <- covid.mh460.tail |> left_join(covid.mh258.tail,by = "date.time")

colnames(covid.wwtp.mh258.tail) <-c(
  "date.time","WWTP","Mh.258")

# (NOT USED) previous plots  ------------




