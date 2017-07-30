
setwd("..")

tawa_par <- st_read("lds-nz-parcels-SHP-tawa/nz-parcels.shp")
tawa_bf <- st_read("wcbf/wellington-city-building-footprints.shp")
wcc_zone <- st_read("wcc_zones/WCC_District_Plan_Zones.shp") %>% st_transform(4326)

tawa_bf$area <- st_area(tawa_bf)

wcc_zone$dp_zone_mod <- as.character(wcc_zone$dp_zone)
wcc_zone <- wcc_zone %>% mutate(dp_zone_mod = ifelse(dp_zone_mod %in% c("Outer Residential", "Inner Residential"), dp_zone_mod, "Other"))
wcc_zone$dp_zone_mod <- as.factor(wcc_zone$dp_zone_mod)

save(tawa_par, file = "tawa_par.rda")
save(tawa_bf, file = "tawa_bf.rda")
save(wcc_zone, file = "wcc_zone.rda")

###
### spatial joins
###

#5.2.2 
# create an allotment which cannot contain a circle with a radius of 7 metres; or

circle_area <- 7^2*pi

# get several rows per id
tawa_join <- st_join(tawa_par %>% filter(parcel_int == "Fee Simple Title"), tawa_bf)

tawa_join$area <- as.numeric(tawa_join$area)

tawa_join <- tawa_join %>% group_by(id) %>% summarise(b_area = sum(area),
                                                      calc_area = sum(calc_area))

tawa_join <- st_join(tawa_join, wcc_zone %>% select(dp_zone_mod) %>% filter(dp_zone_mod == "Outer Residential"))


tawa_join <- tawa_join %>% group_by(id, dp_zone_mod, calc_area, b_area) %>% summarise() %>% ungroup

tawa_join <- tawa_join %>% filter(dp_zone_mod == "Outer Residential")
###
### Make some assumptions about new section
###
tawa_join <- tawa_join %>% mutate(#after_existing_area = b_area / 0.5,  # assume existing owner gets minimal
                                  after_existing_area = calc_area / 2,  # assume half to new owner
                                  after_outside_area  = after_existing_area - b_area,
                                  new_area            = calc_area - after_existing_area,
                                  new_building_area   = 0.5 * new_area,
                                  new_outside_area    = new_area - new_building_area,
                                  new_site_coverage   = new_building_area/new_area)
#
###
# DISTRICT PLAN RULE LOGIC
###
tawa_join <- tawa_join %>%  mutate(check1 = ifelse(dp_zone_mod == "Outer Residential" & new_site_coverage >= 0.5 & new_outside_area > circle_area & new_building_area > 100 & !(is.na(new_area)), 
                                                  "Subdividable", "Not Subdiviable"))
# make nas Nots  
tawa_join <- tawa_join %>% mutate(check1 = ifelse(is.na(check1), "Not Subdiviable", check1))
                                                      
 
###
###
###
