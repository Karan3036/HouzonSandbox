trigger PortalTrigger on Portal__c (before insert, before update) {

    PortalTriggerHandler handler = new PortalTriggerHandler();
    
        if(Trigger.isInsert && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }
        
        else if(Trigger.isUpdate && Trigger.isBefore){
            handler.OnBeforeInsert(Trigger.new);
        }
}