@isTest 
public with sharing class PermitNumberControllerTest {
    @isTest
    static void testReraPermitCheck() {
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
        listingRecord1.RERA_Permit_Number__c = 'TestReraPermit';
        insert listingRecord1;


        Listing_hz__c listingRecord2 = new Listing_hz__c();
        listingRecord2.Name = 'Test1';
        listingRecord2.Status__c = 'Inactive';
        listingRecord2.ListingType__c = 'Rental';
        listingRecord2.PropertyType__c = 'Apartment';
        listingRecord2.Bedrooms_hz__c = 2;
        listingRecord2.FullBathrooms_hz__c = 2;
        listingRecord2.ListingPrice_hz__c = 1000;
        listingRecord2.City_hz__c = 'Test';
        listingRecord2.State_hz__c = 'Test';
        listingRecord2.Broker_s_Listing_ID__c='Test';
        listingRecord2.Houzon_Broker_s_Listing_ID__c='Test1';
        listingRecord2.Description_hz__c='Testing Area';
        listingRecord2.PropertySubType_hz__c='Industrial';
        listingRecord2.Property_Sub_Type__c='Residential - Apartment';
        listingRecord2.RERA_Permit_Number__c='100';
        listingRecord2.TotalArea_hz__c=1000;
        listingRecord2.Sub_Community_Propertyfinder__c='Test';
        listingRecord2.Community_Propertyfinder__c='Test';
        listingRecord2.Property_Propertyfinder__c='Test';
        listingRecord2.LocationText_Dubizzle__c='Test';
        listingRecord2.City_Propertyfinder__c='test';
        listingRecord2.Price_Unit__c='Price Yearly';
        listingRecord2.Completion_Status__c='Completed';
        listingRecord2.City_Dubizzle__c='Test';
        listingRecord2.Property_Status__c='Vacant on Transfer';
        listingRecord2.Available_from__c=date.today()+1;
        listingRecord2.CompletionDate_hz__c=date.today()+1;
        listingRecord2.PropertyOwnerContact__c=testContact1.Id;
        listingRecord2.Property_hz__c=pro.Id;
        listingRecord2.property_category__c='Commercial';
        listingRecord2.RERA_Permit_Number__c = 'TestReraPermit';
        insert listingRecord2;

        Test.startTest();
        listingRecord2.RERA_Permit_Number__c = 'TestReraPermit1';
        update listingRecord2;
        PermitNumberController.reraPermitCheck(new List<Listing_hz__c>{listingRecord1, listingRecord2});

        Map<String, Id> reraPermitNumbers = PermitNumberController.activeRecords();

        Boolean result1 = PermitNumberController.activeRecsWithReraNumber(listingRecord1);
        Boolean result2 = PermitNumberController.activeRecsWithReraNumber(listingRecord2);

        Map<String, Id> reraPermitNumbers1 = new Map<String, Id>();
        reraPermitNumbers.put('TestReraPermit', listingRecord1.Id);
        PermitNumberController.handleDupilcate(listingRecord2, reraPermitNumbers1);
        Test.stopTest();
    }
}