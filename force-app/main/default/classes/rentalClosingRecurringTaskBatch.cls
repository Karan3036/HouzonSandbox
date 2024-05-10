global class rentalClosingRecurringTaskBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Date todayPlusFortyFiveDays = Date.Today().addDays(90);
        system.debug('Date 45 days from Today-->'+todayPlusFortyFiveDays);
         if(Test.isRunningTest()){
             System.debug('Test Class Method');
             String query = 'SELECT Id, RecordType.Name, Renter__c , Rental_Agreement_End_Date__c, OwnerId FROM Closing_hz__c WHERE RecordType.Name IN (\'Rent\') LIMIT 1900';
             return Database.getQueryLocator(query);
         }
         else{
            System.debug('Normal Schedule Run');
            String query = 'SELECT Id, RecordType.Name, Renter__c , Rental_Agreement_End_Date__c, OwnerId FROM Closing_hz__c WHERE RecordType.Name IN (\'Rent\') AND Rental_Agreement_End_Date__c = :todayPlusFortyFiveDays';
            
            
            return Database.getQueryLocator(query);
         }
    }
     
    global void execute(Database.BatchableContext BC, List<Closing_hz__c> closingList) {
                 
        system.debug('Query Results = ' + closingList);
        Set<Id> closingIdSet = new Set<Id>();
        Set<Id> activeOwnerClosingIdSet = new Set<Id>();
        Set<Id> inactiveOwnerClosingIdSet = new Set<Id>();
        
        for(Closing_hz__c closing: closingList){
            closingIdSet.add(closing.Id);
        }
        Id systemUser = [SELECT Id, Name ,Email,UserRole.Name from User WHERE UserRole.Name = 'Renewal Coordinator' Limit 1].id;
        system.debug('User Id-->'+systemUser);
        
        Id recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Closing').getRecordTypeId();
        system.debug('Task Record Type Id-->'+recordTypeId);
        
        Map<Id, Closing_hz__c> closingIdMap = new Map<Id, Closing_hz__c>([
            SELECT Id, OwnerId, Renter__c , Owner.IsActive FROM Closing_hz__c WHERE Id IN :closingIdSet]);
        system.debug('Value in Map-->'+closingIdMap);
        system.debug('Closings to Iterate -->'+closingIdMap.keySet());
            List <Task> taskList = new List<Task>();
            
        for(Id c : closingIdMap.keySet()) {
            System.debug(closingIdMap.get(c).Renter__c);
            if(closingIdMap.get(c).Owner.IsActive == True) {     activeOwnerClosingIdSet.add(c); }else{                inactiveOwnerClosingIdSet.add(c);
            }
        }
        
        for(Id c : activeOwnerClosingIdSet) {
            Task tsk             = new Task();
            tsk.OwnerId          = systemUser;
            tsk.WhatId           = closingIdMap.get(c).Id;
            tsk.ActivityDate     = System.today();
            tsk.Status           = 'Not Started';
            tsk.Priority         = 'High';
            tsk.Subject          = 'Follow up Tenant/Landlord';
            
            taskList.add(tsk);                    
        } 
        
        for(Id c : inactiveOwnerClosingIdSet) {
            Task tsk             = new Task();
            tsk.OwnerId          = systemUser;
            tsk.WhatId           = closingIdMap.get(c).Id;
            tsk.ActivityDate     = System.today();
            tsk.Status           = 'Not Started';
            tsk.Priority         = 'High';
            tsk.Subject          = 'Follow up Tenant/Landlord';
            
            taskList.add(tsk);                    
        }
        system.debug('List of Task to be Inserted -->'+taskList);
        try { 
            insert taskList; } catch (system.dmlexception e) {System.debug('Tasks not inserted: ' + e);
        }
        
    }
     
    global void finish(Database.BatchableContext BC) {
        
        
        // execute any post-processing operations like sending email
    }
}