public with sharing class ListingTriggerHandler {
    
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
}