public class PermitNumberController {
    public static void reraPermitCheck(List<Listing_hz__c> newListings) {
        Map<String, Id> reraPermitNumbers = activeRecords();

        for (Listing_hz__c updatedListing : newListings) {
            if (activeRecsWithReraNumber(updatedListing)) {
                handleDupilcate(updatedListing, reraPermitNumbers);
            }
        }
    }

    public static Map<String, Id> activeRecords() {
        Map<String, Id> reraPermitNumbers = new Map<String, Id>();
        for (Listing_hz__c existingListing : [SELECT Id, RERA_Permit_Number__c FROM Listing_hz__c WHERE Status__c = 'Active']) {
            reraPermitNumbers.put(existingListing.RERA_Permit_Number__c, existingListing.Id);
        }
        return reraPermitNumbers;
    }

    public static Boolean activeRecsWithReraNumber(Listing_hz__c listing) {
        return listing.Status__c == 'Active' && !String.isBlank(listing.RERA_Permit_Number__c);
    }

    public static void handleDupilcate(Listing_hz__c listing, Map<String, Id> reraPermitNumbers) {
        if (reraPermitNumbers.containsKey(listing.RERA_Permit_Number__c) &&
            reraPermitNumbers.get(listing.RERA_Permit_Number__c) != listing.Id) {
            listing.addError('RERA Permit Number already exists on another active listing.');
        }
    }
}