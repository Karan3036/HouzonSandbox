@isTest
public class contActivePropAcqDocRecTaskBatchTest {

    
    static testMethod void TestcontActivePropAcqDocRecTaskBatch() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Landlord';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Landlord';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;


        Contact Contact2 = new Contact();
        Contact2.FirstName = 'First2';
        Contact2.LastName = 'Test2';
        Contact2.ContactType_hz__c = 'Seller';
        Contact2.Stage__c = 'Active';
        Contact2.MailingStreet = 'Test';
        Contact2.MailingCity = 'Test';
        Contact2.MailingCountry = 'India';
        Contact2.LeadSource = 'Open House';
        Contact2.MobilePhone ='11122222222'; 
        insert Contact2;

        Contact Contact2Copy = new Contact();
        Contact2Copy.FirstName = 'First2';
        Contact2Copy.LastName = 'Test2';
        Contact2Copy.ContactType_hz__c = 'Seller';
        Contact2Copy.Stage__c = 'Active';
        Contact2Copy.MailingStreet = 'Test';
        Contact2Copy.MailingCity = 'Test';
        Contact2Copy.MailingCountry = 'India';
        Contact2Copy.LeadSource = 'Open House';
        Contact2Copy.MobilePhone ='11122222222'; 
        insert Contact2Copy;


        Contact Contact3 = new Contact();
        Contact3.FirstName = 'First3';
        Contact3.LastName = 'Test3';
        Contact3.ContactType_hz__c = 'Landlord;Seller';
        Contact3.Stage__c = 'Active';
        Contact3.MailingStreet = 'Test';
        Contact3.MailingCity = 'Test';
        Contact3.MailingCountry = 'India';
        Contact3.LeadSource = 'Open House';
        Contact3.MobilePhone ='11122222222'; 
        insert Contact3;

        Contact Contact3Copy = new Contact();
        Contact3Copy.FirstName = 'First3';
        Contact3Copy.LastName = 'Test3';
        Contact3Copy.ContactType_hz__c = 'Landlord;Seller';
        Contact3Copy.Stage__c = 'Active';
        Contact3Copy.MailingStreet = 'Test';
        Contact3Copy.MailingCity = 'Test';
        Contact3Copy.MailingCountry = 'India';
        Contact3Copy.LeadSource = 'Open House';
        Contact3Copy.MobilePhone ='11122222222'; 
        insert Contact3Copy;


        Contact Contact4 = new Contact();
        Contact4.FirstName = 'First3';
        Contact4.LastName = 'Test4';
        Contact4.ContactType_hz__c = 'Landlord;Developer';
        Contact4.Stage__c = 'Active';
        Contact4.MailingStreet = 'Test';
        Contact4.MailingCity = 'Test';
        Contact4.MailingCountry = 'India';
        Contact4.LeadSource = 'Open House';
        Contact4.MobilePhone ='11122222222'; 
        insert Contact4;

        Contact Contact4Copy = new Contact();
        Contact4Copy.FirstName = 'First3';
        Contact4Copy.LastName = 'Test4';
        Contact4Copy.ContactType_hz__c = 'Landlord;Developer';
        Contact4Copy.Stage__c = 'Active';
        Contact4Copy.MailingStreet = 'Test';
        Contact4Copy.MailingCity = 'Test';
        Contact4Copy.MailingCountry = 'India';
        Contact4Copy.LeadSource = 'Open House';
        Contact4Copy.MobilePhone ='11122222222'; 
        insert Contact4Copy;



        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact2.Id;
        tsk2.ActivityDate     = System.today().addDays(-30);
        tsk2.Status           = 'Completed';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        // tsk2.pba__CompletedDate__c = Date.newInstance(2021, 04,01);
        tasks.add(tsk2);

        Task tsk3           = new Task();
        tsk3.OwnerId          = u.Id;
        tsk3.WhoId            = Contact1Copy.Id;
        tsk3.ActivityDate     = System.today().addDays(-1);
        tsk3.Status           = 'Not Started';
        tsk3.Priority         = 'High';
        tsk3.Subject          = 'Check Updates';
        
        tasks.add(tsk3);

        Task tsk4             = new Task();
        tsk4.OwnerId          = u.Id;
        tsk4.WhoId            = Contact2Copy.Id;
        tsk4.ActivityDate     = System.today().addDays(-1);
        tsk4.Status           = 'Completed';
        tsk4.Priority         = 'High';
        tsk4.Subject          = 'Check Updates';
        // tsk4.pba__CompletedDate__c = Date.newInstance(2021, 04,01);
        tasks.add(tsk4);


        
        Task tsk5            = new Task();
        tsk5.OwnerId          = u.Id;
        tsk5.WhoId            = Contact3.Id;
        tsk5.ActivityDate     = System.today().addDays(-30);
        tsk5.Status           = 'Not Started';
        tsk5.Priority         = 'High';
        tsk5.Subject          = 'Check Updates';
        tasks.add(tsk5);

            
        Task tsk6            = new Task();
        tsk6.OwnerId          = u.Id;
        tsk6.WhoId            = Contact3Copy.Id;
        tsk6.ActivityDate     = System.today().addDays(-1);
        tsk6.Status           = 'Not Started';
        tsk6.Priority         = 'High';
        tsk6.Subject          = 'Check Updates';
        tasks.add(tsk6);

             
        Task tsk7            = new Task();
        tsk7.OwnerId          = u.Id;
        tsk7.WhoId            = Contact4.Id;
        tsk7.ActivityDate     = System.today().addDays(-30);
        tsk7.Status           = 'Not Started';
        tsk7.Priority         = 'High';
        tsk7.Subject          = 'Check Updates';
        tasks.add(tsk7);

        Task tsk8            = new Task();
        tsk8.OwnerId          = u.Id;
        tsk8.WhoId            = Contact4Copy.Id;
        tsk8.ActivityDate     = System.today().addDays(-1);
        tsk8.Status           = 'Not Started';
        tsk8.Priority         = 'High';
        tsk8.Subject          = 'Check Updates';
        tasks.add(tsk8);


        

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch2() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {


        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Buyer;Investor';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Buyer;Investor';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;



        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        
        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch3() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {


        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Landlord;Property Management Company';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Landlord;Property Management Company';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;
        


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch4() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {


        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Seller; Buyer;Tenant';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Seller; Buyer;Tenant';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch5() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {


    
        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Landlord; Buyer;Tenant';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Landlord; Buyer;Tenant';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;

        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }

   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch6() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Seller;Developer';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Seller;Developer';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
    }
    }
    static testMethod void TestcontActivePropAcqDocRecTaskBatch7() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {


        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Landlord';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Landlord';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
        
    
        }
   
    }

    static testMethod void TestcontActivePropAcqDocRecTaskBatch8() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

        Contact Contact1 = new Contact();
        Contact1.FirstName = 'First1';
        Contact1.LastName = 'Test1';
        Contact1.ContactType_hz__c = 'Landlord;Mortgage Broker';
        Contact1.Stage__c = 'Active';
        Contact1.MailingStreet = 'Test';
        Contact1.MailingCity = 'Test';
        Contact1.MailingCountry = 'India';
        Contact1.LeadSource = 'Open House';
        Contact1.MobilePhone ='11122222222'; 
        insert Contact1;

        Contact Contact1Copy = new Contact();
        Contact1Copy.FirstName = 'First1';
        Contact1Copy.LastName = 'Test1';
        Contact1Copy.ContactType_hz__c = 'Landlord;Mortgage Broker';
        Contact1Copy.Stage__c = 'Active';
        Contact1Copy.MailingStreet = 'Test';
        Contact1Copy.MailingCity = 'Test';
        Contact1Copy.MailingCountry = 'India';
        Contact1Copy.LeadSource = 'Open House';
        Contact1Copy.MobilePhone ='11122222222'; 
        insert Contact1Copy;


        List <Task> tasks = new List <Task>();
            
        Task tsk1             = new Task();
        tsk1.OwnerId          = u.Id;
        tsk1.WhoId            = Contact1.Id;
        tsk1.ActivityDate     = System.today().addDays(-30);
        tsk1.Status           = 'Not Started';
        tsk1.Priority         = 'High';
        tsk1.Subject          = 'Check Updates';
        
        tasks.add(tsk1);

        Task tsk2             = new Task();
        tsk2.OwnerId          = u.Id;
        tsk2.WhoId            = Contact1Copy.Id;
        tsk2.ActivityDate     = System.today().addDays(-1);
        tsk2.Status           = 'Not Started';
        tsk2.Priority         = 'High';
        tsk2.Subject          = 'Check Updates';
        
        tasks.add(tsk2);
      

        Insert tasks;
        
    
        Test.StartTest();
        // Call the Batch Apex method.
        contActivePropAcqDocRecTaskBatch fue = new contActivePropAcqDocRecTaskBatch();
        ID batchprocessid = Database.executeBatch(fue);        
        Test.StopTest();
        
        }
   
    }
    @isTest static void testMethod1(){
         
        contActivePropAcqDocRecTaskBatchSchedule contactTaskSchedule = new contActivePropAcqDocRecTaskBatchSchedule();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, contactTaskSchedule); 
    }  

    

}