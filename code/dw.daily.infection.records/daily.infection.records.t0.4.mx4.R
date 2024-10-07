#Load libraries
library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(ggplot2)
library(lubridate)
library(xts)

#Load SMS-ABM Netlogo outcomes ---- 
daily.infection.t0.4.mx4 <- read_csv(
  "results/daily.infection.records.t0.4.mx4.csv",
  col_names = c(
    "date.time",
    "Population",
    "Poo.infected.population",
    "Poo.during&after.infection",
    "r0"))

# Plotting infection: Stool -----
daily.infection.t0.4.mx4$date.time <- parse_date_time(
  daily.infection.t0.4.mx4$date.time, orders = c("%Y-%m-%d"))

#daily.infection.t0.4.mx4
