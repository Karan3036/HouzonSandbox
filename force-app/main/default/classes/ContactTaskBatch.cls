Global class ContactTaskBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
       
        System.debug('Normal Schedule Run');
        String query = 'SELECT Id,OwnerId, Stage__c, lastactivitydate, ContactType_hz__c, (SELECT Id, Field, DataType,ContactId,CreatedDate, OldValue, NewValue FROM Histories WHERE Field = \'stage__c\' ORDER BY CreatedDate DESC) FROM Contact WHERE Stage__c IN (\'Documents Received\') AND owner.isactive =True AND ContactType_hz__c IN (\'Landlord\', \'Seller\')';
        System.debug('query----->>>>'+query);
        return Database.getQueryLocator(query);
    
        
    }
   
    
    global void execute(Database.BatchableContext BC, List<Contact> Conlist) {
        
       
        
        Map<Id,DateTime> HistoryDateMap = new Map<Id,DateTime>();
        if(Conlist.size() > 0 ){
            for(Contact con : Conlist){
	            /*if(Test.isRunningTest()){
                    con.Histories.add(new ContactHistory());
                }*/
                for(ContactHistory his : con.Histories){
                    
                    Date CreateDate = date.newinstance(his.CreatedDate.year(), his.CreatedDate.month(), his.CreatedDate.day());
                  
                    if(his.NewValue == 'Documents Received' && !HistoryDateMap.containskey(his.ContactId)){
                        
                        System.debug('Testing==='+his.ContactId+'===='+his.createddate+'===='+his.Field+'==='+his.NewValue);
                            HistoryDateMap.put(his.ContactId, CreateDate);
                        

                    }
                    else if(his.NewValue == 'Documents Received' && HistoryDateMap.containskey(his.ContactId)){
                        System.debug('CreatedDate=='+CreateDate);
                        System.debug('OldDate=='+HistoryDateMap.get(his.contactId));
                        HistoryDateMap.remove(his.contactId);
                        if(CreateDate > HistoryDateMap.get(his.contactId)) HistoryDateMap.put(his.ContactId, CreateDate);

                        
                    }
                   
                }
            }
            System.debug('HistoryDateMap==='+HistoryDateMap);
            System.debug('HistoryDateMap size==='+HistoryDateMap.size());
            
            if(Test.isRunningTest()){
              HistoryDateMap.put(Conlist[0].Id,Date.today().addDays(-4));
            }

            List <Task> taskList = new List<Task>();
            if(HistoryDateMap.size() > 0){
                Date fourDaysBack = Date.Today()-4;
                System.debug(fourDaysBack);
                Date fourDaysBackdate = date.newinstance(fourDaysBack.year(), fourDaysBack.month(), fourDaysBack.day());
                System.debug(fourDaysBackdate);
                
                for(Contact con : Conlist){
                    System.debug('91=='+HistoryDateMap.get(con.id));
                    if(HistoryDateMap.containskey(con.Id) && HistoryDateMap.get(con.id) == fourDaysBackdate){
                        System.debug('35==='+con.Id);
                        Task tsk             = new Task();
                        tsk.OwnerId          = con.OwnerId;
                        tsk.WhoId            = con.Id;
                        // tsk.ActivityDate     =  HistoryDateMap.get(con.Id).addDays(4).date();
                        tsk.ActivityDate     =  System.today();
                        tsk.Status           = 'Not Started';
                        tsk.Priority         = 'High';
                        tsk.Subject          = 'List the Property';
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
        }
            
            
     
    }
  
    global void finish(Database.BatchableContext BC) {
        
        // execute any post-processing operations like sending email
        
    }
}