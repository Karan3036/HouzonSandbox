trigger PermitNumberCheck on Listing_hz__c (before update) {
    PermitNumberController.reraPermitCheck(Trigger.new);
}