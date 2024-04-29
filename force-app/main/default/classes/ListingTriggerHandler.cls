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
        
    public void updateSizeOfCharacter(Listing_hz__c listing) {
        try {
            String listingBody = listing.Description_hz__c;
            Integer characterCount = 0;
            
            // String alphaChars = listingBody.replaceAll('[^A-Za-z . \ | - :]','');
            for(Integer i = 0; i < listingBody.length(); i++) {
                if (listingBody.substring(i, i+1) != ' ' && listingBody.substring(i, i+1) != '\n') {
                    characterCount++;
                }
            }
            
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

    public void updateOffPlan(List<Listing_hz__c> newListings, Map<Id, Listing_hz__c> oldMap) {
        try {
            for (Listing_hz__c listing : newListings) {
                Listing_hz__c oldListing = oldMap.get(listing.Id);
                
                if (listing.Completion_Status__c != oldListing.Completion_Status__c) {
                    if (listing.Completion_Status__c == 'Completed') {
                        listing.Off_plan__c = 'No';
                    } else if (listing.Completion_Status__c == 'Off Plan'){
                        listing.Off_plan__c = 'Yes';
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Error--->' + ex.getMessage());
        }
    }
    
}