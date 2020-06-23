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

tibble(dataset = c("CA16","CA11","CA06","CA01"), vectors = c(length(ca16$vector), length(ca11$vector),
                                                             length(ca06$vector), length(ca01$vector))) %>% 
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
  geography <- c("CD", "CD", "CD", "CD", "CD", "CD", "CD", "CD", "CD", "CD", "CD", 
                   "CD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", 
                   "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", 
                   "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", 
                   "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", 
                   "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", "CSD", 
                   "CSD", "CSD", "CSD", "CSD")
    status_code <- c("CDR", "CT", "CTY", "DIS", "DM", "MRC", "RD", "REG", "RM", "TÉ", "TER", 
              "UC", "C", "CC", "CG", "CN", "COM", "CT", "CU", "CV", "CY", "DM", "HAM", 
              "ID", "IGD", "IM", "IRI", "LGD", "LOT", "M", "MD", "MÉ", "MU", "NH", "NL", 
              "NO", "NV", "P", "PE", "RCR", "RDA", "RGM", "RM", "RV", "S-É", "SA", "SC", 
              "SÉ", "SET", "SG", "SM", "SNO", "SV", "T", "TC", "TI", "TK", "TL", "TP", 
              "TV", "V", "VC", "VK", "VL", "VN")
    status <- c("Census division / Division de recensement", "County / Comté", "County", 
                "District", "District municipality", "Municipalité régionale de comté", 
                "Regional district", "Region", "Regional municipality", "Territoire équivalent", 
                "Territory / Territoire", "United counties", "City / Cité", "Chartered community", 
                "Community government", "Crown colony / Colonie de la couronne", "Community", 
                "Canton (municipalité de)", "Cantons unis (municipalité de)", "City / Ville", 
                "City", "District municipality", "Hamlet", "Improvement district", 
                "Indian government district", "Island municipality", 
                "Indian reserve / Réserve indienne", "Local government district", 
                "Township and royalty", "Municipality / Municipalité", "Municipal district", 
                "Municipalité", "Municipality", "Northern hamlet", "Nisga'a land", 
                "Unorganized / Non organisé", "Northern village", 
                "Parish / Paroisse (municipalité de)", "Paroisse (municipalité de)", 
                "Rural community / Communauté rurale", "Regional district electoral area", 
                "Regional municipality", "Rural municipality", "Resort village", 
                "Indian settlement / Établissement indien", "Special area", 
                "Subdivision of county municipality / Subdivision municipalité de comté", 
                "Settlement / Établissement", "Settlement", 
                "Self-government / Autonomie gouvernementale", "Specialized municipality", 
                "Subdivision of unorganized / Subdivision non organisée", "Summer village", 
                "Town", "Terres réservées aux Cris", "Terre inuite", 
                "Terres réservées aux Naskapis", "Teslin land", "Township", "Town / Ville", 
                "Ville", "Village cri", "Village naskapi", "Village", "Village nordique")
    codes_table <- dplyr::tibble(geography = geography, status_code = status_code, status = status)
    rmarkdown::paged_table(codes_table)
}

## -----------------------------------------------------------------------------
search_census_regions("Vancouver","CA16")

