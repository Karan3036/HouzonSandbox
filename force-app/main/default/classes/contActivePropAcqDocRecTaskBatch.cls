global class contActivePropAcqDocRecTaskBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE Stage__c IN (\'Active\', \'Property Acquired\', \'Documents Received\', \'Prospect\', \'Viewing in Progress\') AND owner.isactive =True AND ContactType_hz__c INCLUDES (\'Landlord\', \'Seller\', \'Property Management Company\', \'Developer\', \'Mortgage Broker\', \'Tenant\', \'Buyer\', \'Investor\')';
        return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
        
        Date todayMinus03Days = Date.Today().addDays(-1);
        Date todayMinus05Days = Date.Today().addDays(-3);
        Date todayMinus21Days = Date.Today().addDays(-21);
        Date todayMinus28Days = Date.Today().addDays(-28);
        
        Set<Id> contactIdSet = new Set<Id>();
        
        for(Contact cont : conList){
            contactIdSet.add(cont.Id);
        }
        
        List<Contact> onlyLandContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord') AND ContactType_hz__c EXCLUDES ('Seller','Developer','Property Management Company','Mortgage Broker','Investor','Tenant','Buyer') AND Id IN :contactIdSet]);        
        List<Contact> onlySellContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Seller') AND ContactType_hz__c EXCLUDES ('Landlord','Developer','Property Management Company','Mortgage Broker','Investor','Tenant','Buyer') AND Id IN :contactIdSet]); 
        List<Contact> landSellContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord;Seller') AND Id IN :contactIdSet]);
        List<Contact> landDevContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord;Developer') AND Id IN :contactIdSet]);
        List<Contact> landPMCContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord;Property Management Company') AND Id IN :contactIdSet]);
        
        List<Contact> landMortBrokContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord;Mortgage Broker') AND Id IN :contactIdSet]);
        List<Contact> landInvestList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord;Investor') AND Id IN :contactIdSet]);
        
        List<Contact> landTenBuyContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Landlord') AND ContactType_hz__c INCLUDES ('Tenant', 'Buyer') AND ContactType_hz__c EXCLUDES ('Seller','Developer','Property Management Company','Mortgage Broker','Investor') AND Id IN :contactIdSet]);
        
        List<Contact> sellDeveContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Seller;Developer') AND Id IN :contactIdSet]);
        
        List<Contact> sellPMCContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Seller;Property Management Company') AND Id IN :contactIdSet]);
        
        List<Contact> sellMortBrokContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Seller;Mortgage Broker') AND Id IN :contactIdSet]);
        
        List<Contact> sellInvestContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Seller;Investor') AND Id IN :contactIdSet]);
        
        List<Contact> sellTenBuyContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Seller') AND ContactType_hz__c INCLUDES ('Tenant', 'Buyer') AND ContactType_hz__c EXCLUDES ('Landlord','Developer','Property Management Company','Mortgage Broker','Investor') AND Id IN :contactIdSet]);
        
        List<Contact> onlyTenantContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Tenant') AND ContactType_hz__c EXCLUDES ('Seller','Developer','Property Management Company','Mortgage Broker','Investor','Landlord','Buyer') AND Owner.Name NOT IN ('Nishchay Mehra','Vansh Mehra','Maverick Realty') AND owner.IsActive = True AND Id IN :contactIdSet]);
        
        List<Contact> buyInvestContList = new List<Contact>([SELECT Id, Stage__c, lastactivitydate, ContactType_hz__c FROM Contact WHERE ContactType_hz__c INCLUDES ('Buyer', 'Investor') AND ContactType_hz__c EXCLUDES ('Landlord','Developer','Property Management Company','Mortgage Broker','Seller', 'Tenant') AND Owner.Name NOT IN ('Nishchay Mehra','Vansh Mehra','Maverick Realty') AND owner.IsActive = True AND Id IN :contactIdSet]);
        
        Set<Id> contIdsOnlyLandAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :onlyLandContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsOnlyLandFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :onlyLandContList AND ActivityDate > :todayMinus21Days
            GROUP BY WhoId]).keySet();
        
        
        if(!contIdsOnlyLandFutureTask.isEmpty()){
            for(Id objId: contIdsOnlyLandFutureTask){
                if(contIdsOnlyLandAllTask.contains(objId))
                    contIdsOnlyLandAllTask.remove(objId);
            }
        }
        
        Set<Id> contIdsOnlySellAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :onlySellContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsOnlySellFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :onlySellContList AND ActivityDate > :todayMinus21Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsOnlySellFutureTask.isEmpty()){
            for(Id objId: contIdsOnlySellFutureTask){
                if(contIdsOnlySellAllTask.contains(objId))
                    contIdsOnlySellAllTask.remove(objId);
            }
        }
        
        Set<Id> contIdsLandSellAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landSellContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsLandSellFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landSellContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
        
        
        if(!contIdsLandSellFutureTask.isEmpty()){
            for(Id objId: contIdsLandSellFutureTask){
                if(contIdsLandSellAllTask.contains(objId))
                    contIdsLandSellAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type both Landlord and Seller for which Recurring Task needs to be Created-->'+contIdsLandSellAllTask);
        
        
        Set<Id> contIdsLandDevAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landDevContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsLandDevFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landDevContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsLandDevFutureTask.isEmpty()){
            for(Id objId: contIdsLandDevFutureTask){
                if(contIdsLandDevAllTask.contains(objId))
                    contIdsLandDevAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type both Landlord and Developer for which Recurring Task needs to be Created-->'+contIdsLandDevAllTask);
        
        
        Set<Id> contIdsLandPMCAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landPMCContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsLandPMCFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landPMCContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
        
        
        if(!contIdsLandPMCFutureTask.isEmpty()){
            for(Id objId: contIdsLandPMCFutureTask){
                if(contIdsLandPMCAllTask.contains(objId))
                    contIdsLandPMCAllTask.remove(objId);
            }
        }
        
        // Create a set of Contact with All Tasks where Contact Type both Landlord and Mortgage Broker
        Set<Id> contIdsLandMortBrokAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landMortBrokContList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contacts with All Tasks where Contact Type both Landlord and Mortgage Broker whose Due Date is in Future
        Set<Id> contIdsLandMortBrokFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landMortBrokContList AND ActivityDate > :todayMinus21Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsLandMortBrokFutureTask.isEmpty()){
            for(Id objId: contIdsLandMortBrokFutureTask){
                if(contIdsLandMortBrokAllTask.contains(objId))
                    contIdsLandMortBrokAllTask.remove(objId);
            }
        }        
        
        // Create a set of Contact with All Tasks where Contact Type both Landlord and Investor
        Set<Id> contIdsLandInvestAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landInvestList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contacts with All Tasks where Contact Type both Landlord and Investor whose Due Date is in Future
        Set<Id> contIdsLandInvestFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landInvestList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsLandInvestFutureTask.isEmpty()){
            for(Id objId: contIdsLandInvestFutureTask){
                if(contIdsLandInvestAllTask.contains(objId))
                    contIdsLandInvestAllTask.remove(objId);
            }
        }
        
        // Create a set of Contact with All Tasks where Contact Type Landlord AND (Tenant OR Buyer)
        Set<Id> contIdsLandTenBuyAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landTenBuyContList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contacts with All Tasks where Contact Type Landlord AND (Tenant OR Buyer) whose Due Date is in Future
        Set<Id> contIdsLandTenBuyFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :landTenBuyContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsLandTenBuyFutureTask.isEmpty()){
            for(Id objId: contIdsLandTenBuyFutureTask){
                if(contIdsLandTenBuyAllTask.contains(objId))
                    contIdsLandTenBuyAllTask.remove(objId);
            }
        }
        
        
        Set<Id> contIdsSellDevAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellDeveContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsSellDevFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellDeveContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsSellDevFutureTask.isEmpty()){
            for(Id objId: contIdsSellDevFutureTask){
                if(contIdsSellDevAllTask.contains(objId))
                    contIdsSellDevAllTask.remove(objId);
            }
        }        
        
        Set<Id> contIdsSellPMCAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellPMCContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsSellPMCFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellPMCContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
        
        
        if(!contIdsSellPMCFutureTask.isEmpty()){
            for(Id objId: contIdsSellPMCFutureTask){
                if(contIdsSellPMCAllTask.contains(objId))
                    contIdsSellPMCAllTask.remove(objId);
            }
        }
        
        Set<Id> contIdsSellMortBrokAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellMortBrokContList
            GROUP BY WhoId]).keySet(); 
        
        Set<Id> contIdsSellMortBrokFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellMortBrokContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
                
        if(!contIdsSellMortBrokFutureTask.isEmpty()){
            for(Id objId: contIdsSellMortBrokFutureTask){
                if(contIdsSellMortBrokAllTask.contains(objId))
                    contIdsSellMortBrokAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type both Seller and Mortgage Broker for which Recurring Task needs to be Created-->'+contIdsSellMortBrokAllTask);
        
        
        // Create a set of Contact with All Tasks where Contact Type both Seller and Investor
        Set<Id> contIdsSellInvestAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellInvestContList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contacts with All Tasks where Contact Type both Seller and Investor whose Due Date is in Future
        Set<Id> contIdsSellInvestFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellInvestContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
        
        system.debug('Contacts with All Task where Contact Type both Seller and Investor-->'+contIdsSellInvestAllTask);
        system.debug('Contacts with Future Task where Contact Type both Seller and Investor-->'+contIdsSellInvestFutureTask);
        
        if(!contIdsSellInvestFutureTask.isEmpty()){
            for(Id objId: contIdsSellInvestFutureTask){
                if(contIdsSellInvestAllTask.contains(objId))
                    contIdsSellInvestAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type both Seller and Investor for which Recurring Task needs to be Created-->'+contIdsSellInvestAllTask);
        
        // Create a set of Contact with All Tasks where Contact Type Seller AND (Tenant OR Buyer)
        Set<Id> contIdsSellTenBuyAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellTenBuyContList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contacts with All Tasks where Contact Type Seller AND (Tenant OR Buyer) whose Due Date is in Future
        Set<Id> contIdsSellTenBuyFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :sellTenBuyContList AND ActivityDate > :todayMinus28Days
            GROUP BY WhoId]).keySet();
        
        system.debug('Contacts with All Task where Contact Type Seller AND (Tenant OR Buyer)r-->'+contIdsSellTenBuyAllTask);
        system.debug('Contacts with Future Task where Contact Type Seller AND (Tenant OR Buyer)r-->'+contIdsSellTenBuyFutureTask);
        
        if(!contIdsSellTenBuyFutureTask.isEmpty()){
            for(Id objId: contIdsSellTenBuyFutureTask){
                if(contIdsSellTenBuyAllTask.contains(objId))
                    contIdsSellTenBuyAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type Seller AND (Tenant OR Buyer) for which Recurring Task needs to be Created-->'+contIdsSellTenBuyAllTask);
        
        // Create a set of Contact with All Tasks where Contact Type is Tenant
        Set<Id> contIdsTenantAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :onlyTenantContList
            GROUP BY WhoId]).keySet(); 
        
        // Map<Id, AggregateResult> tenantFutureTask = new Map<Id, AggregateResult>(
        //     [SELECT WhoId Id, ActivityDate FROM Task WHERE WhoId IN :onlyTenantContList AND ActivityDate > :todayMinus03Days
        //     GROUP BY WhoId]);

        // System.debug('tenantFutureTask=='+tenantFutureTask);
        
        // Create a set of Contacts with All Tasks where Contact Type is Tenant whose Due Date is in Future
        Set<Id> contIdsTenantFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :onlyTenantContList AND ActivityDate > :todayMinus03Days
            GROUP BY WhoId]).keySet();
        
        
        system.debug('Contacts with All Task where Contact Type is Tenant -->'+contIdsTenantAllTask);
        system.debug('Contacts with Future Task where Contact Type is Tenant -->'+contIdsTenantFutureTask);
        
        if(!contIdsTenantFutureTask.isEmpty()){
            for(Id objId: contIdsTenantFutureTask){
                if(contIdsTenantAllTask.contains(objId))
                    contIdsTenantAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type Tenant for which Recurring Task needs to be Created-->'+contIdsTenantAllTask);


        
        Map<Id,Date> TenantTaskDateMap = new Map<Id,Date>();
        List<Contact> conList1 = [SELECT Id, (SELECT ActivityDate FROM Tasks WHERE ActivityDate < :todayMinus03Days ORDER BY ActivityDate DESC LIMIT 1) FROM COntact WHERE Id IN : contIdsTenantAllTask];
        for(Contact con : conList1){
            if(con.tasks.size() != 0){
                for(Task tsk : con.tasks)
                TenantTaskDateMap.put(con.Id, tsk.ActivityDate);
            }
        }

        System.debug('TenantTaskDateMap=='+TenantTaskDateMap);
        
        // Create a set of Contact with All Tasks where Contact Type is Buyer OR Investor
        Set<Id> contIdsBuyInvestAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :buyInvestContList
            GROUP BY WhoId]).keySet(); 
        
        // Create a set of Contacts with All Tasks where Contact Type is Buyer OR Investor whose Due Date is in Future
        Set<Id> contIdsBuyInvestFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :buyInvestContList AND ActivityDate > :todayMinus05Days
            GROUP BY WhoId]).keySet();
        
        system.debug('Contacts with All Task where Contact Type is Buyer OR Investor -->'+contIdsBuyInvestAllTask);
        system.debug('Contacts with Future Task where Contact Type is Buyer OR Investor -->'+contIdsBuyInvestFutureTask);
        
        if(!contIdsBuyInvestFutureTask.isEmpty()){
            for(Id objId: contIdsBuyInvestFutureTask){
                if(contIdsBuyInvestAllTask.contains(objId))
                    contIdsBuyInvestAllTask.remove(objId);
            }
        }
        system.debug('Contacts where Contact Type Buyer OR Investor for which Recurring Task needs to be Created-->'+contIdsBuyInvestAllTask);
        
        Map<Id,Date> BuyInvestaskDateMap = new Map<Id,Date>();
        List<Contact> conList2 = [SELECT Id, (SELECT ActivityDate FROM Tasks WHERE ActivityDate < :todayMinus03Days ORDER BY ActivityDate DESC LIMIT 1) FROM COntact WHERE Id IN : contIdsBuyInvestAllTask];
        for(Contact con : conList2){
            if(con.tasks.size() != 0){
                for(Task tsk : con.tasks)
                BuyInvestaskDateMap.put(con.Id, tsk.ActivityDate);
            }
        }

        System.debug('BuyInvestaskDateMap=='+BuyInvestaskDateMap);
      
        

        List <Task> taskList = new List<Task>();
        
        //Create Task for Contact where Contact Type is only Landlord
        // debug 29
        System.debug(contIdsOnlyLandAllTask );
        if(!contIdsOnlyLandAllTask.isEmpty()){
            Map<Id, Contact> contIdsOnlyLandIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsOnlyLandAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is only Landlord-->'+contIdsOnlyLandIdMap);
            system.debug('Contacts to Iterate where Contact Type is only Landlord-->'+contIdsOnlyLandIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsOnlyLandIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsOnlyLandIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsOnlyLandIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is only Seller
        if(!contIdsOnlySellAllTask.isEmpty()){
            Map<Id, Contact> contIdsOnlySellIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsOnlySellAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is only Seller-->'+contIdsOnlySellIdMap);
            system.debug('Contacts to Iterate where Contact Type is only Seller-->'+contIdsOnlySellIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsOnlySellIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsOnlySellIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsOnlySellIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both Landlord and Seller
        if(!contIdsLandSellAllTask.isEmpty()){
            Map<Id, Contact> contIdsLandSellIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsLandSellAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both Landlord and Seller-->'+contIdsLandSellIdMap);
            system.debug('Contacts to Iterate where Contact Type is both Landlord and Seller-->'+contIdsLandSellIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsLandSellIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsLandSellIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsLandSellIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both Landlord and Developer
        if(!contIdsLandDevAllTask.isEmpty()){
            Map<Id, Contact> contIdsLandDevIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsLandDevAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both Landlord and Developer-->'+contIdsLandDevIdMap);
            system.debug('Contacts to Iterate where Contact Type is both Landlord and Developer-->'+contIdsLandDevIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsLandDevIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsLandDevIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsLandDevIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both Landlord and Property Management Company
        if(!contIdsLandPMCAllTask.isEmpty()){
            Map<Id, Contact> contIdsLandPMCIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsLandPMCAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both Landlord and Property Management Company-->'+contIdsLandPMCIdMap);
            system.debug('Contacts to Iterate where Contact Type is both Landlord and Property Management Company-->'+contIdsLandPMCIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsLandPMCIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsLandPMCIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsLandPMCIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both Landlord and Mortgage Broker
        if(!contIdsLandMortBrokAllTask.isEmpty()){
            Map<Id, Contact> contIdsLandMortBrokIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsLandMortBrokAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both Landlord and Mortgage Broker-->'+contIdsLandMortBrokIdMap);
            system.debug('Contacts to Iterate where Contact Type is both Landlord and Mortgage Broker-->'+contIdsLandMortBrokIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsLandMortBrokIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsLandMortBrokIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsLandMortBrokIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both Landlord and Investor
        if(!contIdsLandInvestAllTask.isEmpty()){
            Map<Id, Contact> contIdsLandInvestIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsLandInvestAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both Landlord and Investor-->'+contIdsLandInvestIdMap);
            system.debug('Contacts to Iterate where Contact Type is both Landlord and Investor-->'+contIdsLandInvestIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsLandInvestIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsLandInvestIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsLandInvestIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is Landlord AND (Tenant OR Buyer)
        if(!contIdsLandTenBuyAllTask.isEmpty()){
            Map<Id, Contact> contIdsLandTenBuyIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsLandTenBuyAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is Landlord AND (Tenant OR Buyer)-->'+contIdsLandTenBuyIdMap);
            system.debug('Contacts to Iterate where Contact Type is Landlord AND (Tenant OR Buyer)-->'+contIdsLandTenBuyIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsLandTenBuyIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsLandTenBuyIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsLandTenBuyIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        
        //Create Task for Contact where Contact Type is both  Seller and Developer
        if(!contIdsSellDevAllTask.isEmpty()){
            Map<Id, Contact> contIdsSellDevIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsSellDevAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both  Seller and Developer-->'+contIdsSellDevIdMap);
            system.debug('Contacts to Iterate where Contact Type is both  Seller and Developer-->'+contIdsSellDevIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsSellDevIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsSellDevIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsSellDevIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both  Seller and Property Management Company
        if(!contIdsSellPMCAllTask.isEmpty()){
            Map<Id, Contact> contIdsSellPMCIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsSellPMCAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both  Seller and Property Management Company-->'+contIdsSellPMCIdMap);
            system.debug('Contacts to Iterate where Contact Type is both  Seller and Property Management Company-->'+contIdsSellPMCIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsSellPMCIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsSellPMCIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsSellPMCIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both  Seller and Mortgage Broker
        if(!contIdsSellMortBrokAllTask.isEmpty()){
            Map<Id, Contact> contIdsSellMortBrokIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsSellMortBrokAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both  Seller and Mortgage Broker-->'+contIdsSellMortBrokIdMap);
            system.debug('Contacts to Iterate where Contact Type is both  Seller and Mortgage Broker-->'+contIdsSellMortBrokIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsSellMortBrokIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsSellMortBrokIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsSellMortBrokIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is both  Seller and Investor
        if(!contIdsSellInvestAllTask.isEmpty()){
            Map<Id, Contact> contIdsSellInvestIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsSellInvestAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is both  Seller and Investor-->'+contIdsSellInvestIdMap);
            system.debug('Contacts to Iterate where Contact Type is both  Seller and Investor-->'+contIdsSellInvestIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsSellInvestIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsSellInvestIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsSellInvestIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is Seller AND (Tenant OR Buyer)
        if(!contIdsSellTenBuyAllTask.isEmpty()){
            Map<Id, Contact> contIdsSellTenBuyIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsSellTenBuyAllTask]);
            system.debug('Value in Map of Contacts where Contact Type is Seller AND (Tenant OR Buyer)-->'+contIdsSellTenBuyIdMap);
            system.debug('Contacts to Iterate where Contact Type is Seller AND (Tenant OR Buyer)-->'+contIdsSellTenBuyIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsSellTenBuyIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contIdsSellTenBuyIdMap.get(c).OwnerId;
                tsk.WhoId            = contIdsSellTenBuyIdMap.get(c).Id;
                tsk.ActivityDate     = System.today().addDays(2);
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Check Updates';
                
                taskList.add(tsk);
            } 
        }
        
        //Create Task for Contact where Contact Type is Tenant
        if(!contIdsTenantAllTask .isEmpty()){
            Map<Id, Contact> contIdsTenantIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsTenantAllTask ]);
            system.debug('Value in Map of Contacts where Contact Type is Tenant -->'+contIdsTenantIdMap);
            system.debug('Contacts to Iterate where Contact Type is Tenant -->'+contIdsTenantIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsTenantIdMap.keySet()) {
                if(!(System.today() < TenantTaskDateMap.get(c)) && TenantTaskDateMap.get(c) != null){
                
                    Task tsk             = new Task();
                    tsk.OwnerId          = contIdsTenantIdMap.get(c).OwnerId;
                    tsk.WhoId            = contIdsTenantIdMap.get(c).Id;
                    // tsk.ActivityDate     = System.today().addDays(2);
                    tsk.ActivityDate     =  System.today() < TenantTaskDateMap.get(c).addDays(3) ? TenantTaskDateMap.get(c).addDays(3) : System.today().addDays(2);
                    tsk.Status           = 'Not Started';
                    
                    
                    tsk.Priority         = 'High';
                    tsk.Subject          = 'Check Updates';
                    
                    taskList.add(tsk);
                }
            } 
        }
        
        //Create Task for Contact where Contact Type is Buyer OR Investor
        if(!contIdsBuyInvestAllTask  .isEmpty()){
            Map<Id, Contact> contIdsBuyInvestIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contIdsBuyInvestAllTask  ]);
            system.debug('Value in Map of Contacts where Contact Type is Buyer OR Investor -->'+contIdsBuyInvestIdMap);
            system.debug('Contacts to Iterate where Contact Type is Buyer OR Investor -->'+contIdsBuyInvestIdMap.keySet());
            
            
            // Iterate through the whole query of Contact
            // Create a Task that's associated with each Contact.
            for(Id c : contIdsBuyInvestIdMap.keySet()) {
                if(!(System.today() < BuyInvestaskDateMap.get(c)) && BuyInvestaskDateMap.get(c) != null){
                    Task tsk             = new Task();
                    tsk.OwnerId          = contIdsBuyInvestIdMap.get(c).OwnerId;
                    tsk.WhoId            = contIdsBuyInvestIdMap.get(c).Id;
                    // tsk.ActivityDate     = System.today().addDays(2);
                    tsk.ActivityDate     = System.today() < BuyInvestaskDateMap.get(c).addDays(5) ? BuyInvestaskDateMap.get(c).addDays(5) : System.today().addDays(2);
                    tsk.Status           = 'Not Started';
                    tsk.Priority         = 'High';
                    tsk.Subject          = 'Check Updates';
                    
                    taskList.add(tsk);
                }
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