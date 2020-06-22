## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  message = FALSE, 
  warning = FALSE,
  comment = "#>",
  eval = nzchar(Sys.getenv("COMPILE_VIG"))
)

## ----setup, message = FALSE, warning = FALSE----------------------------------
# Packages used in this example
library(cancensus)
library(dplyr)
library(tidyr)
library(ggplot2)

## -----------------------------------------------------------------------------
# Attribution for the dataset to be used in graphs
attribution <- dataset_attribution("CA16xSD")

# Select all variables base variables, this gives us total counts by structural type of dwelling
vars <- list_census_vectors("CA16xSD") %>% 
  filter(is.na(parent_vector))
variables <- setNames(vars$vector,vars$label)

variables

## -----------------------------------------------------------------------------
# Separate out the individual dwelling types
dwelling_types <- setdiff(names(variables),"Total dwellings")

# Grab the census data and compute shares for each dwelling type
census_data <- get_census("CA16xSD",regions=list(CSD="3520005"), vectors = variables, quiet = TRUE) %>%
  pivot_longer(cols = all_of(dwelling_types)) %>%
  mutate(share=value/`Total dwellings`)

## -----------------------------------------------------------------------------
ggplot(census_data,aes(x=reorder(name,share),y=share)) +
  geom_bar(stat="identity",fill="steelblue") +
  coord_flip() +
  scale_y_continuous(labels=scales::percent) +
  labs(title="City of Toronto dwelling units by structural type",
       x=NULL,y=NULL,caption=attribution)

## -----------------------------------------------------------------------------
# Use explore_census_vectors() to browse and select variables of interest
vars <- c(Total="v_CA16xSD_1", Unoccupied="v_CA16xSD_28")

# Retrieve data with attached geography
census_data <- get_census("CA16xSD",regions=list(CSD="3520005"), level="CT", quiet = TRUE, geo_format = "sf",
                          vectors = vars,use_cache = FALSE) %>%
  mutate(share=Unoccupied/Total)

# Visualize
ggplot(census_data,aes(fill=share)) +
  geom_sf(size=0.1) +
  scale_fill_viridis_c(labels=scales::percent) +
  coord_sf(datum=NA) +
  labs(title="City of Toronto dwellings unoccupied on census day",
       fill="Share",
       x=NULL,y=NULL,caption=attribution)

