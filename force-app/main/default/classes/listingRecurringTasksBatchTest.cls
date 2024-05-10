@isTest(SeeAllData=false)
public class listingRecurringTasksBatchTest {

    
    static testMethod void TestlistingRecurringTasksBatch() {
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
            

            Property_hz__c pro=new Property_hz__c();
            pro.name ='test';
            pro.Address_hz__c ='Test';
            pro.Area_hz__c ='Test';
            insert pro;

            Listing_hz__c listingRecord1 = new Listing_hz__c();
            listingRecord1.Name = 'Test1';
            listingRecord1.Status__c = 'Active';
            listingRecord1.ListingType__c = 'Rent';
            listingRecord1.PropertyType__c = 'Apartment';
            listingRecord1.Bedrooms_hz__c = 2;
            listingRecord1.FullBathrooms_hz__c = 2;
            listingRecord1.ListingPrice_hz__c = 1000;
            listingRecord1.City_hz__c = 'Test';
            listingRecord1.State_hz__c = 'Test';
            listingRecord1.Broker_s_Listing_ID__c='Test';
            listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
            listingRecord1.Description_hz__c='Testing Area';
            listingRecord1.PropertySubType_hz__c='Industrial';
            listingRecord1.Property_Sub_Type__c='Residential - Apartment';
            listingRecord1.RERA_Permit_Number__c='100';
            listingRecord1.TotalArea_hz__c=1000;
            listingRecord1.Sub_Community_Propertyfinder__c='Test';
            listingRecord1.Community_Propertyfinder__c='Test';
            listingRecord1.Property_Propertyfinder__c='Test';
            listingRecord1.LocationText_Dubizzle__c='Test';
            listingRecord1.City_Propertyfinder__c='test';
            listingRecord1.Price_Unit__c='Price Yearly';
            listingRecord1.Completion_Status__c='Completed';
            listingRecord1.City_Dubizzle__c='Test';
            listingRecord1.Property_Status__c='Vacant on Transfer';
            listingRecord1.Available_from__c=date.today()+1;
            listingRecord1.CompletionDate_hz__c=date.today()+1;
            listingRecord1.PropertyOwnerContact__c=Contact1.Id;
            listingRecord1.Property_hz__c=pro.Id;
            listingRecord1.property_category__c='Commercial';
            insert listingRecord1;


            
            // SELECT WhoId Id FROM Task
            List <Task> tasks = new List <Task>();

            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            tsk1.WhoId            = Contact1.Id;
            tsk1.WhatId           = listingRecord1.Id;
            tsk1.ActivityDate     = System.today().addDays(-30);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Check Updates';
            
            tasks.add(tsk1);

            
            Insert tasks;
            
            
            Test.StartTest();
            // Call the Batch Apex method.
            listingRecurringTasksBatch fue = new listingRecurringTasksBatch();
            ID batchprocessid = Database.executeBatch(fue);        
            Test.StopTest();    
        }
    }
    static testMethod void TestlistingRecurringTasksBatch1() {
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
            

            Property_hz__c pro=new Property_hz__c();
            pro.name ='test';
            pro.Address_hz__c ='Test';
            pro.Area_hz__c ='Test';
            insert pro;

            Listing_hz__c listingRecord1 = new Listing_hz__c();
            listingRecord1.Name = 'Test1';
            listingRecord1.Status__c = 'Active';
            listingRecord1.ListingType__c = 'Rent';
            listingRecord1.PropertyType__c = 'Apartment';
            listingRecord1.Bedrooms_hz__c = 2;
            listingRecord1.FullBathrooms_hz__c = 2;
            listingRecord1.ListingPrice_hz__c = 1000;
            listingRecord1.City_hz__c = 'Test';
            listingRecord1.State_hz__c = 'Test';
            listingRecord1.Broker_s_Listing_ID__c='Test';
            listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
            listingRecord1.Description_hz__c='Testing Area';
            listingRecord1.PropertySubType_hz__c='Industrial';
            listingRecord1.Property_Sub_Type__c='Residential - Apartment';
            listingRecord1.RERA_Permit_Number__c='100';
            listingRecord1.TotalArea_hz__c=1000;
            listingRecord1.Sub_Community_Propertyfinder__c='Test';
            listingRecord1.Community_Propertyfinder__c='Test';
            listingRecord1.Property_Propertyfinder__c='Test';
            listingRecord1.LocationText_Dubizzle__c='Test';
            listingRecord1.City_Propertyfinder__c='test';
            listingRecord1.Price_Unit__c='Price Yearly';
            listingRecord1.Completion_Status__c='Completed';
            listingRecord1.City_Dubizzle__c='Test';
            listingRecord1.Property_Status__c='Vacant on Transfer';
            listingRecord1.Available_from__c=date.today()+1;
            listingRecord1.CompletionDate_hz__c=date.today()+1;
            listingRecord1.PropertyOwnerContact__c=Contact1.Id;
            listingRecord1.Property_hz__c=pro.Id;
            listingRecord1.property_category__c='Commercial';
            insert listingRecord1;


            
            // SELECT WhoId Id FROM Task
            List <Task> tasks = new List <Task>();

            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            tsk1.WhoId            = Contact1.Id;
            tsk1.WhatId           = listingRecord1.Id;
            tsk1.ActivityDate     = System.today().addDays(-21);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Check Updates';
            
            tasks.add(tsk1);

            
            Insert tasks;
            
            
            Test.StartTest();
            // Call the Batch Apex method.
            listingRecurringTasksBatch fue = new listingRecurringTasksBatch();
            ID batchprocessid = Database.executeBatch(fue);        
            Test.StopTest();    
        }
    }
    static testMethod void TestlistingRecurringTasksBatch2() {
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
            Contact1.ContactType_hz__c = 'Property Management Company';
            Contact1.Stage__c = 'Active';
            Contact1.MailingStreet = 'Test';
            Contact1.MailingCity = 'Test';
            Contact1.MailingCountry = 'India';
            Contact1.LeadSource = 'Open House';
            Contact1.MobilePhone ='11122222222'; 
            insert Contact1;
            

            Property_hz__c pro=new Property_hz__c();
            pro.name ='test';
            pro.Address_hz__c ='Test';
            pro.Area_hz__c ='Test';
            insert pro;

            Listing_hz__c listingRecord1 = new Listing_hz__c();
            listingRecord1.Name = 'Test1';
            listingRecord1.Status__c = 'Active';
            listingRecord1.ListingType__c = 'Rent';
            listingRecord1.PropertyType__c = 'Apartment';
            listingRecord1.Bedrooms_hz__c = 2;
            listingRecord1.FullBathrooms_hz__c = 2;
            listingRecord1.ListingPrice_hz__c = 1000;
            listingRecord1.City_hz__c = 'Test';
            listingRecord1.State_hz__c = 'Test';
            listingRecord1.Broker_s_Listing_ID__c='Test';
            listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
            listingRecord1.Description_hz__c='Testing Area';
            listingRecord1.PropertySubType_hz__c='Industrial';
            listingRecord1.Property_Sub_Type__c='Residential - Apartment';
            listingRecord1.RERA_Permit_Number__c='100';
            listingRecord1.TotalArea_hz__c=1000;
            listingRecord1.Sub_Community_Propertyfinder__c='Test';
            listingRecord1.Community_Propertyfinder__c='Test';
            listingRecord1.Property_Propertyfinder__c='Test';
            listingRecord1.LocationText_Dubizzle__c='Test';
            listingRecord1.City_Propertyfinder__c='test';
            listingRecord1.Price_Unit__c='Price Yearly';
            listingRecord1.Completion_Status__c='Completed';
            listingRecord1.City_Dubizzle__c='Test';
            listingRecord1.Property_Status__c='Vacant on Transfer';
            listingRecord1.Available_from__c=date.today()+1;
            listingRecord1.CompletionDate_hz__c=date.today()+1;
            listingRecord1.PropertyOwnerContact__c=Contact1.Id;
            listingRecord1.Property_hz__c=pro.Id;
            listingRecord1.property_category__c='Commercial';
            insert listingRecord1;


            
            // SELECT WhoId Id FROM Task
            List <Task> tasks = new List <Task>();

            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            tsk1.WhoId            = Contact1.Id;
            tsk1.WhatId           = listingRecord1.Id;
            tsk1.ActivityDate     = System.today().addDays(-28);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Check Updates';
            
            tasks.add(tsk1);

            
            Insert tasks;
            
            
            Test.StartTest();
            // Call the Batch Apex method.
            listingRecurringTasksBatch fue = new listingRecurringTasksBatch();
            ID batchprocessid = Database.executeBatch(fue);        
            Test.StopTest();    
        }
    }
    static testMethod void TestlistingRecurringTasksBatch3() {
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
            

            Property_hz__c pro=new Property_hz__c();
            pro.name ='test';
            pro.Address_hz__c ='Test';
            pro.Area_hz__c ='Test';
            insert pro;

            Listing_hz__c listingRecord1 = new Listing_hz__c();
            listingRecord1.Name = 'Test1';
            listingRecord1.Status__c = 'Active';
            listingRecord1.ListingType__c = 'Sale';
            listingRecord1.PropertyType__c = 'Apartment';
            listingRecord1.Bedrooms_hz__c = 2;
            listingRecord1.FullBathrooms_hz__c = 2;
            listingRecord1.ListingPrice_hz__c = 1000;
            listingRecord1.City_hz__c = 'Test';
            listingRecord1.State_hz__c = 'Test';
            listingRecord1.Broker_s_Listing_ID__c='Test';
            listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
            listingRecord1.Description_hz__c='Testing Area';
            listingRecord1.PropertySubType_hz__c='Industrial';
            listingRecord1.Property_Sub_Type__c='Residential - Apartment';
            listingRecord1.RERA_Permit_Number__c='100';
            listingRecord1.TotalArea_hz__c=1000;
            listingRecord1.Sub_Community_Propertyfinder__c='Test';
            listingRecord1.Community_Propertyfinder__c='Test';
            listingRecord1.Property_Propertyfinder__c='Test';
            listingRecord1.LocationText_Dubizzle__c='Test';
            listingRecord1.City_Propertyfinder__c='test';
            listingRecord1.Price_Unit__c='Price Yearly';
            listingRecord1.Completion_Status__c='Completed';
            listingRecord1.City_Dubizzle__c='Test';
            listingRecord1.Property_Status__c='Vacant on Transfer';
            listingRecord1.Available_from__c=date.today()+1;
            listingRecord1.CompletionDate_hz__c=date.today()+1;
            listingRecord1.PropertyOwnerContact__c=Contact1.Id;
            listingRecord1.Property_hz__c=pro.Id;
            listingRecord1.property_category__c='Commercial';
            insert listingRecord1;


            
            // SELECT WhoId Id FROM Task
            List <Task> tasks = new List <Task>();

            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            tsk1.WhoId            = Contact1.Id;
            tsk1.WhatId           = listingRecord1.Id;
            tsk1.ActivityDate     = System.today().addDays(-45);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Check Updates';
            
            tasks.add(tsk1);

            
            Insert tasks;
            
            
            Test.StartTest();
            // Call the Batch Apex method.
            listingRecurringTasksBatch fue = new listingRecurringTasksBatch();
            ID batchprocessid = Database.executeBatch(fue);        
            Test.StopTest();    
        }
    }
    static testMethod void TestlistingRecurringTasksBatch4() {
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
            Contact1.ContactType_hz__c = 'Seller';
            Contact1.Stage__c = 'Active';
            Contact1.MailingStreet = 'Test';
            Contact1.MailingCity = 'Test';
            Contact1.MailingCountry = 'India';
            Contact1.LeadSource = 'Open House';
            Contact1.MobilePhone ='11122222222'; 
            insert Contact1;
            

            Property_hz__c pro=new Property_hz__c();
            pro.name ='test';
            pro.Address_hz__c ='Test';
            pro.Area_hz__c ='Test';
            insert pro;

            Listing_hz__c listingRecord1 = new Listing_hz__c();
            listingRecord1.Name = 'Test1';
            listingRecord1.Status__c = 'Active';
            listingRecord1.ListingType__c = 'Sale';
            listingRecord1.PropertyType__c = 'Apartment';
            listingRecord1.Bedrooms_hz__c = 2;
            listingRecord1.FullBathrooms_hz__c = 2;
            listingRecord1.ListingPrice_hz__c = 1000;
            listingRecord1.City_hz__c = 'Test';
            listingRecord1.State_hz__c = 'Test';
            listingRecord1.Broker_s_Listing_ID__c='Test';
            listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
            listingRecord1.Description_hz__c='Testing Area';
            listingRecord1.PropertySubType_hz__c='Industrial';
            listingRecord1.Property_Sub_Type__c='Residential - Apartment';
            listingRecord1.RERA_Permit_Number__c='100';
            listingRecord1.TotalArea_hz__c=1000;
            listingRecord1.Sub_Community_Propertyfinder__c='Test';
            listingRecord1.Community_Propertyfinder__c='Test';
            listingRecord1.Property_Propertyfinder__c='Test';
            listingRecord1.LocationText_Dubizzle__c='Test';
            listingRecord1.City_Propertyfinder__c='test';
            listingRecord1.Price_Unit__c='Price Yearly';
            listingRecord1.Completion_Status__c='Completed';
            listingRecord1.City_Dubizzle__c='Test';
            listingRecord1.Property_Status__c='Vacant on Transfer';
            listingRecord1.Available_from__c=date.today()+1;
            listingRecord1.CompletionDate_hz__c=date.today()+1;
            listingRecord1.PropertyOwnerContact__c=Contact1.Id;
            listingRecord1.Property_hz__c=pro.Id;
            listingRecord1.property_category__c='Commercial';
            insert listingRecord1;


            
            // SELECT WhoId Id FROM Task
            List <Task> tasks = new List <Task>();

            Task tsk1             = new Task();
            tsk1.OwnerId          = u.Id;
            tsk1.WhoId            = Contact1.Id;
            tsk1.WhatId           = listingRecord1.Id;
            tsk1.ActivityDate     = System.today().addDays(-30);
            tsk1.Status           = 'Not Started';
            tsk1.Priority         = 'High';
            tsk1.Subject          = 'Check Updates';
            
            tasks.add(tsk1);

            
            Insert tasks;
            
            
            Test.StartTest();
            // Call the Batch Apex method.
            listingRecurringTasksBatch fue = new listingRecurringTasksBatch();
            ID batchprocessid = Database.executeBatch(fue);        
            Test.StopTest();    
        }
    }
    
}