trigger InquiryTrigger on Inquiry_hz__c(after insert, after update, after delete, after undelete, before insert,before update) {
    InquiryTriggerHandler handler = new InquiryTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert,trigger.isUpdate, trigger.isDelete, trigger.isUndelete);

    if(trigger.isBefore){
        if (trigger.isInsert) {
            handler.BeforeInsert();
        }
    }
}