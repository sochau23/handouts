# Documenting and Publishing your Data Worksheet

# Preparing Data for Publication
library(tidyverse)

stm_dat <- read_csv("data/StormEvents.csv")

head(stm_dat)
tail(stm_dat)

str(stm_dat)

unique(stm_dat$EVENT_NARRATIVE) # check case, white space, etc.

dir.create('storm_project', showWarnings = FALSE) # create directory for project
write_csv(stm_dat, "storm_project/StormEvents_d2006.csv") # write out data file as a new csv file in the directory

# Creating metadata
library(dataspice) ; library(here) # dataspice package to create metadata in the EML metadata standard

create_spice(dir = "storm_project") # create empty data package templates to fill out -> "metadata" folder under "Files" tab

# obtain temporal and geographic extenct info using range() function
range(stm_dat$YEAR) 
range(stm_dat$BEGIN_LAT, na.rm=TRUE)
range(stm_dat$BEGIN_LON, na.rm=TRUE)

# 
edit_biblio(metadata_dir = here("storm_project", "metadata"))

edit_creators(metadata_dir = here("storm_project", "metadata"))

# tries to discover the metadata for itself, automatically fills in fields
prep_access(data_path = here("storm_project"),
            access_path = here("storm_project", "metadata", "access.csv"))
edit_access(metadata_dir = here("storm_project", "metadata"))

prep_attributes(data_path = here("storm_project"),
                attributes_path = here("storm_project", "metadata", "attributes.csv"))
edit_attributes(metadata_dir = here("storm_project", "metadata"))

# write our metadata to aa json-Id file
write_spice(path = here("storm_project", "metadata"))

library(...) ; library(...) ; library(...)

json <- ...("storm_project/metadata/dataspice.json")
eml <- ...(json)
...(eml, "storm_project/metadata/dataspice.xml")

# Creating a data package
library(datapack) ; library(uuid)

dp <- ...("DataPackage") # create empty data package

... <- "storm_project/metadata/dataspice.xml"
... <- paste("urn:uuid:", UUIDgenerate(), sep = "")

... <- new("DataObject", id = ..., format = "eml://ecoinformatics.org/eml-2.1.1", file = ...)

dp <- ...(dp, ...)  # add metadata file to data package

... <- "storm_project/StormEvents_d2006.csv"
... <- paste("urn:uuid:", UUIDgenerate(), sep = "")

... <- new("DataObject", id = ..., format = "text/csv", filename = ...) 

dp <- ...(dp, ...) # add data file to data package

dp <- ...(dp, subjectID = ..., objectIDs = ...)

serializationId <- paste("resourceMap", UUIDgenerate(), sep = "")
filePath <- file.path(sprintf("%s/%s.rdf", tempdir(), serializationId))
status <- serializePackage(..., filePath, id=serializationId, resolveURI = "")

... <- serializeToBagIt(...) # right now this creates a zipped file in the tmp directory
file.copy(..., "storm_project/Storm_dp.zip") # now we have to move the file out of the tmp directory

# this is a static copy of the DataONE member nodes as of July, 2019
read.csv("data/Nodes.csv")






