##--------------------------------------
##  Simplocation leaflet map
##
## For Gov Hack 2017
##
## Zac 30 July 2017
##
##--------------------------------------

library(sf)
library(dplyr)
library(leaflet)

setwd("C:/Maps/Simplocation_leaflet/simplocation_leaflet/")

source("clean.R")

# POPUP on click
bf_popup <- paste0("<strong>Building footprint: </strong>", round(as.numeric(tawa_bf$area), 1), " m2")
par_popup <- paste0("<strong>Section Area: </strong>", round(tawa_par$calc_area, 1), " m2")

tawa_par$check1 <- as.factor(tawa_join$check1)
tawa_join$check1 <- as.factor(tawa_join$check1) 

# Colour pallettes
pal <- colorFactor("RdYlBu", domain = wcc_zone$dp_zone_mod)
pal2 <- colorFactor(c("white", "purple"), domain = tawa_join$check1)

options(viewer = NULL)
m = leaflet() %>% 
    setView(174.827135, -41.167059, zoom = 16)   %>% 
    # BASE map from HERE
    addProviderTiles("HERE.normalDay",
                    options=providerTileOptions(app_id="KMHWlJF1zAusb05MVpux",app_code="_5nxXPBgaTe4PmhmxtD5cg"),
                    group = "HERE_normal_day") %>%
    # annother base map from HERE!
    addProviderTiles("HERE.hybridDay",
                     options=providerTileOptions(app_id="KMHWlJF1zAusb05MVpux",app_code="_5nxXPBgaTe4PmhmxtD5cg"),
                     group = "HERE_hybrid_day") %>%
   #  Wellington city council zoning layer
      addPolygons(data = wcc_zone, color = ~pal(dp_zone_mod), fillOpacity = 0.3, weight = 0.8, group = "council_zone") %>%
    # LEGEND
    addLegend(position = "bottomright", 
              colors = pal(levels(wcc_zone$dp_zone_mod)),
              labels = c("Inner Residential", "Other" ,  "Outer Residential"),
              title = "Council Zones",
              opacity = 0.7) %>%
    ## Add our join data
    addPolygons(data = tawa_join, stroke = FALSE, color = ~pal2(check1), group = "feasible") %>%
    # LEGEND join
    addLegend(position = "bottomright", 
              colors = pal2(levels(tawa_join$check1)),
              labels = c("Not Subdividable", "Subdividable"),
              title = "Feasibility Check",
              opacity = 0.7) %>%
    # linz parcles
    addPolygons(data = tawa_par, fillOpacity = 0, opacity = 0.2, weight = 0.8, color = "black", group = "parcels",
                popup = par_popup) %>%
    # wellington city council building footprint
    addPolygons(data = tawa_bf, fillOpacity = 0.2, opacity = 0.3, weight = 0.8, color = "black", group = "building_footprint",
                popup = bf_popup) %>%
    # Layers control
    addLayersControl(
      baseGroups = c("HERE_normal_day", "HERE_hybrid_day"),
      overlayGroups = c("parcels", "building_footprint", "council_zone", "feasible"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    hideGroup("feasible")


library(htmlwidgets)
saveWidget(m, file="m_test2.html")

  