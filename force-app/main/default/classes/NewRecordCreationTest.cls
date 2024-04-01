@isTest
public with sharing class NewRecordCreationTest {
   
    @isTest
    static void testFetchContact() {
        // Test data setup

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            MobilePhone = '1234567890',
            CompanyName__c = testAccount1.Id,
            Phone = '+971564479823',
            Email = 'john.doe@example.com'
        );
        insert testContact;

        Test.startTest();
        
        NewRecordCreation.contactWrapper result = NewRecordCreation.fetchContact(testContact);
        List<Contact> result1 = NewRecordCreation.getContacts(testContact.Id);

        Test.stopTest();
    }
    @isTest
    static void testGetRecordTypeRent() {
        String recordTypeId = Schema.SObjectType.Listing_hz__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId();
        System.assertEquals(recordTypeId, NewRecordCreation.getRecordType('Rent'));
    }

    @isTest
    static void testGetRecordTypeSale() {
        String recordTypeId = Schema.SObjectType.Listing_hz__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
        System.assertEquals(recordTypeId, NewRecordCreation.getRecordType('Sale'));
    }

    @isTest
    static void testGetRecordTypeException() {
        Test.startTest();
        try {
            NewRecordCreation.getRecordType(null);
        } catch (Exception e) {
            System.assert(e.getMessage() != null);
        }
        Test.stopTest();
    }
    @isTest
    static void testFetchListings() {
        // Create test data

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            MobilePhone = '1234567890',
            CompanyName__c = testAccount1.Id,
            Phone = '+971564479823',
            Email = 'john.doe@example.com'
        );
        insert testContact;


        Property_hz__c pro=new Property_hz__c();
        pro.Name ='test';
        pro.Address_hz__c ='Test';
        pro.Area_hz__c ='Test';
        pro.City_hz__c='Dubai';
        insert pro;

        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Active';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
        listingRecord1.Description_hz__c='Testing Area';
        listingRecord1.PropertySubType_hz__c='Industrial';
        listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
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
        listingRecord1.PropertyOwnerContact__c=testContact.Id;
        listingRecord1.Property_hz__c=pro.Id;
        listingRecord1.property_category__c='Commercial';
        insert listingRecord1;

        Test.startTest();
        // Call the method being tested
        Map<String,List<Listing_hz__c>> result = NewRecordCreation.fetchListings(pro);
        Test.stopTest();

        // Perform assertions
        System.assertEquals(1, result.size(), 'Map should contain one entry');
        List<Listing_hz__c> listings = result.get(pro.Id + '::' + pro.Name + '::' + pro.City_hz__c + ', ' + pro.Address_hz__c + ', ');
        List<Property_hz__c> result1 = NewRecordCreation.getListings(Pro.Id);

    }
  
    @isTest
    static void testCreateContact() {
        // Create test data


        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Map<String, Object> contactObj = new Map<String, Object>{
            'FirstName' => 'Test',
            'LastName' => 'Contact',
            'Email' => 'test@example.com',
            'Salutation' => 'Mr.',
            'Company' => testAccount1.Id,
            'MobilePhone' => '1234567890',
            'Phone' => '+971564400823',
            'LeadSource' => 'Web'
        };

        // Call the method under test
        Test.startTest();
        Contact createdContact = NewRecordCreation.createContact(contactObj);
        Test.stopTest();

       
    }
    @isTest
    static void testAbRequest() {
        // Instantiate the abRequest class
        NewRecordCreation.abRequest request = new NewRecordCreation.abRequest();
        
        // Set values for contact properties
        request.contactSalutation = 'Mr.';
        request.contactFirstName = 'John';
        request.contactLastName = 'Doe';
        request.contactEmail = 'john.doe@example.com';
        request.contactCompany = 'Example Inc.';
        request.contactMobilePhone = '1234567890';
        request.contactPhone = '0987654321';
        request.contactLeadSource = 'Web';
        request.contactId = '00128000009KzthAAC';
        
        // Set values for listing properties
        request.listingRecordType = 'Residential';
        request.listingCity = 'New York';
        request.listingtitle = 'Beautiful Apartment';
        request.listingaddress = '123 Main St';
        request.listingPropertyId = 'A12345';
        request.listingAppName = 'My App';
        request.listingStreetNumName = '123';
        request.listingStreet = 'Main St';
        request.listingArea = 'Downtown';
        request.listingState = 'NY';
        request.listingZipcode = '10001';
        request.listingBedrooms = '2';
        request.listingAssignedTo = 'Agent123';
        request.listingPropertyType = 'Condo';
        request.listingappsource = 'Website';

  
    }
    @isTest
    static void testCreateListingRecord() {

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            MobilePhone = '1234567890',
            CompanyName__c = testAccount1.Id,
            Phone = '+971564479823',
            Email = 'john.doe@example.com'
        );
        insert testContact;



        Property_hz__c pro=new Property_hz__c();
        pro.Name ='test';
        pro.Address_hz__c ='Test';
        pro.Area_hz__c ='Test';
        pro.City_hz__c='Dubai';
        insert pro;
        // Create a test record type
        RecordType rt = [SELECT Id,Name,DeveloperName FROM RecordType WHERE SObjectType = 'Listing_hz__c' LIMIT 1];


        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Active';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
        listingRecord1.Description_hz__c='Testing Area';
        listingRecord1.PropertySubType_hz__c='Industrial';
        listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
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
        listingRecord1.PropertyOwnerContact__c=testContact.Id;
        listingRecord1.Property_hz__c=pro.Id;
        listingRecord1.property_category__c='Commercial';
        insert listingRecord1;




        Test.startTest();
        // Call the method being tested
        List<Listing_hz__c> listings = NewRecordCreation.createListingRecord('Sale', 'Test Apartment', listingRecord1.City_hz__c, listingRecord1.Property_hz__c, '2', 'Apartment', 'Test Address');
        Test.stopTest();

       
     
    }


}