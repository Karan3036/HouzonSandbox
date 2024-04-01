@isTest
public with sharing class UploadControllerTest {
     
    @isTest
    static void testFetchData() {

        Property_hz__c pro=new Property_hz__c();
        pro.name ='test';
        pro.Address_hz__c ='Test';
        pro.Area_hz__c ='Test';
        insert pro;

        PropertyMedia__c propertyMedia = new PropertyMedia__c(
            Name = 'Test Media',
            FilenameUrlEncoded__c = 'test_url',
            Size__c = 1024,
            Property_hz__c = pro.Id
        );
        insert propertyMedia;

        List<PropertyMedia__c> result = uploadController.fetchdata(propertyMedia.Property_hz__c);

        System.assertEquals(1, result.size(), 'Expected one record');
    }

    @isTest
    static void testFetchDataForListing() {


        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1; 
        
        Property_hz__c pro=new Property_hz__c();
        pro.name ='test';
        pro.Address_hz__c ='Test';
        pro.Area_hz__c ='Test';
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
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        listingRecord1.Property_hz__c=pro.Id;
        listingRecord1.property_category__c='Commercial';
        insert listingRecord1;

        

        PropertyMedia__c propertyMedia = new PropertyMedia__c(
            Name = 'Test Media',
            FilenameUrlEncoded__c = 'test_url',
            Size__c = 1024,
            Property_hz__c = pro.Id
        );
        insert propertyMedia;

        uploadController.getListingRecord(listingRecord1.Id);


        List<PropertyMedia__c> result = uploadController.fetchdataforlisting(listingRecord1.Id);
        Boolean result1 = uploadController.deletelistingmedia(null, listingRecord1.Id);
        Boolean result2 = uploadController.deletemedia(propertyMedia.Id, null);
        Boolean result3 = uploadController.createmediaforlisting('Test Media', 10.0, listingRecord1.Id, 'https://example.com/test');
        List<PropertyMedia__c> mediaList = [SELECT Id FROM PropertyMedia__c WHERE Id = :propertyMedia.Id];
        Boolean result5 = uploadController.updateSortOrder(mediaList);
        PropertyMedia__c propertyMedia2 = new PropertyMedia__c(
            Name = 'Test Media',
            FilenameUrlEncoded__c = 'test_url',
            Size__c = 1024,
            Property_hz__c = pro.Id
        );
        insert propertyMedia2;
        propertyMedia2.Name = 'Test Media2';
        update propertyMedia2;
        Boolean result6 = uploadController.updateOrderState(new List<Id>{propertyMedia2.Id}, new List<Id>(), new List<Id>(),new List<Id>(),new List<Id>(),new List<Id>());
        PropertyMedia__c propertyMedia1 = new PropertyMedia__c(
            Name = 'Test Media',
            FilenameUrlEncoded__c = 'test_url',
            Size__c = 1024,
            Property_hz__c = pro.Id
        );
        insert propertyMedia1;

        Boolean result7 = uploadController.updateOrderState_toFalse(new List<Id>(), new List<Id>{propertyMedia1.Id}, new List<Id>());

    }

    @isTest
    static void testCreateMedia() {
        String propertyName = 'Test Property';
        Decimal fileSize = 1024;
        String url = 'test_url';
        String externalLink = 'external_link';

        Property_hz__c pro=new Property_hz__c();
        pro.name ='test';
        pro.Address_hz__c ='Test';
        pro.Area_hz__c ='Test';
        insert pro;


        Boolean result = uploadController.createmedia(propertyName, fileSize, pro.Id, url, externalLink);



        System.assertEquals(true, result, 'Expected creation success');

        List<PropertyMedia__c> insertedMedia = [SELECT Id FROM PropertyMedia__c WHERE Name = :propertyName AND Property_hz__c = :pro.Id];
        System.assertEquals(1, insertedMedia.size(), 'Expected one record inserted');
        S3Service.getS3ConfigSettings();

    }
    @isTest
    static void deletePromedia() {


        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1; 
        
        Property_hz__c pro=new Property_hz__c();
        pro.name ='test';
        pro.Address_hz__c ='Test';
        pro.Area_hz__c ='Test';
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
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        listingRecord1.Property_hz__c=pro.Id;
        listingRecord1.property_category__c='Commercial';
        insert listingRecord1;

        
        Decimal newSize = 200;
        PropertyMedia__c propertyMedia = new PropertyMedia__c(
            Name = 'Test Media',
            FilenameUrlEncoded__c = 'test_url',
            Size__c = 1024,
            Property_hz__c = pro.Id,
            Tags__c='tag1;tag2'
        );
        insert propertyMedia;
        
        Boolean result4 = uploadController.update_media_name(propertyMedia.Id, 'Test Media','test_url',new List<String>{'tag3', 'tag4'},null,propertyMedia.Size__c); 
        
        PropertyMedia__c propertyMedia1 = new PropertyMedia__c(
            Name = 'Test Media',
            FilenameUrlEncoded__c = 'test_url',
            Size__c = 1024,
            Property_hz__c = pro.Id
        );
        insert propertyMedia1;
        propertyMedia1.name='Test Media1';
        update propertyMedia1;

        Boolean result5 = uploadController.update_media_name(propertyMedia1.Id, 'Test Media1','test_url',new List<String>{'tag3', 'tag4'},null,propertyMedia1.Size__c);
    }
    @isTest
    static void testGetListingRecord_Exception() {
        Test.startTest();
        try {
            uploadController.getListingRecord('invalidId');
            System.assert(false, 'Expected exception was not thrown');
        } catch (AuraHandledException e) {
        }
        Test.stopTest();
    }
}