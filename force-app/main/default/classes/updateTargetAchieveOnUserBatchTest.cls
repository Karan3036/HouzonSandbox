@isTest
private class updateTargetAchieveOnUserBatchTest {
   
    static Contact createLandlordContact(String fname, String lname) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.ContactType_hz__c = 'Landlord';
        c.LeadSource = 'Portal';
        c.LeadSourceCategory_hz__c  = 'Getthat';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
        insert c;
        
        return c;
    }
    
    static Contact createTenantContact(String fname, String lname) {
        
        Contact t = new Contact();
        t.FirstName = fname;
        t.LastName = lname;
        t.ContactType_hz__c = 'Tenant';
        t.LeadSource = 'Portal';
        t.LeadSourceCategory_hz__c  = 'Getthat';
        t.MailingStreet = 'Test';
        t.MailingCity = 'Test';
        t.MailingCountry = 'India';
        insert t;
        
        return t;
    }
    
    static testMethod void TestUpdateTargetAchieveOnUserBatch() {
        
        
        Date firstDayOfMonth = System.today().toStartOfMonth();
        System.debug('First Day of the Month-->'+firstDayOfMonth);
        Profile p = [SELECT Id FROM Profile WHERE Name='HZ Agent'];
        User manager = [SELECT Id FROM User WHERE Name = 'Vansh Mehra'];
        system.debug('Profile Id -->'+p.Id);
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com',ManagerId = manager.Id);
        Insert u;
        system.debug('User Created-->'+u.Id);
        
     



        System.runAs(u){
            // create test contacts
            Contact Contact1 = createLandlordContact('First1', 'Test1');
            Contact Contact2 = createTenantContact('First2', 'Test2');     

            Property_hz__c pro=new Property_hz__c();
            pro.name ='test';
            pro.Address_hz__c ='Test';
            pro.Area_hz__c ='Test';
            insert pro;
    
            Listing_hz__c listing1 = new Listing_hz__c();
            listing1.Name = 'Test1';
            listing1.Status__c = 'Active';
            listing1.ListingType__c = 'Rental';
            listing1.PropertyType__c = 'Apartment';
            listing1.Bedrooms_hz__c = 2;
            listing1.FullBathrooms_hz__c = 2;
            listing1.ListingPrice_hz__c = 1000;
            listing1.City_hz__c = 'Test';
            listing1.State_hz__c = 'Test';
            listing1.Broker_s_Listing_ID__c='Test';
            listing1.Description_hz__c='Testing Area';
            listing1.PropertySubType_hz__c='Industrial';
            listing1.Houzon_Broker_s_Listing_ID__c='Test1';
            listing1.Property_Sub_Type__c='Residential - Apartment';
            listing1.RERA_Permit_Number__c='100';
            listing1.TotalArea_hz__c=1000;
            listing1.Sub_Community_Propertyfinder__c='Test';
            listing1.Community_Propertyfinder__c='Test';
            listing1.Property_Propertyfinder__c='Test';
            listing1.LocationText_Dubizzle__c='Test';
            listing1.City_Propertyfinder__c='test';
            listing1.Price_Unit__c='Price Yearly';
            listing1.Completion_Status__c='Completed';
            listing1.City_Dubizzle__c='Test';
            listing1.Property_Status__c='Vacant on Transfer';
            listing1.Available_from__c=date.today()+1;
            listing1.CompletionDate_hz__c=date.today()+1;
            listing1.PropertyOwnerContact__c=Contact1.Id;
            listing1.Property_hz__c=pro.Id;
            listing1.property_category__c='Commercial';
            listing1.RERA_Expiry_Date__c = Date.newInstance(2024, 04, 21);
            listing1.Bedrooms_hz__c = 2;
            listing1.FullBathrooms_hz__c = 2;
            listing1.TotalArea_hz__c = 500;
            listing1.Listing_Agent_Firstname__c = 'listing agent first';
            listing1.Listing_Agent_Lastname__c = 'listing agent Last';
            listing1.Listing_Agent_Phone__c = '8765456543';
            listing1.Listing_Agent_Email__c = 'listingagent1@test.com';
            listing1.ListingPrice_hz__c = 5000;
            listing1.Propertyfinder_Region__c = 'Abu Dhabi - Al Ghadeer - Al Sabeel Building';
            listing1.City_Propertyfinder__c = 'Abu Dhabi';
            listing1.Community_Propertyfinder__c = 'Al Ghadeer';
            listing1.City_Dubizzle__c = 'Abu Dhabi';
            listing1.OwnerId = u.Id;
            insert listing1;
    
            
            
            Closing_hz__c closing1 = new Closing_hz__c();
            closing1.Renter__c = Contact2.id;
            closing1.Landlord_c__c = Contact1.id;
            closing1.Listing_hz__c = listing1.id;
            closing1.Lease_Terms__c = '3 Month';
            closing1.ClosingDate__c = Date.newInstance(2024, 08, 28);
            closing1.Rental_Agreement_Date__c = date.parse('07/11/2024');
            closing1.Rental_Agreement_End_Date__c = date.parse('10/10/2024');
            closing1.Closing_Status__c = 'Closed';
            closing1.Agent_Commission__c = 1000;
            closing1.TotalCommissionAmount__c = 1000;
            closing1.OwnerId = u.Id;
            
            Closing_hz__c closing2 = new Closing_hz__c();
            closing2.Renter__c = Contact2.id;
            closing2.Landlord_c__c = Contact1.id;
            closing2.Listing_hz__c = listing1.id;
            closing2.Lease_Terms__c = '3 Month';
            closing2.ClosingDate__c = Date.newInstance(2024, 05, 18);
            closing2.Rental_Agreement_Date__c = date.parse('07/11/2024');
            closing2.Rental_Agreement_End_Date__c = date.parse('09/09/2024');
            closing2.Closing_Status__c = 'Closed';
            closing1.TotalCommissionAmount__c = 3000;
            closing2.Agent_Commission__c = 2000;
            closing2.OwnerId = u.Id;
            
      
            Test.StartTest();
            
            	insert closing1;
                insert closing2;    
            // Call the Batch Apex method.
                updateTargetAchieveOnUserBatch fue = new updateTargetAchieveOnUserBatch();
                ID batchprocessid = Database.executeBatch(fue);
                
            Test.StopTest();
        }
    }
    @isTest static void testMethod1(){
         
        updateTargetAchieveOnUserBatchSchedule contactTaskSchedule = new updateTargetAchieveOnUserBatchSchedule();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, contactTaskSchedule); 
    } 

}