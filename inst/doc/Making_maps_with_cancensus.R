## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = nzchar(Sys.getenv("COMPILE_VIG"))
)

mb_token <- Sys.getenv("MB_TOKEN")

## ----message = FALSE, warning = FALSE-----------------------------------------
library(cancensus)
library(sf)
# retrieve sf dataframe
toronto <- get_census(dataset='CA21', regions=list(CMA="35535"),
                         vectors=c("median_hh_income"="v_CA21_906"), level='CSD', quiet = TRUE, 
                         geo_format = 'sf', labels = 'short')

## -----------------------------------------------------------------------------
plot(toronto["median_hh_income"], main = "Toronto Household Income by CSD in 2020")

## -----------------------------------------------------------------------------
plot(st_geometry(toronto), col = NA, main = "Toronto CSDs with Median HH Income > $125,000 in 2020", lty = 3)
plot(st_geometry(toronto[toronto$median_hh_income > 125000,]), col = "red", add = TRUE)

## -----------------------------------------------------------------------------
library(ggplot2)
ggplot(toronto) + geom_sf(aes(fill = median_hh_income))

## -----------------------------------------------------------------------------
ggplot(toronto) + geom_sf(aes(fill = median_hh_income), colour = "grey") +
  scale_fill_viridis_c("Median HH Income", labels = scales::dollar) + theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) + 
  coord_sf(datum=NA) +
  labs(title = "Median Household Income in 2020", subtitle = "Toronto Census Subdivisions, 2021 Census")

## ----message=FALSE, warning=FALSE, include=FALSE------------------------------
# This chunk disables leaflet and mapdeck output in remaining chunks for PDF vignettes
if(Sys.getenv("COMPILE_VIG")!="TRUE") {
  knitr::opts_chunk$set(eval = FALSE)}

## ----message = FALSE----------------------------------------------------------
library(leaflet)
leaflet(toronto) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons()

## -----------------------------------------------------------------------------
bins <- c(0, 30000,40000, 50000,60000, 70000,80000, 90000,100000, 110000, Inf)
pal <- colorBin("RdYlBu", domain = toronto$v_CA16_2397, bins = bins)
leaflet(toronto) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(fillColor = ~pal(median_hh_income),
              color = "white",
              weight = 1,
              opacity = 1,
              fillOpacity = 0.65)

