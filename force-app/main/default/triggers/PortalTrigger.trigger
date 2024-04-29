trigger PortalTrigger on Portal__c (after insert, after update, after delete, after undelete, before insert,before update) {

    PortalTriggerHandler handler = new PortalTriggerHandler();
    
        if(Trigger.isAfter && Trigger.isInsert){
            handler.OnAfterInsert(Trigger.new);
        }
        
        else if(Trigger.isBefore && Trigger.isUpdate){
            handler.OnBeforeUpdate(Trigger.new);
        }
}