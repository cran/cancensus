## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  message = FALSE, 
  warning = FALSE,
  comment = "#>",
  eval = nzchar(Sys.getenv("COMPILE_VIG"))
)

## ----setup--------------------------------------------------------------------
library(cancensus)
library(dplyr)

## -----------------------------------------------------------------------------
attributes <- get_statcan_geographic_attributes("2021")

attributes %>% colnames()

## -----------------------------------------------------------------------------
attributes %>%
  filter(CMATYPE_RMRGENRE %in% c("B","K")) |> # filter areas not in CTs
  group_by(CTCODE_SRCODE,CMATYPE_RMRGENRE) |>
  summarise(`Number of municipalities`=length(unique(CSDUID_SDRIDU)),.groups="drop") |>
  count(`Number of municipalities`,CMATYPE_RMRGENRE) |>
  arrange(CMATYPE_RMRGENRE,`Number of municipalities`)

