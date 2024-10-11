# WWTP COVID Peak time series for a day --------------------

covid.mh460.peak <- manholes.snt.pol|> 
  filter(manhole.id == 460&
           event.typ=="poo"&
           date.time <= as.POSIXct("2022-03-27 17:00:00", tz='UTC') &
           date.time >= as.POSIXct("2022-03-27 07:00:00", tz='UTC'))

covid.mh460.peak <- covid.mh460.peak|>
  filter(virus == "Infected"|virus=="Recovered")|>
  mutate(inf.stool=1)

# covid.mh460.peak <- manholes.snt.pol|> 
#   filter( manhole.id == 460&
#             virus=="Infected"&
#             event.typ=="poo"&
#             date.time <= as.POSIXct("2022-03-27 17:00:00", tz='UTC') &
#             date.time >= as.POSIXct("2022-03-27 07:00:00", tz='UTC'))|> 
#   mutate(inf.stool=1)

covid.mh460.peak$date.time <- align.time(
  as.POSIXct(covid.mh460.peak$date.time), 12 * 60) # temporal res in min=6

covid.mh460.peak <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh460.peak$date.time), "%Y-%m-%d %H:%M")+
    covid.mh460.peak$manhole.id,
  data= covid.mh460.peak,
  FUN = sum)%>% as_tibble()

colnames(covid.mh460.peak) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh460.peak<- covid.mh460.peak[,-2]

covid.mh460.peak$date.time <- parse_date_time(
  covid.mh460.peak$date.time, orders = c("%Y-%m-%d %H:%M"))

dyBarChart <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "BarChart",
            path = system.file("plotters/barchart.js",
                               package = "dygraphs"))
}


# M.h.258 COVID Peak time series for a day --------------------

covid.mh258.peak <- manholes.snt.pol|> 
  filter(manhole.id == 258&
           event.typ=="poo"&
           date.time <= as.POSIXct("2022-03-27 17:00:00", tz='UTC') &
           date.time >= as.POSIXct("2022-03-27 07:00:00", tz='UTC'))

covid.mh258.peak <- covid.mh258.peak|>
  filter(virus == "Infected"|virus=="Recovered")|>
  mutate(inf.stool=1)

# covid.mh258.peak <- manholes.snt.pol|> 
#   filter( manhole.id == 258&
#             virus=="Infected"&
#             event.typ=="poo"&
#             date.time <= as.POSIXct("2022-03-27 17:00:00", tz='UTC') &
#             date.time >= as.POSIXct("2022-03-27 07:00:00", tz='UTC'))|> 
#   mutate(inf.stool=1)

covid.mh258.peak$date.time <- align.time(
  as.POSIXct(covid.mh258.peak$date.time), 12 * 60) # temporal res in min=6

covid.mh258.peak <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh258.peak$date.time), "%Y-%m-%d %H:%M")+
    covid.mh258.peak$manhole.id,
  data= covid.mh258.peak,
  FUN = sum)%>% as_tibble()

colnames(covid.mh258.peak) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh258.peak<- covid.mh258.peak[,-2]

covid.mh258.peak$date.time <- parse_date_time(
  covid.mh258.peak$date.time, orders = c("%Y-%m-%d %H:%M"))

dyBarChart <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "BarChart",
            path = system.file("plotters/barchart.js",
                               package = "dygraphs"))
}


# Outbreak peak: Mh+WWTP ------------

covid.wwtp.mh258.peak <- covid.mh460.peak |> left_join(covid.mh258.peak,by = "date.time")

colnames(covid.wwtp.mh258.peak) <-c(
  "date.time","WWTP","Mh.258")

# (NOT USED) previous plots  ------------


# ```{r}
# #| echo: false
# #| label: wwtp outbreak peak 
# #| fig-column: page-right
# #| fig-width: 9
# #| fig-height: 3
# #| fig-show: hold
# #| fig-cap: ""
# #| cap-location: margin
# 
# # COVID Peak time series for a day --------------------
# dygraph(covid.mh460.peak,
#         main = "WWTP: Outbreak peak, March 27",
#         ylab = "SARS-CoV-2 stool events") %>%#dyRangeSelector() %>%
#   dyFilledLine('stool.infected')|>#dyBarChart()|>
#   dySeries('stool.infected', color='#756bb1')
# 
# ```
# 
# ```{r}
# #| echo: false
# #| label: mh258 outbreak peak 
# #| fig-column: page-right
# #| fig-width: 9
# #| fig-height: 3
# #| fig-show: hold
# #| fig-cap: ""
# #| cap-location: margin
# 
# # COVID Peak time series for a day --------------------
# dygraph(covid.mh258.peak,
#         main = "Mh 258: Outbreak peak, March 27",
#         ylab = "SARS-CoV-2 stool events") %>%#  dyRangeSelector() %>%
#   dyFilledLine('stool.infected')|> #dyBarChart()|> 
#   dySeries('stool.infected', color='#756bb1')
# 
# ```

