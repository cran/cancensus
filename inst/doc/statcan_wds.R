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
library(tidyr)
library(ggplot2)

## -----------------------------------------------------------------------------
metadata <- get_statcan_wds_metadata("2021","FED")

characteristics <- metadata |> 
  filter(`Codelist en`=="Characteristic") |>
  mutate(across(matches("ID"),as.integer))

ethnic_base <- characteristics |> 
  filter(grepl("Total - Ethnic",en))
ukranian <- characteristics |> 
  filter(grepl("Ukrainian",en), `Parent ID`==ethnic_base$ID) 

selected_characteristics <- bind_rows(ethnic_base,ukranian)

selected_characteristics |> select(ID,en)

## -----------------------------------------------------------------------------
dguids <- metadata |>
  filter(`Codelist ID`=="CL_GEO_FED") |>
  pull(ID)

## -----------------------------------------------------------------------------
data <- get_statcan_wds_data(dguids,members=selected_characteristics$ID,gender="Total")

## -----------------------------------------------------------------------------
plot_data <- data |> 
  select(DGUID=GEO_DESC,Name=GEO_NAME,name=CHARACTERISTIC_NAME,value=OBS_VALUE) |>
  pivot_wider() |>
  mutate(Share=Ukrainian/`Total - Ethnic or cultural origin for the population in private households - 25% sample data`)

## ----fig.height=4.5, fig.width=6----------------------------------------------
plot_data |> slice_max(Share,n=20) |>
  ggplot(aes(y=reorder(Name,Share),x=Share)) +
  geom_bar(stat="identity",fill="steelblue") +
  scale_x_continuous(labels=scales::percent) +
  labs(title="Ukrainian ethnic origin",
       y="Federal electoral district",
       x="Share of population in private households",
       caption="StatCan Census 2021")

## -----------------------------------------------------------------------------
fed_geos <- get_statcan_geographies("2021","FED")

## ----fig.height=4.5, fig.width=6----------------------------------------------
fed_geos |>
  left_join(plot_data,by="DGUID") |>
  ggplot(aes(fill=Share)) +
  geom_sf() +
  scale_fill_viridis_c(labels=scales::percent) +
  coord_sf(datum=NA) +
  labs(title="Ukrainian ethnic origin by Federal Electoral District",
       fill="Share of\npopulation",
       caption="StatCan Census 2021")

