# WWTP COVID early detection time series for a day -------------

covid.mh460 <- manholes.snt.pol|> 
  filter( manhole.id == 460&
            virus=="Infected"&
            event.typ=="poo"&
            date.time <= as.POSIXct("2022-03-21 17:00:00", tz='UTC') &
            date.time >= as.POSIXct("2022-03-21 07:00:00", tz='UTC'))|> 
  mutate(inf.stool=1)

covid.mh460$date.time <- align.time(
  as.POSIXct(covid.mh460$date.time), 12 * 60) # temporal res in min=6

covid.mh460 <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh460$date.time), "%Y-%m-%d %H:%M")+
    covid.mh460$manhole.id,
  data= covid.mh460,
  FUN = sum)%>% as_tibble()

colnames(covid.mh460) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh460<- covid.mh460[,-2]

covid.mh460$date.time <- parse_date_time(
  covid.mh460$date.time, orders = c("%Y-%m-%d %H:%M"))

dyBarChart <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "BarChart",
            path = system.file("plotters/barchart.js",
                               package = "dygraphs"))
}

# M.h.258 COVID early detection time series for a day -------------

covid.mh258 <- manholes.snt.pol|> 
  filter( manhole.id == 258&
            virus=="Infected"&
            event.typ=="poo"&
            date.time <= as.POSIXct("2022-03-21 17:00:00", tz='UTC') &
            date.time >= as.POSIXct("2022-03-21 07:00:00", tz='UTC'))|> 
  mutate(inf.stool=1)

covid.mh258$date.time <- align.time(
  as.POSIXct(covid.mh258$date.time), 12 * 60) # temporal res in min=6

covid.mh258 <- aggregate(
  inf.stool ~format(as.POSIXct(covid.mh258$date.time), "%Y-%m-%d %H:%M")+
    covid.mh258$manhole.id,
  data= covid.mh258,
  FUN = sum)%>% as_tibble()

colnames(covid.mh258) <-c(
  "date.time","manhole.id","stool.infected")

covid.mh258<- covid.mh258[,-2]

covid.mh258$date.time <- parse_date_time(
  covid.mh258$date.time, orders = c("%Y-%m-%d %H:%M"))

dyBarChart <- function(dygraph) {
  dyPlotter(dygraph = dygraph,
            name = "BarChart",
            path = system.file("plotters/barchart.js",
                               package = "dygraphs"))
}


# Early outbreak: Mh+WWTP ------------

covid.wwtp.mh258.early <- covid.mh460 |> left_join(covid.mh258,by = "date.time")

colnames(covid.wwtp.mh258.early) <-c(
  "date.time","WWTP","Mh.258")

# (NOT USED) previous plots  ------------

# ```{r}
# #| echo: false
# #| label: wwtp early outbreak
# #| fig-column: page-right
# #| fig-width: 9
# #| fig-height: 3
# #| fig-show: hold
# #| fig-cap: ""
# #| cap-location: margin
# 
# # COVID early detection time series for a day -------------
# 
# dygraph(covid.mh460,
#         main = "WWTP: Early outbreak, March 21",
#         ylab = "SARS-CoV-2 stool events") %>%#dyRangeSelector() %>%
#   dyFilledLine('stool.infected')|> # dyBarChart()|>
#   dySeries('stool.infected', color='#756bb1')
# 
# ```
# 
# 
# ```{r}
# #| echo: false
# #| label: mh258 early outbreak
# #| fig-column: page-right
# #| fig-width: 9
# #| fig-height: 3
# #| fig-show: hold
# #| fig-cap: ""
# #| cap-location: margin
# 
# 
# dygraph(covid.mh258,
#         main = "Mh 258: Early outbreak, March 21",
#         ylab = "SARS-CoV-2 stool events") %>%#  dyRangeSelector() %>%
#   dyFilledLine('stool.infected')|> #dyBarChart()|>
#   dySeries('stool.infected', color='#756bb1')
# 
# ```


