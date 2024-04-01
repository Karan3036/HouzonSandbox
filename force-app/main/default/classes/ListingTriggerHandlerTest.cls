@isTest 
public with sharing class ListingTriggerHandlerTest {
  
    @isTest
    static void testOnBeforeInsert_ActiveStatus() {
        List<Listing_hz__c> newListings = new List<Listing_hz__c>();
        Listing_hz__c activeListing = new Listing_hz__c(Status__c = 'Active');
        Listing_hz__c inactiveListing = new Listing_hz__c(Status__c = 'Inactive');
        newListings.add(activeListing);
        newListings.add(inactiveListing);
        
        ListingTriggerHandler handler = new ListingTriggerHandler(newListings, new List<Listing_hz__c>(), new Map<Id, Listing_hz__c>(), new Map<Id, Listing_hz__c>(), true, false, false, false);
        handler.OnBeforeInsert(newListings);
        
    }

    @isTest
    static void testOnBeforeUpdate_ActiveStatus() {
        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        Listing_hz__c activeListing = new Listing_hz__c();
        activeListing.Name = 'Test1';
        activeListing.Status__c = 'Active';
        activeListing.ListingType__c = 'Rental';
        activeListing.PropertyType__c = 'Apartment';
        activeListing.Bedrooms_hz__c = 2;
        activeListing.FullBathrooms_hz__c = 2;
        activeListing.ListingPrice_hz__c = 1000;
        activeListing.City_hz__c = 'Test';
        activeListing.State_hz__c = 'Test';
        activeListing.Broker_s_Listing_ID__c='Test';
        activeListing.Description_hz__c='Testing Area';
        activeListing.PropertySubType_hz__c='Industrial';
        activeListing.Property_Sub_Type__c='Residential - Apartment';
        activeListing.RERA_Permit_Number__c='100';
        activeListing.TotalArea_hz__c=1000;
        activeListing.Sub_Community_Propertyfinder__c='Test';
        activeListing.Community_Propertyfinder__c='Test';
        activeListing.Property_Propertyfinder__c='Test';
        activeListing.LocationText_Dubizzle__c='Test';
        activeListing.City_Propertyfinder__c='test';
        activeListing.Price_Unit__c='Price Yearly';
        activeListing.Completion_Status__c='Completed';
        activeListing.City_Dubizzle__c='Test';
        activeListing.Property_Status__c='Vacant on Transfer';
        activeListing.Available_from__c=date.today()+1;
        activeListing.CompletionDate_hz__c=date.today()+1;
        activeListing.property_category__c='Commercial';
        activeListing.PropertyOwnerContact__c=testContact1.Id;
        activeListing.Houzon_Broker_s_Listing_ID__c='Test';
        insert activeListing;


        Listing_hz__c inactiveListing = new Listing_hz__c();
        inactiveListing.Name = 'Test1';
        inactiveListing.Status__c = 'Inactive';
        inactiveListing.ListingType__c = 'Rental';
        inactiveListing.PropertyType__c = 'Apartment';
        inactiveListing.Bedrooms_hz__c = 2;
        inactiveListing.FullBathrooms_hz__c = 2;
        inactiveListing.ListingPrice_hz__c = 1000;
        inactiveListing.City_hz__c = 'Test';
        inactiveListing.State_hz__c = 'Test';
        inactiveListing.Broker_s_Listing_ID__c='Test';
        inactiveListing.Description_hz__c='Testing Area';
        inactiveListing.PropertySubType_hz__c='Industrial';
        inactiveListing.Property_Sub_Type__c='Residential - Apartment';
        inactiveListing.RERA_Permit_Number__c='100';
        inactiveListing.TotalArea_hz__c=1000;
        inactiveListing.Sub_Community_Propertyfinder__c='Test';
        inactiveListing.Community_Propertyfinder__c='Test';
        inactiveListing.Property_Propertyfinder__c='Test';
        inactiveListing.LocationText_Dubizzle__c='Test';
        inactiveListing.City_Propertyfinder__c='test';
        inactiveListing.Price_Unit__c='Price Yearly';
        inactiveListing.Completion_Status__c='Completed';
        inactiveListing.City_Dubizzle__c='Test';
        inactiveListing.Property_Status__c='Vacant on Transfer';
        inactiveListing.Available_from__c=date.today()+1;
        inactiveListing.CompletionDate_hz__c=date.today()+1;
        inactiveListing.property_category__c='Commercial';
        inactiveListing.PropertyOwnerContact__c=testContact1.Id;
        inactiveListing.Houzon_Broker_s_Listing_ID__c='Test';
        insert inactiveListing;

        
        ListingTriggerHandler handler = new ListingTriggerHandler(new List<Listing_hz__c>(), new List<Listing_hz__c>{activeListing, inactiveListing}, new Map<Id, Listing_hz__c>(), new Map<Id, Listing_hz__c>(), false, true, false, false);
        handler.OnBeforeUpdate(new List<Listing_hz__c>{activeListing, inactiveListing});
        handler.handleListingBeforeInsert();
        handler.updateSizeOfCharacter(activeListing);

        inactiveListing.RERA_Permit_Number__c = 'TestReraPermit1';
        update inactiveListing;

        handler.OnBeforeUpdate(new List<Listing_hz__c>{activeListing, inactiveListing});
        
    }
}