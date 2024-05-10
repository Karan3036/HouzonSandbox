global class listingRecurringTasksBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        if(Test.isRunningTest()){
            System.debug('Test Class Method');
            
            String query = 'SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE PropertyOwnerContact__c <> null AND Status__c IN (\'Active\', \'Pending\') AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES  (\'Seller\', \'Landlord\', \'Developer\', \'Property Management Company\') LIMIT 1900';
            return Database.getQueryLocator(query);
        }else{ 
            System.debug('Normal Schedule Run'); 
            
            String query = 'SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE PropertyOwnerContact__c <> null AND Status__c IN (\'Active\', \'Pending\') AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES  (\'Seller\', \'Landlord\', \'Developer\', \'Property Management Company\')';
            return Database.getQueryLocator(query);
        }
    }
     
    global void execute(Database.BatchableContext BC, List<Listing_hz__c> listingList) {
                 
        Date todayMinusThirtyDays = Date.Today().addDays(-30);
        Date todayMinusTwentyOneDays = Date.Today().addDays(-21);
        Date todayMinusTwentyEightDays = Date.Today().addDays(-28);
        Date todayMinusFortyFiveDays = Date.Today().addDays(-45);
        
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> listingIdSet = new Set<Id>();
    
        for(Listing_hz__c listing : listingList){
            if (listing.PropertyOwnerContact__c != null) {
                contactIdSet.add(listing.PropertyOwnerContact__c);
            }
            listingIdSet.add(listing.Id);
        }
        System.debug('Value in Contact Set--->'+contactIdSet);
        System.debug('Value in Listing Set--->'+listingIdSet);
        
        //Below is the Original query.
        List<Listing_hz__c> landPMCListingList = new List<Listing_hz__c>([SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE ListingType__c = 'Rent' AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES ('Landlord;Property Management Company') AND Id IN :listingIdSet]);
        
        List<Listing_hz__c> onlyLandlordListingList = new List<Listing_hz__c>([SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE ListingType__c = 'Rent' AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES ('Landlord') AND PropertyOwnerContact__r.ContactType_hz__c EXCLUDES ('Property Management Company') AND Id IN :listingIdSet]);
        
        List<Listing_hz__c> onlyPMCListingList = new List<Listing_hz__c>([SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE ListingType__c = 'Rent' AND PropertyOwnerContact__r.ContactType_hz__c EXCLUDES ('Landlord') AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES ('Property Management Company') AND Id IN :listingIdSet]);
        
        List<Listing_hz__c> sellerDevListingList = new List<Listing_hz__c>([SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE ListingType__c = 'Sale' AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES ('Seller;Developer') AND Id IN :listingIdSet]);
        
        List<Listing_hz__c> onlySellerListingList = new List<Listing_hz__c>([SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE ListingType__c = 'Sale' AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES ('Seller') AND PropertyOwnerContact__r.ContactType_hz__c EXCLUDES ('Developer') AND Id IN :listingIdSet]);
        
        List<Listing_hz__c> onlyDeveloperListingList = new List<Listing_hz__c>([SELECT Id, ListingType__c, Status__c, PropertyOwnerContact__r.ContactType_hz__c FROM Listing_hz__c WHERE ListingType__c = 'Sale' AND PropertyOwnerContact__r.ContactType_hz__c EXCLUDES ('Seller') AND PropertyOwnerContact__r.ContactType_hz__c INCLUDES ('Developer') AND Id IN :listingIdSet]);
        
        Set<Id> listingIdsLandPMCAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :landPMCListingList
            GROUP BY WhatId]).keySet(); 
        
        Set<Id> listingIdsLandPMCFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :landPMCListingList AND ActivityDate > :todayMinusTwentyEightDays
            GROUP BY WhatId]).keySet();
   
        System.debug('listingIdsLandPMCFutureTask::'+listingIdsLandPMCFutureTask);
        if(!listingIdsLandPMCFutureTask.isEmpty()){
            for(Id objId: listingIdsLandPMCFutureTask){
                if(listingIdsLandPMCAllTask.contains(objId))
                    listingIdsLandPMCAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type both Landlord and PMC for which Recurring Task needs to be Created-->'+listingIdsLandPMCAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Landlord
        Set<Id> listingIdsLandlordAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyLandlordListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Landlord whose Due Date is in Future
        Set<Id> listingIdsLandlordFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyLandlordListingList AND ActivityDate > :todayMinusTwentyOneDays
            GROUP BY WhatId]).keySet();
        
        
        if(!listingIdsLandlordFutureTask.isEmpty()){
            for(Id objId: listingIdsLandlordFutureTask){
                if(listingIdsLandlordAllTask.contains(objId))
                    listingIdsLandlordAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only Landlord for which Recurring Task needs to be Created-->'+listingIdsLandlordAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only PMC       
        Set<Id> listingIdsPMCAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyPMCListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only PMC whose Due Date is in Future
        Set<Id> listingIdsPMCFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyPMCListingList AND ActivityDate > :todayMinusTwentyEightDays
            GROUP BY WhatId]).keySet();
        
        if(!listingIdsPMCFutureTask.isEmpty()){
            for(Id objId: listingIdsPMCFutureTask){
                if(listingIdsPMCAllTask.contains(objId))
                    listingIdsPMCAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only PMC for which Recurring Task needs to be Created-->'+listingIdsPMCAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type both Seller and Developer
        Set<Id> listingIdsSellDevAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :sellerDevListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type both Seller and Developer whose Due Date is in Future
        Set<Id> listingIdsSellDevFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :sellerDevListingList AND ActivityDate > :todayMinusFortyFiveDays
            GROUP BY WhatId]).keySet();
        
        
        if(!listingIdsSellDevFutureTask.isEmpty()){
            for(Id objId: listingIdsSellDevFutureTask){
                if(listingIdsSellDevAllTask.contains(objId))
                    listingIdsSellDevAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type both Seller and Developer for which Recurring Task needs to be Created-->'+listingIdsSellDevAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Seller
        Set<Id> listingIdsSellerAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlySellerListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Seller whose Due Date is in Future
        Set<Id> listingIdsSellerFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlySellerListingList AND ActivityDate > :todayMinusThirtyDays
            GROUP BY WhatId]).keySet();
        

        if(!listingIdsSellerFutureTask.isEmpty()){
            for(Id objId: listingIdsSellerFutureTask){
                if(listingIdsSellerAllTask.contains(objId))
                    listingIdsSellerAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only Seller for which Recurring Task needs to be Created-->'+listingIdsSellerAllTask);
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Developer
        Set<Id> listingIdsDeveloperAllTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyDeveloperListingList
            GROUP BY WhatId]).keySet(); 
        
        // Create a set of Listing with All Tasks where Property Owner Contact Type is only Developer whose Due Date is in Future
        Set<Id> listingIdsDeveloperFutureTask = new Map<Id, AggregateResult>([
            SELECT WhatId Id FROM Task WHERE WhatId IN :onlyDeveloperListingList AND ActivityDate > :todayMinusFortyFiveDays
            GROUP BY WhatId]).keySet();
        
        if(!listingIdsDeveloperFutureTask.isEmpty()){
            for(Id objId: listingIdsDeveloperFutureTask){
                if(listingIdsDeveloperAllTask.contains(objId))
                    listingIdsDeveloperAllTask.remove(objId);
            }
        }
        system.debug('Listings where Property Owner Contact Type is only Developer for which Recurring Task needs to be Created-->'+listingIdsDeveloperAllTask);
        
        List <Task> taskList = new List<Task>();
        
        //Create Task for Listings where Property Owner Contact Type is both Landlord and PMC
        if(!listingIdsLandPMCAllTask.isEmpty()){
            Map<Id, Listing_hz__c> listingIdsLandPMCIdMap = new Map<Id, Listing_hz__c>([
                SELECT Id, OwnerId FROM Listing_hz__c
                WHERE Id IN :listingIdsLandPMCAllTask]);
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsLandPMCIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsLandPMCIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsLandPMCIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsLandPMCIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is Only Landlord
        if(!listingIdsLandlordAllTask.isEmpty()){
            Map<Id, Listing_hz__c> listingIdsOnlyLandIdMap = new Map<Id, Listing_hz__c>([
                SELECT Id, OwnerId FROM Listing_hz__c
                WHERE Id IN :listingIdsLandlordAllTask]);
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsOnlyLandIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsOnlyLandIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsOnlyLandIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsOnlyLandIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is only PMC
        if(!listingIdsPMCAllTask.isEmpty()){
            Map<Id, Listing_hz__c> listingIdsOnlyPMCIdMap = new Map<Id, Listing_hz__c>([
                SELECT Id, OwnerId FROM Listing_hz__c
                WHERE Id IN :listingIdsPMCAllTask]);
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsOnlyPMCIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsOnlyPMCIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsOnlyPMCIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsOnlyPMCIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is both Seller and Developer
        if(!listingIdsSellDevAllTask.isEmpty()){
            Map<Id, Listing_hz__c> listingIdsSellDevIdMap = new Map<Id, Listing_hz__c>([
                SELECT Id, OwnerId FROM Listing_hz__c
                WHERE Id IN :listingIdsSellDevAllTask]);
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsSellDevIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsSellDevIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsSellDevIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsSellDevIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is only Seller
        if(!listingIdsSellerAllTask.isEmpty()){
            Map<Id, Listing_hz__c> listingIdsSellerOnlyIdMap = new Map<Id, Listing_hz__c>([
                SELECT Id, OwnerId FROM Listing_hz__c
                WHERE Id IN :listingIdsSellerAllTask]);
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsSellerOnlyIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsSellerOnlyIdMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsSellerOnlyIdMap.get(c).Id;
                tsk.Listing__c       = listingIdsSellerOnlyIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Listings where Property Owner Contact Type is Developer
        if(!listingIdsDeveloperAllTask.isEmpty()){
            Map<Id, Listing_hz__c> listingIdsDevOnlyMap = new Map<Id, Listing_hz__c>([
                SELECT Id, OwnerId FROM Listing_hz__c
                WHERE Id IN :listingIdsDeveloperAllTask]);
            
            
            // Iterate through the whole query of Listings
            // Create a Task that's associated with each Listing.
            for(Id c : listingIdsDevOnlyMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = listingIdsDevOnlyMap.get(c).OwnerId;
                tsk.WhatId           = listingIdsDevOnlyMap.get(c).Id;
                tsk.Listing__c       = listingIdsDevOnlyMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Is_the_Property_still_with_Landlord__c = 'Available';
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
            
        system.debug('List of Task to be Inserted -->'+taskList);
        try {
            insert taskList;
        } catch (system.dmlexception e) {
            System.debug('Tasks not inserted: ' + e);
        }   
    }
     
    global void finish(Database.BatchableContext BC) {
                
        // execute any post-processing operations like sending email
    }
}