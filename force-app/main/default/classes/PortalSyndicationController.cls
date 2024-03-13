public with sharing class PortalSyndicationController {

    @AuraEnabled
    public static string createPortalListingRecord(String listingId, String portalId, String actionType){
        try {
            // mark Inactive all the existing Portal Listings for the Listing
            List<PortalListing__c> portalListings = [SELECT Id, SystemIsActive__c FROM PortalListing__c WHERE Listing_hz__c =: listingId AND Portal__c =: portalId AND SystemIsActive__c = true];
            if (portalListings != null && portalListings.size() > 0) {
                for (PortalListing__c portalListing : portalListings) {
                    portalListing.SystemIsActive__c = false;
                    portalListing.UnlistedDate__c = System.today();
                }
                update portalListings;
            }

            if (actionType == 'Publish') {
                // Create a new Portal Listing record
                PortalListing__c newPortalListing = new PortalListing__c();
                newPortalListing.Listing_hz__c = listingId;
                newPortalListing.Portal__c = portalId;
                newPortalListing.SystemIsActive__c = true;
                newPortalListing.ListedDate__c = System.today();
                insert newPortalListing;
            }

            return 'Success';

        } catch (Exception e) {
            return e.getMessage();
        }
    }

    @AuraEnabled
    public static List<PortalWrapper> fetchPortals(String listingId){
        try {
            List<PortalWrapper> portalWrpList = new List<PortalWrapper>();

            List<Portal__c> portalList = new List<Portal__c>([SELECT Id, Name, Status__c, (SELECT Id, SystemIsActive__c FROM PortalListings__r WHERE SystemIsActive__c = true and Listing_hz__c =: listingId) FROM Portal__c WHERE isActive__c = TRUE ORDER BY CreatedDate DESC LIMIT 1000]);

            Map<String, List<PortalListing__c>> portalStatuCheck = new Map<String, List<PortalListing__c>>();

            for (Portal__c portal : portalList) {
                if (portal.PortalListings__r != null && portal.PortalListings__r.size() >0) {
                    portalStatuCheck.put(portal.Id, portal.PortalListings__r);
                } else {
                    portalStatuCheck.put(portal.Id, null);
                }
            }


            for (Portal__c portal : portalList) {
                PortalWrapper portalWrapper = new PortalWrapper();
                portalWrapper.Id = portal.Id;
                portalWrapper.name = portal.Name;
                portalWrapper.status = portalStatusCheck(portalStatuCheck.get(portal.Id));
                if (portalWrapper.status == 'active') {
                    portalWrapper.buttonColor = 'destructive';
                    portalWrapper.buttonLabel = 'Unpublish';
                    portalWrapper.badgeColor = 'slds-badge slds-theme_success';
                    portalWrapper.flag = true;
                } else {
                    portalWrapper.buttonColor = 'brand';
                    portalWrapper.buttonLabel = 'Publish';
                    portalWrapper.badgeColor = 'slds-badge';
                    portalWrapper.flag = false;

                }
                portalWrpList.add(portalWrapper);
            }

            return portalWrpList;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            return null;
        }
    }

    public static String portalStatusCheck(List<PortalListing__c> portalListings) {
        if (portalListings != null && portalListings.size() > 0) {
            return 'active';
        } else {
            return 'inactive';
        }
    }

    public class PortalWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public Boolean flag;
        @AuraEnabled public String name;
        @AuraEnabled public String status;
        @AuraEnabled public String buttonColor;
        @AuraEnabled public String buttonLabel;
        @AuraEnabled public String badgeColor;
    }
}