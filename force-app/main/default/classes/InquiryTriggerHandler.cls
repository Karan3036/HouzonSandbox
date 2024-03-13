public with sharing class InquiryTriggerHandler {
    
    List<Inquiry_hz__c> recordNewList = new List<Inquiry_hz__c>();
    List<Inquiry_hz__c> recordOldList = new List<Inquiry_hz__c>();
    Map<Id, Inquiry_hz__c> recordNewMap = new Map<Id, Inquiry_hz__c>();
    Map<Id, Inquiry_hz__c> recordOldMap = new Map<Id, Inquiry_hz__c>();
    Boolean isInsert ;
    Boolean isUpdate ;
    Boolean isDelete = false;
    Boolean isUndelete = false;
    private static final string CLASS_NAME = 'InquiryTriggerHandler';

    public InquiryTriggerHandler(List<Inquiry_hz__c> newList, List<Inquiry_hz__c> oldList, Map<Id, Inquiry_hz__c> newMap, Map<Id, Inquiry_hz__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete) {
        this.recordNewList = newList;
        this.recordOldList = oldList;
        this.recordNewMap = newMap;
        this.recordOldMap = oldMap;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
    }

    public void BeforeInsert(){
        System.debug('After Insert Event');
        handleBeforeInsert();
    }


    public void handleBeforeInsert() {
        System.debug('In the Method of logic handleBeforeInsert');
        System.debug(this.recordNewList);
    }

}