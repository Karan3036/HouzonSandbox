trigger ListingTrigger on Listing_hz__c (before insert,before update) {

    ListingTriggerHandler handler = new ListingTriggerHandler();
    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new);
    }
}