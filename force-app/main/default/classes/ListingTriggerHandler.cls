public with sharing class ListingTriggerHandler {
    
    List<Listing_hz__c> recordNewList = new List<Listing_hz__c>();
    List<Listing_hz__c> recordOldList = new List<Listing_hz__c>();
    Map<Id, Listing_hz__c> recordNewMap = new Map<Id, Listing_hz__c>();
    Map<Id, Listing_hz__c> recordOldMap = new Map<Id, Listing_hz__c>();
    Boolean isInsert ;
    Boolean isUpdate ;
    Boolean isDelete = false;
    Boolean isUndelete = false;
    private static final string CLASS_NAME = 'ListingTriggerHandler';

    public ListingTriggerHandler(List<Listing_hz__c> newList, List<Listing_hz__c> oldList, Map<Id, Listing_hz__c> newMap, Map<Id, Listing_hz__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete) {
        this.recordNewList = newList;
        this.recordOldList = oldList;
        this.recordNewMap = newMap;
        this.recordOldMap = oldMap;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
    }

    public void OnBeforeInsert(List<Listing_hz__c> newListings){
        for (Listing_hz__c listing : newListings) {
            if (listing.Status__c == 'Active') {
                listing.SystemAllowedForPortals__c = true; 
            } else {
                listing.SystemAllowedForPortals__c = false;
            }
        }
    }

    public void OnBeforeUpdate(List<Listing_hz__c> newListings){
        for (Listing_hz__c listing : newListings) {
            if (listing.Status__c == 'Active') {
                listing.SystemAllowedForPortals__c = true; 
            } else {
                listing.SystemAllowedForPortals__c = false;
                List<PortalListing__c> portalListings = [SELECT Id,Listing_hz__c,SystemIsActive__c FROM PortalListing__c WHERE Listing_hz__c IN : newListings];
                List<PortalListing__c> portalListings_toUpdate = new List<PortalListing__c>();
                if(portalListings.size()>0){
                    for(PortalListing__c portalListing : portalListings){
                        portalListing.SystemIsActive__c = false;
                        portalListings_toUpdate.add(portalListing);
                    }
                    update portalListings_toUpdate;
                }
            }
        }
    }

    public void beforeInsertEvent(){
        handleListingBeforeInsert();
    }

    public void beforeUpdateEvent(){
        handleListingBeforeupdate();
    }

    public void afterInsertEvent() {
        handleListingAfterInsert();
    }

    public void handleListingBeforeInsert() {
        for (Listing_hz__c listing : recordNewList) {
            if (listing.Description_hz__c != null) {
                updateSizeOfCharacter(listing);
            }
        }
    }
    
    public void handleListingBeforeupdate() {
        for (Integer i = 0; i < recordNewList.size(); i++) {
            Listing_hz__c newListing = recordNewList[i];
            
            if (newListing.Description_hz__c	 != null) {
                updateSizeOfCharacter(newListing);
            }
        }
    }

    public void handleListingAfterInsert() {
        try {
        System.debug('After insert event');
        List<Property_hz__c> propertiesToInsert = new List<Property_hz__c>();
        List<Listing_hz__c> listingsToUpdate = new List<Listing_hz__c>();
    
        for (Listing_hz__c listing : recordNewList) {
            if (listing.Property_hz__c == null) {   
                Property_hz__c property = new Property_hz__c();
                property.Name = listing.Name;

                if (listing.Address_hz__c != null) {
                    property.Address_hz__c = listing.Address_hz__c;
                }
                if (listing.Apartment_Number_and_Name__c != null) {
                    property.Apartment_Number_and_Name__c = listing.Apartment_Number_and_Name__c;
                }
                if (listing.Area_hz__c != null) {
                    property.Area_hz__c = listing.Area_hz__c;
                }
                if (listing.Bathrooms_US__c != null) {
                    property.Bathrooms_US__c = Decimal.valueOf(listing.Bathrooms_US__c);
                }
                if (listing.Bedrooms_hz__c != null) {
                    property.Bedrooms_hz__c = listing.Bedrooms_hz__c;
                }
                if (listing.City_hz__c != null) {
                    property.City_hz__c = listing.City_hz__c;
                }
                if (listing.CompletionDate__c != null) {
                    property.CompletionDate__c = listing.CompletionDate__c;
                }
                if (listing.CompletionDate_hz__c != null) {
                    property.CompletionDate_hz__c = listing.CompletionDate_hz__c;
                }
                if (listing.CompletionStatus__c != null) {
                    property.CompletionStatus__c = listing.CompletionStatus__c;
                }
                if (listing.CompletionStatus_hz__c != null) {
                    property.CompletionStatus_hz__c = listing.CompletionStatus_hz__c;
                }
                if (listing.Country_hz__c != null) {
                    property.Country_hz__c = listing.Country_hz__c;
                }
                if (listing.CountryCode_hz__c != null) {
                    property.CountryCode_hz__c = listing.CountryCode_hz__c;
                }
                if (listing.Description_hz__c != null) {
                    property.Description_hz__c = listing.Description_hz__c;
                }
                if (listing.EPC_Address__c != null) {
                    property.EPC_Address__c = listing.EPC_Address__c;
                }
                if (listing.EPC_Energy_Efficiency_current__c != null) {
                    property.EPC_Energy_Efficiency_current__c = listing.EPC_Energy_Efficiency_current__c;
                }
                if (listing.EPC_Energy_Efficiency_potential__c != null) {
                    property.EPC_Energy_Efficiency_potential__c = listing.EPC_Energy_Efficiency_potential__c;
                }
                if (listing.EPC_Sync_Status__c != null) {
                    property.EPC_Sync_Status__c = listing.EPC_Sync_Status__c;
                }
                if (listing.Floor__c != null) {
                    property.Floor_houzon__c = listing.Floor__c;
                }
                if (listing.FullBathrooms_hz__c != null) {
                    property.FullBathrooms_hz__c = listing.FullBathrooms_hz__c;
                }
                if (listing.Private_Amenities__c != null) {
                    property.Private_Amenities__c = listing.Private_Amenities__c;
                }
                if (listing.Property_Sub_Type__c != null) {
                    property.Property_Sub_Type__c = listing.Property_Sub_Type__c;
                }
                if (listing.Sub_Community_Propertyfinder__c != null) {
                    property.Sub_Community_Propertyfinder__c = listing.Sub_Community_Propertyfinder__c;
                }
                if (listing.PropertyOwnerContact__c != null) {
                    property.PropertyOwnerContact__c = listing.PropertyOwnerContact__c;
                }
                if (listing.GeocodeAccuracy_hz__c != null) {
                    property.GeocodeAccuracy_hz__c = listing.GeocodeAccuracy_hz__c;
                }
                if (listing.HalfBathrooms_hz__c != null) {
                    property.HalfBathrooms_hz__c = listing.HalfBathrooms_hz__c;
                }
                if (listing.Latitude_hz__c != null) {
                    property.Latitude_hz__c = listing.Latitude_hz__c;
                }
                if (listing.Lmk_Key__c != null) {
                    property.Lmk_Key__c = listing.Lmk_Key__c;
                }
                if (listing.Longitude_hz__c != null) {
                    property.Longitude_hz__c = listing.Longitude_hz__c;
                }
                if (listing.LotSize_hz__c != null) {
                    property.LotSize_hz__c = listing.LotSize_hz__c;
                }
                if (listing.Measurement_hz__c != null) {
                    property.Measurement_hz__c = listing.Measurement_hz__c;
                }
                if (listing.PostalCode_hz__c != null) {
                    property.PostalCode_hz__c = listing.PostalCode_hz__c;
                }
                if (listing.PropertyType__c != null) {
                    property.PropertyType__c = listing.PropertyType__c;
                }
                if (listing.State_hz__c != null) {
                    property.State_hz__c = listing.State_hz__c;
                }
                if (listing.StateCode_hz__c != null) {
                    property.StateCode_hz__c = listing.StateCode_hz__c;
                }
                if (listing.Street_hz__c != null) {
                    property.Street_hz__c = listing.Street_hz__c;
                }
                if (listing.Street_Number__c != null) {
                    property.Street_Number__c = listing.Street_Number__c;
                }
                if (listing.TotalArea_hz__c != null) {
                    property.TotalArea_hz__c = listing.TotalArea_hz__c;
                }
                if (listing.Building_Dubizzle__c != null) {
                    property.Building_Dubizzle__c = listing.Building_Dubizzle__c;
                }
                if (listing.City_Dubizzle__c != null) {
                    property.City_Dubizzle__c = listing.City_Dubizzle__c;
                }
                if (listing.City_Propertyfinder__c != null) {
                    property.City_Propertyfinder__c = listing.City_Propertyfinder__c;
                }
                if (listing.Community_Propertyfinder__c != null) {
                    property.Community_Propertyfinder__c = listing.Community_Propertyfinder__c;
                }
                if (listing.Furnished__c != null) {
                    property.Furnished__c = listing.Furnished__c;
                }
                if (listing.View_hz__c != null) {
                    property.View_hz__c = listing.View_hz__c;
                }
                if (listing.Year_Built_Text__c != null) {
                    property.Year_Built_Text__c = listing.Year_Built_Text__c;
                }
                if (listing.YearBuilt_hz__c != null) {
                    property.YearBuilt_hz__c = listing.YearBuilt_hz__c;
                }
                propertiesToInsert.add(property);
            }
        }
        
        if (!propertiesToInsert.isEmpty()) {
            insert propertiesToInsert;

            Map<String, Id> propertyNameToIdMap = new Map<String, Id>();
            for (Property_hz__c prop : propertiesToInsert) {
                propertyNameToIdMap.put(prop.Name, prop.Id);
            }
            
            for (Listing_hz__c listing : recordNewList) {
                Listing_hz__c updateListing = new Listing_hz__c();
                if (listing.Property_hz__c == null) {   
                    updateListing.Id = listing.Id;
                    updateListing.Property_hz__c = propertyNameToIdMap.get(listing.Name);
                    listingsToUpdate.add(updateListing);
                }
            }
            
            if (!listingsToUpdate.isEmpty()) {
                update listingsToUpdate;
            }
        }
    } catch(Exception e) {
        System.debug('Exception in after insert listing: '+ e.getLineNumber() + e.getMessage());   
    }
    }
        
    public void updateSizeOfCharacter(Listing_hz__c listing) {
        try {
            String listingBody = listing.Description_hz__c;
            Integer characterCount = listingBody.length();
            
            // // String alphaChars = listingBody.replaceAll('[^A-Za-z . \ | - :]','');
            // for(Integer i = 0; i < listingBody.length(); i++) {
            //     if (listingBody.substring(i, i+1) != ' ' && listingBody.substring(i, i+1) != '\n') {
            //         characterCount++;
            //     }
            // }
            
            listing.Description_word_count__c = characterCount;
    
        } catch (Exception e) {
            System.debug('Exception: ' + e);
        }
    }

    public void updateRentFrequency(List<Listing_hz__c> newListings, Map<Id, Listing_hz__c> oldMap) {
        try {
            for (Listing_hz__c listing : newListings) {
                Listing_hz__c oldListing = oldMap.get(listing.Id);
                
                if (listing.Price_Unit__c != oldListing.Price_Unit__c) {
                    if (listing.Price_Unit__c == 'Price Yearly') {
                        listing.Rent_Frequency__c = 'Yearly';
                    } else if (listing.Price_Unit__c == 'Price Monthly') {
                        listing.Rent_Frequency__c = 'Monthly';
                    } else if (listing.Price_Unit__c == 'Price Weekly') {
                        listing.Rent_Frequency__c = 'Weekly';
                    } else if (listing.Price_Unit__c == 'Price Daily') {
                        listing.Rent_Frequency__c = 'Daily';
                    } else if (listing.Price_Unit__c == 'Price Monthly Per Room') {
                        listing.Rent_Frequency__c = 'Monthly';
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Error--->' + ex.getMessage());
        }
    }

    // public void updateOffPlan(List<Listing_hz__c> newListings, Map<Id, Listing_hz__c> oldMap) {
    //     try {
    //         for (Listing_hz__c listing : newListings) {
    //             Listing_hz__c oldListing = oldMap.get(listing.Id);
                
    //             if (listing.Completion_Status__c != oldListing.Completion_Status__c) {
    //                 if (listing.Completion_Status__c == 'Completed') {
    //                     listing.Off_plan__c = 'No';
    //                 } else if (listing.Completion_Status__c == 'Off Plan'){
    //                     listing.Off_plan__c = 'Yes';
    //                 }
    //             }
    //         }
    //     } catch (Exception ex) {
    //         System.debug('Error--->' + ex.getMessage());
    //     }
    // }
    
}