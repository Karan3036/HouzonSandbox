global class createDuplicateContactBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        // collect the batches of records or objects to be passed to execute        
        String query = 'SELECT Id, Stage__c, OwnerId FROM Contact WHERE Stage__c NOT IN (\'Contract Signed\',\'Disqualified\',\'Inactive\')';
        //String query = 'SELECT Id, Stage__c, OwnerId FROM Contact WHERE Id IN (\'0033H000005eMOzQAM\')';
        return Database.getQueryLocator(query); 
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
        
        system.debug('Query Results = ' + conList); 
        DateTime lastBatchRunDateTime = DateTime.now().addHours(-24);
        system.debug('Last Batch Run Date and Time--> '+lastBatchRunDateTime);
        
        // Create a set of Contact for which new Inquiry has been created.
        Set<Id> contactIdsWithNewInquiry = new Map<Id, AggregateResult>([
            SELECT Contact__c Id FROM Inquiry_hz__c WHERE CreatedDate > :lastBatchRunDateTime
            //SELECT Contact__c Id FROM Inquiry_hz__c
            //WHERE Contact__c IN :conList
            AND Contact__c IN :conList
            GROUP BY Contact__c]).keySet();
        
        if(!contactIdsWithNewInquiry.isEmpty()){
        
            Map<Id, Contact> contactIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId, firstname, lastname, Email, MobilePhone FROM Contact
                WHERE Id IN :contactIdsWithNewInquiry]);
            system.debug('Value in Map-->'+contactIdMap);
            system.debug('Contact to Iterate -->'+contactIdMap.keySet());
            
            List<Inquiry_hz__c> inquiriesToUpdate = new List<Inquiry_hz__c>();
            for(Id con: contactIdMap.keySet()) {
                
                system.debug('Value of Contact to iterate-->'+con);
                //List<Contact> newContactToInsert = new List<Contact>();
                for(Inquiry_hz__c inq : [Select Id, OwnerId, Contact__c, Listing__c, Listing__r.OwnerId from Inquiry_hz__c where Contact__c = :con ]) {
                    system.debug('Value of Inquiry to Iterate -->'+inq.id);
                    system.debug('Value of Listing Owner -->'+inq.Listing__r.OwnerId);
                    if(inq.Listing__r.OwnerId != contactIdMap.get(con).OwnerId){
                        system.debug('Inside IF LOOP');
                        Contact newCon = new Contact();
                        newCon.firstName = contactIdMap.get(con).firstname;
                        newCon.lastname = contactIdMap.get(con).lastname;
                        newCon.Email = contactIdMap.get(con).Email;
                        newCon.MobilePhone = contactIdMap.get(con).MobilePhone;
                        newCon.OwnerId = inq.Listing__r.OwnerId;
                        newCon.LeadSource = 'Portal';
                        
                        //newContactToInsert.add(newCon);
                        Insert newCon;
                        system.debug('New Duplicate Contact Created-->'+newCon);
                        
                        inq.Contact__c = newCon.Id;
                        inquiriesToUpdate.add(inq); 
                    }
                }    
            }
            update inquiriesToUpdate; 
        }
        
    }
     
    global void finish(Database.BatchableContext BC) {
        
        
        // execute any post-processing operations like sending email
    }
}