@isTest
private class createDuplicateContactBatchTest {
    
    static Contact createContact(String fname, String lname) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.Stage__c = 'Called: No Reply';
        c.ContactType_hz__c = 'Landlord';
        insert c;
        return c;
    } 
    
    static testMethod void TestCreateDuplicateContactBatch() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com');
        Insert u;
        
        
            // create test contacts
            Contact Contact1 = createContact('First1', 'Test1');
            
            
            List <Contact> contacts = new List <Contact>();
        


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
        listing1.RERA_Expiry_Date__c = Date.newInstance(2021, 04, 21);
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

        
         
            
            
            Contact Contact2 = createContact('First2', 'Test2');
            
            Inquiry_hz__c inquiry1 = new Inquiry_hz__c();
            inquiry1.Contact__c = Contact2.id;
            inquiry1.Type_hz__c = 'Buyer';
            inquiry1.ListingType__c = 'Sale';
            inquiry1.PropertyType__c = 'Villa';
            inquiry1.City__c = 'Dubai';
            inquiry1.PropertyStatus_hz__c = 'Active';
            inquiry1.Area__c = 'Al Safa';
            inquiry1.ListingPrice_hz_min__c = 1000;
            inquiry1.ListingPrice_hz_max__c = 2000;
            inquiry1.Bedrooms_hz_min__c= 3;
            inquiry1.Listing__c = listing1.Id;
            
 		insert inquiry1;
            
            //String CRON_EXP = '0 0 0 2 4 ? 2021';
            Test.StartTest();
            
            // Call the Batch Apex method.
            createDuplicateContactBatch fue = new createDuplicateContactBatch();
            ID batchprocessid = Database.executeBatch(fue);
            
            Test.StopTest();
            
            List<Inquiry_hz__c> inquiryResult = [SELECT ID From Inquiry_hz__c LIMIT 10];
            System.debug('inquiryResult' + inquiryResult.size());
            
        
    }
    
}