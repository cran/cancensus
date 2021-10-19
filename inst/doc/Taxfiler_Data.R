## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE,
  eval = nzchar(Sys.getenv("COMPILE_VIG"))
)
# Adding a check for CensusMapper server status. There are occasional cert and other issues affecting CensusMapper servers, and this causes failure of some automated testing - CRAN in particular. If this check passes, we move on and compile the rest of the vignette. If it fails, we compile without evaluating. 
check <- tryCatch(get_census(dataset='CA16', regions=list(CMA="59933"),
           vectors=c("v_CA16_408"),
           level='CMA', use_cache = FALSE, geo_format = NA), error = function(e) {print("Invalid")})

if(class(check)=="character") {
  eval = FALSE
}

## ----setup--------------------------------------------------------------------
# Packages used for example
library(cancensus)
library(dplyr)
library(tidyr)
library(ggplot2)
library(sf)

## -----------------------------------------------------------------------------
list_census_datasets() %>% 
  filter(grepl("taxfiler",description))

## -----------------------------------------------------------------------------
list_census_vectors('TX2017')

## -----------------------------------------------------------------------------
years <- c(2006,2011,2014,2018)
# Attribution for the dataset to be used in graphs
attribution <- dataset_attribution(paste0("TX",years))

plot_data <- years %>%
  lapply(function(year) {
    dataset <- paste0("TX",year)
    vectors <- c("Families"=paste0("v_",dataset,"_607"),
                 "CFLIM-AT"=paste0("v_",dataset,"_786"))
    
    get_census(dataset,regions=list(CMA="59933"),vectors = vectors,
                    geo_format = 'sf', level="CT", quiet = TRUE) %>%
      select(c("GeoUID",names(vectors))) %>%
      mutate(Year=year)
  }) %>%
  bind_rows() %>%
  mutate(share=`CFLIM-AT`/Families)

## -----------------------------------------------------------------------------
ggplot(plot_data,aes(fill=share)) +
  geom_sf(size=0.1,color="white") +
  facet_wrap("Year") +
  scale_fill_viridis_c(labels=scales::percent,option = "inferno",
                       trans="log",breaks = c(0.05,0.1,0.2,0.4)) +
  coord_sf(datum=NA,xlim=c(-123.4, -122.5), ylim=c(49.01, 49.4)) +
  labs(title="Share of census families in low income",fill="Share",
       caption=attribution)

## -----------------------------------------------------------------------------
change_data <- plot_data %>% 
  filter(Year==2006) %>% 
  select(GeoUID,`2006`=share) %>%
  left_join(plot_data %>%
              st_set_geometry(NULL) %>%
              filter(Year==2011) %>% 
              select(GeoUID,`2011`=share),
            by="GeoUID") %>%
  mutate(change=`2011`-`2006`)
  
ggplot(change_data,aes(fill=change)) +
  geom_sf(size=0.1) +
  scale_fill_gradient2(labels=scales::percent) +
  #scale_fill_viridis_c(labels=scales::percent,option = "inferno") +
  coord_sf(datum=NA,xlim=c(-123.4, -122.5), ylim=c(49.01, 49.4)) +
  labs(title="Change in share of census families in low income 2006-2011",fill="Percentage\npoint change",caption=dataset_attribution(paste0("TX",c(2006,2011))))

