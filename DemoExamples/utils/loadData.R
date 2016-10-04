# 
# loadData.R
# load data file for demo, source is the open data page of the city Zurich
# urls have been validated on 29.09.2016
#
# in order to run the demo smoothly, I decided to store the data sources locally :)
# however, one could access them directly using the following URLs
#       fountainsURL <- "https://data.stadt-zuerich.ch/dataset/brunnen/resource/d741cf9c-63be-495f-8c3e-9418168fcdbf/download/brunnen.json"
#       districtofficesURL <- "https://data.stadt-zuerich.ch/dataset/kreisbuero/resource/9b56f25f-84aa-49f4-afcf-3f5015e3e10e/download/kreisbuero.json"
#       gastroURL <- "https://data.stadt-zuerich.ch/dataset/gastwirtschaftsbetriebe/resource/98be8b4d-2173-494f-946a-b85036a614b2/download/gastwirtschaftsbetriebe20151231.json"
# and then just use fromJSON(txt = xyURL)
#


fountains.raw <- fromJSON("data/fountains.json")
fountains <- fountains.raw$features$geometry %>%
        extract(coordinates, c("Longitude", "Latitude"), "\\(([^,]+), ([^)]+)\\)") %>%
        select(-type)

districtOffices.raw <- fromJSON("data/districtoffices.json")
districtOffices <- districtOffices.raw$features$geometry %>%
        extract(coordinates, c("Longitude", "Latitude"), "\\(([^,]+), ([^)]+)\\)") %>%
        mutate(names = districtOffices.raw$features$properties$Name) %>%
        select(-type)

gastro.raw <- fromJSON("data/gastro.json")
gastro.coords <- gastro.raw$features$geometry %>%
        extract(coordinates, c("Longitude", "Latitude"), "\\(([^,]+), ([^)]+)\\)") %>%
        select(-type)
gastro.properties <- gastro.raw$features$properties
gastro <- cbind(gastro.coords, gastro.properties)

