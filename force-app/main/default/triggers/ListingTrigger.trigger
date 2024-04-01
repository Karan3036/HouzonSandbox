trigger ListingTrigger on Listing_hz__c (after insert, after update, after delete, after undelete, before insert,before update) {

    ListingTriggerHandler handler = new ListingTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert,trigger.isUpdate, trigger.isDelete, trigger.isUndelete);

    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new);
    }

    if(trigger.isBefore){
        if (trigger.isInsert) {
            handler.beforeInsertEvent();
        }
        else if(trigger.isUpdate){
            handler.beforeUpdateEvent();
        }
    }
}