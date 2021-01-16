## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
library(cancensus)

## -----------------------------------------------------------------------------
list_census_datasets()

## ----echo=FALSE---------------------------------------------------------------
library(ggplot2)
library(dplyr)
ca16 <- list_census_vectors("CA16")
ca11 <- list_census_vectors("CA11")
ca06 <- list_census_vectors("CA06")
ca01 <- list_census_vectors("CA01")
ca96 <- list_census_vectors("CA1996")

tibble(dataset = c("CA16","CA11","CA06","CA01","CA1996"), 
       vectors = c(length(ca16$vector), length(ca11$vector),
                   length(ca06$vector), length(ca01$vector),
                   length(ca96$vector))) %>% 
  ggplot(., aes(x = dataset, y = vectors)) +
  geom_col() +
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  labs(x = "Census dataset", y = "",
       title = "Total number of unique variable vectors by Census dataset") +
  scale_y_continuous(labels = scales::comma)

## ----message=FALSE, warning=FALSE---------------------------------------------
list_census_vectors('CA16')

## ---- warning=TRUE, message=TRUE----------------------------------------------
find_census_vectors("Oji-cree", dataset = "CA16", type = "total", query_type = "exact")

## ---- warning=TRUE, message=TRUE----------------------------------------------
find_census_vectors("Ojib-cree", dataset = "CA16", type = "total", query_type = "exact")

## ---- warning=TRUE, message=TRUE----------------------------------------------
find_census_vectors('commute mode', dataset = 'CA16', type = 'female', query_type = 'keyword', interactive = FALSE)

## -----------------------------------------------------------------------------
find_census_vectors("after tax incomes", dataset = "CA16", type = "total", query_type = "semantic")

## ---- warning=TRUE, message=TRUE----------------------------------------------
find_census_vectors("ojib cree", dataset = "CA16", type = "total", query_type = "exact")

## ---- warning=TRUE, message=TRUE----------------------------------------------
find_census_vectors('ojib cree', dataset = 'CA16', type = 'total', query_type = 'semantic')

## ----echo=FALSE---------------------------------------------------------------
tibble(PR = c(35,35,35), CD = c(NA, 18, 18), CSD = c(NA, NA, 013), name = c("Ontario","Durham (Regional municipality","Oshawa (City)"))

## ----echo=FALSE---------------------------------------------------------------
list_census_regions('CA16') %>% 
  group_by(level) %>% 
  tally()

## -----------------------------------------------------------------------------
list_census_regions('CA16')

## ----echo=FALSE, paged.print=TRUE---------------------------------------------
if(Sys.getenv("COMPILE_VIG")=="TRUE") {
    rmarkdown::paged_table(CODES_TABLE)
}

## -----------------------------------------------------------------------------
search_census_regions("Vancouver","CA16")

