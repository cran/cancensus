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

## ----include = FALSE----------------------------------------------------------
# Skip the remaining chunks if the download failed, e.g. on CI
knitr::opts_chunk$set(eval = !is.null(attributes))

## -----------------------------------------------------------------------------
attr(attributes, "metadata")$attribution_en
attr(attributes, "metadata")$licence_en

## -----------------------------------------------------------------------------
attributes %>% colnames()

## -----------------------------------------------------------------------------
attributes %>%
  filter(CMATYPE %in% c("B","K")) |> # filter areas not in CTs
  group_by(CTCODE,CMATYPE) |>
  summarise(`Number of municipalities`=length(unique(CSDUID)),.groups="drop") |>
  count(`Number of municipalities`,CMATYPE) |>
  arrange(CMATYPE,`Number of municipalities`)

## -----------------------------------------------------------------------------
attributes_1981 <- get_statcan_geographic_attributes("1981")
attributes_1981 %>% colnames()
attr(attributes_1981$EAPHH1981, "label")
attributes_1981 %>% summarise(Population = sum(EAPOP1981, na.rm = TRUE))
attr(attributes_1981, "metadata")$notes_en

## -----------------------------------------------------------------------------
point_metadata <- attr(attributes, "metadata")$columns$DARPLAT
point_metadata$crs_en
point_metadata$crs_basis

## -----------------------------------------------------------------------------
library(sf)
library(ggplot2)

da_points <- attributes %>%
  filter(CMAUID == "933") %>%
  group_by(DAUID, DARPLONG, DARPLAT) %>%
  summarise(Population = sum(DBPOP2021, na.rm = TRUE), .groups = "drop") %>%
  st_as_sf(coords = c("DARPLONG", "DARPLAT"), crs = point_metadata$crs_epsg)

ggplot(da_points) +
  geom_sf(aes(size = Population), alpha = 0.3, shape = 16) +
  scale_size_area(max_size = 3) +
  theme_void() +
  labs(title = "Metro Vancouver dissemination area representative points, 2021")

## -----------------------------------------------------------------------------
attributes_1996 <- get_statcan_geographic_attributes("1996")
crs_1996 <- attr(attributes_1996, "metadata")$columns$EARPLAT$crs_epsg
crs_1996

ea_points <- attributes_1996 %>%
  filter(CMAUID == "933") %>%
  st_as_sf(coords = c("EARPLONG", "EARPLAT"), crs = crs_1996) %>%
  st_transform(st_crs(da_points))

