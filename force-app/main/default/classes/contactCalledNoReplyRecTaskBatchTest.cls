@isTest
private class contactCalledNoReplyRecTaskBatchTest {
    
    static Contact createContact(String fname, String lname) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.Stage__c = 'Called: No Reply';
        insert c;
        return c;
    } 
    
    static testMethod void TestContactCalledNoReplyRecTaskBatch() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

       //     // create test contacts
        Contact Contact1 = createContact('First1', 'Test1');
        Contact Contact2 = createContact('First2', 'Test2');

            List <Contact> contacts = new List <Contact>();
            List <Task> tasks = new List <Task>();
            
            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            tsk1.WhoId            = Contact1.Id;
            tsk1.ActivityDate     = System.today().addDays(-4);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Call the Lead';
            
            tasks.add(tsk1);
            
            Task tsk2             = new Task();
            tsk2.OwnerId          = u.Id;
            tsk2.WhoId            = Contact2.Id;
            tsk2.ActivityDate     = System.today();
            tsk2.Status           = 'Completed';
            tsk2.Priority         = 'High';
            tsk2.Subject          = 'Call the Lead';
            tasks.add(tsk2);
            Insert tasks;
            
            Test.StartTest();
            contactCalledNoReplyRecTaskBatch fue = new contactCalledNoReplyRecTaskBatch();
            ID batchprocessid = Database.executeBatch(fue);
            Test.StopTest();
        }
            
    }
}