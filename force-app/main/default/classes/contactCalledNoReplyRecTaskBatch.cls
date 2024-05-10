global class contactCalledNoReplyRecTaskBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {    
        String query = 'SELECT Id, Stage__c, lastactivitydate FROM Contact WHERE Stage__c IN (\'Called: No Reply\') AND Owner.Name NOT IN (\'Nishchay Mehra\',\'Vansh Mehra\',\'Maverick Realty\') AND owner.isactive =True';
         return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> conList) {
        Date todayMinusThreeDays = Date.Today().addDays(-1);
        Set<Id> contactIdsWithAllTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE WhoId IN :conList
            GROUP BY WhoId]).keySet(); 
        Set<Id> contactIdsWithFutureTask = new Map<Id, AggregateResult>([
            SELECT WhoId Id FROM Task WHERE ActivityDate > :todayMinusThreeDays
            AND WhoId IN :conList
            GROUP BY WhoId]).keySet();
        
        if(!contactIdsWithFutureTask.isEmpty()){
            for(Id objId: contactIdsWithFutureTask){
                if(contactIdsWithAllTask.contains(objId))
                    contactIdsWithAllTask.remove(objId);
            }
        }
        if(!contactIdsWithAllTask.isEmpty()){
            Map<Id, Contact> contactIdMap = new Map<Id, Contact>([
                SELECT Id, OwnerId FROM Contact
                WHERE Id IN :contactIdsWithAllTask]);
            List <Task> taskList = new List<Task>();
            for(Id c : contactIdMap.keySet()) {
                Task tsk             = new Task();
                tsk.OwnerId          = contactIdMap.get(c).OwnerId;
                tsk.WhoId            = contactIdMap.get(c).Id;
                tsk.ActivityDate     = System.today();
                tsk.Status           = 'Not Started';
                tsk.Priority         = 'High';
                tsk.Subject          = 'Call the Lead';
                
                taskList.add(tsk);
            } 
            try {
                insert taskList;
            } catch (system.dmlexception e) {
                System.debug('Tasks not inserted: ' + e);
            }
        }
    }
     
    global void finish(Database.BatchableContext BC) {
        
        
        // execute any post-processing operations like sending email
    }
}