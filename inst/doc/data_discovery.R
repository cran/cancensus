## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  warning = FALSE, 
  message = FALSE,
  comment = "#>",
  eval = nzchar(Sys.getenv("COMPILE_VIG"))
)
library(cancensus)

## -----------------------------------------------------------------------------
list_census_datasets()

## ----echo=FALSE, fig.alt="Total number of unique variable vectors by Census dataset"----
library(ggplot2)
library(dplyr)
datasets <- c("CA1996","CA01","CA06","CA11","CA16","CA21")

datasets %>%
  lapply(function(ds){
    dplyr::tibble(dataset=ds, vectors=nrow(list_census_vectors(ds)))
  }) %>%
  bind_rows() %>%
  mutate(dataset=factor(dataset,levels=datasets)) %>%
  ggplot(., aes(x = dataset, y = vectors)) +
  geom_col() +
  theme_minimal() +
  theme(panel.grid = element_blank()) +
  labs(x = "Census dataset", y = "",
       title = "Total number of unique variable vectors by Census dataset") +
  scale_y_continuous(labels = scales::comma)

## ----message=FALSE, warning=FALSE---------------------------------------------
list_census_vectors('CA21')

## ----warning=TRUE, message=TRUE-----------------------------------------------
find_census_vectors("Oji-cree", dataset = "CA16", type = "total", query_type = "exact")

## ----warning=TRUE, message=TRUE-----------------------------------------------
find_census_vectors("Ojib-cree", dataset = "CA16", type = "total", query_type = "exact")

## ----warning=TRUE, message=TRUE-----------------------------------------------
find_census_vectors('commute mode', dataset = 'CA16', type = 'female', query_type = 'keyword', interactive = FALSE)

## -----------------------------------------------------------------------------
find_census_vectors("after tax incomes", dataset = "CA16", type = "total", query_type = "semantic")

## ----warning=TRUE, message=TRUE-----------------------------------------------
find_census_vectors("ojib cree", dataset = "CA16", type = "total", query_type = "exact")

## ----warning=TRUE, message=TRUE-----------------------------------------------
find_census_vectors('ojib cree', dataset = 'CA16', type = 'total', query_type = 'semantic')

## ----echo=FALSE---------------------------------------------------------------
tibble(PR = c(35,35,35), CD = c(NA, 18, 18), CSD = c(NA, NA, 013), name = c("Ontario","Durham (Regional municipality","Oshawa (City)"))

## ----echo=FALSE---------------------------------------------------------------
list_census_regions('CA21') %>% 
  group_by(level) %>% 
  tally()

## -----------------------------------------------------------------------------
list_census_regions('CA21')

## ----echo=FALSE, paged.print=TRUE---------------------------------------------
if(Sys.getenv("COMPILE_VIG")=="TRUE") {
    rmarkdown::paged_table(CODES_TABLE)
}

## -----------------------------------------------------------------------------
search_census_regions("Vancouver","CA21")

