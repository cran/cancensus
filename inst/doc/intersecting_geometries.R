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
library(ggplot2)
library(sf)

## -----------------------------------------------------------------------------
cov_station_buffers <- COV_SKYTRAIN_STATIONS %>%
  st_set_crs(4326)  # needed for Ubuntu or systems with old GDAL but can otherwise be ignored

## -----------------------------------------------------------------------------
station_city_ids <- get_intersecting_geometries("CA16", level = "CSD", geometry = cov_station_buffers,
                                                quiet=TRUE)
station_ct_ids <- get_intersecting_geometries("CA16", level = "CT", geometry = cov_station_buffers,
                                              quiet=TRUE)

## -----------------------------------------------------------------------------
variables <- c(mode_base="v_CA16_5792",transit="v_CA16_5801",walk="v_CA16_5804")
station_city <-  get_census("CA16", regions = station_city_ids, vectors = variables, 
                            geo_format = 'sf', quiet=TRUE) %>% 
  filter(name == "Vancouver (CY)")
station_cts <-   get_census("CA16", regions = station_ct_ids, vectors = variables, 
                            geo_format = 'sf', quiet=TRUE)

## ----fig.alt="CTs within City of Vancouver skytrain station catchments"-------
ggplot(station_city) +
  geom_sf(fill=NA) +
  geom_sf(data=station_cts,aes(fill=((walk+transit)/mode_base))) +
  geom_sf(data=cov_station_buffers,fill=NA,alpha=0.5,color="steelblue") +
  scale_fill_viridis_c(option="magma",labels=scales::percent) +
  coord_sf(datum=NA) +
  labs(title="CTs within City of Vancouver skytrain station catchments",
       fill="Walk or\ntransit\nto work",
       caption="StatCan Census 2016")

## ----fig.alt="DAs within City of Vancouver skytrain station catchments"-------
station_das <-   get_intersecting_geometries("CA16", level = "DA", geometry = cov_station_buffers,
                                             quiet=TRUE) %>% 
  get_census("CA16", regions = ., vectors=variables, geo_format = 'sf', quiet=TRUE)

ggplot(station_city) +
  geom_sf(fill=NA) +
  geom_sf(data=station_das,aes(fill=((walk+transit)/mode_base))) +
  geom_sf(data=cov_station_buffers,fill=NA,alpha=0.5,color="steelblue") +
  scale_fill_viridis_c(option="magma",labels=scales::percent) +
  coord_sf(datum=NA) +
  labs(title="DAs within City of Vancouver skytrain station catchments",
       fill="Walk or\ntransit\nto work",
       caption="StatCan Census 2016")


## ----fig.alt="DAs within City of Vancouver skytrain station catchments (alternative method)"----
station_das2 <- get_census("CA16", regions = station_ct_ids, vectors=variables, 
                           geo_format = 'sf', level="DA", quiet=TRUE) %>%
  sf::st_filter(cov_station_buffers)

ggplot(station_city) +
  geom_sf(fill=NA) +
  geom_sf(data=station_das2,aes(fill=((walk+transit)/mode_base))) +
  geom_sf(data=cov_station_buffers,fill=NA,alpha=0.5,color="steelblue") +
  scale_fill_viridis_c(option="magma",labels=scales::percent) +
  coord_sf(datum=NA) +
  labs(title="DAs within City of Vancouver skytrain station catchments",
       fill="Walk or\ntransit\nto work",
       caption="StatCan Census 2016")


