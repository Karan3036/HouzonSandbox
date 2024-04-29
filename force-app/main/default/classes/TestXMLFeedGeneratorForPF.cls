/**
 ** Title : TestXMLFeedGeneratorForPF
 *
 ** @author : Harsh Shah
 * @version 1.0
 * @description : Test class for XMLFeedGeneratorForPF
 * @uses
 *! @history : None
 ** 		yyyy-mm-dd : 11th March, 2024
 */
@isTest
public with sharing class TestXMLFeedGeneratorForPF {
    @isTest
    static void testXMLFeedGeneration() {

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        // Create test data
        Portal__c testPortal = new Portal__c(Name = 'Test Portal');
        insert testPortal;


        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Active';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Broker_s_Listing_ID_2__c = 'KARANSINGH';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
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
        listingRecord1.Propertyfinder_Region__c='Dubai - Dubai Hills Estate - Palm Hills';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        insert listingRecord1;


        PortalFeed__c portalfeed = new PortalFeed__c();
        portalfeed.portal_default__c=false;
        portalfeed.Name='Test';
        portalfeed.SystemIsListedOnPortals__c=false;
        portalfeed.SystemListing__c=listingRecord1.Id;
        portalfeed.SystemListingIdDel__c='test';
        portalfeed.SystemRequestListOnPortals__c=false;
        insert portalfeed;


        PortalListing__c testPortalListing = new PortalListing__c();
        testPortalListing.Listing_hz__c = listingRecord1.Id;
        testPortalListing.Portal__c = testPortal.Id;
        testPortalListing.SystemIsActive__c = true;
        testPortalListing.PortalFeed__c=portalfeed.Id;
        insert testPortalListing;

        Test.startTest();
        PageReference pageRef = Page.XMLFeedForPF; 
        Test.setCurrentPage(pageRef);
        XMLFeedGeneratorForPF xmlGenerator = new XMLFeedGeneratorForPF();
        Test.stopTest();

        System.assertNotEquals(null, xmlGenerator.xmlstring);
    }

    @isTest
    static void testXMLFeedGeneration1() {

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        // Create test data
        Portal__c testPortal = new Portal__c(Name = 'Test Portal',generator__c='Propertyfinder');
        insert testPortal;

        testPortal.name='Testing Portal';
        update testPortal;
    }

    @isTest
    static void testXMLFeedGeneration2() {

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        // Create test data
        Portal__c testPortal = new Portal__c(Name = 'Test Portal');
        insert testPortal;


        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Active';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.Broker_s_Listing_ID_2__c = 'KARANSINGH';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
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
        listingRecord1.Propertyfinder_Region__c='Dubai - Dubai Hills Estate - Palm Hills';
        listingRecord1.Completion_Status__c='Completed';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        listingRecord1.property_category__c='Commercial';
        insert listingRecord1;

        
        listingRecord1.City_Dubizzle__c='Test1';
        update listingRecord1;

        listingRecord1.Status__c='Pending';
        listingRecord1.SystemAllowedForPortals__c=false;
        update listingRecord1;

        PortalFeed__c portalfeed = new PortalFeed__c();
        portalfeed.portal_default__c=false;
        portalfeed.Name='Test';
        portalfeed.SystemIsListedOnPortals__c=false;
        portalfeed.SystemListing__c=listingRecord1.Id;
        portalfeed.SystemListingIdDel__c='test';
        portalfeed.SystemRequestListOnPortals__c=false;
        insert portalfeed;


        PortalListing__c testPortalListing = new PortalListing__c();
        testPortalListing.Listing_hz__c = listingRecord1.Id;
        testPortalListing.Portal__c = testPortal.Id;
        testPortalListing.SystemIsActive__c = true;
        testPortalListing.PortalFeed__c=portalfeed.Id;
        insert testPortalListing;

        Test.startTest();
        PageReference pageRef = Page.XMLFeedForPF; 
        Test.setCurrentPage(pageRef);
        XMLFeedGenerator xmlGenerator = new XMLFeedGenerator();
        XMLFeedGeneratorForDubizzle xmlGenerator1 = new XMLFeedGeneratorForDubizzle();
        Test.stopTest();

        System.assertNotEquals(null, xmlGenerator.xmlstring);
        System.assertNotEquals(null, xmlGenerator1.xmlstring);
    }

    @isTest
    static void testOnBeforeUpdateActive() {
    
        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        Portal__c testPortal = new Portal__c(Name = 'Test Portal');
        insert testPortal;


        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Active';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Broker_s_Listing_ID_2__c = 'KARANSINGH';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
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
        listingRecord1.Propertyfinder_Region__c='Dubai - Dubai Hills Estate - Palm Hills';
        listingRecord1.Price_Unit__c='Price Yearly';
        listingRecord1.Completion_Status__c='Completed';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        insert listingRecord1;


        // Call the trigger
        Test.startTest();

        // Prepare necessary data for testing
        List<Listing_hz__c> newList = new List<Listing_hz__c>{listingRecord1};
        List<Listing_hz__c> oldList = new List<Listing_hz__c>{};
        Map<Id, Listing_hz__c> newMap = new Map<Id, Listing_hz__c>{listingRecord1.Id => listingRecord1};
        Map<Id, Listing_hz__c> oldMap = new Map<Id, Listing_hz__c>{};
        Boolean isInsert = false; // Set appropriate values for these flags
        Boolean isUpdate = true;
        Boolean isDelete = false;
        Boolean isUndelete = false;

        // Instantiate ListingTriggerHandler with required parameters
        ListingTriggerHandler handler = new ListingTriggerHandler(newList, oldList, newMap, oldMap, isInsert, isUpdate, isDelete, isUndelete);

        // Call the method you want to test
        handler.onBeforeUpdate(newList);

        Test.stopTest();

        
        // Assertions
        listingRecord1 = [SELECT Id, SystemAllowedForPortals__c FROM Listing_hz__c WHERE Id = :listingRecord1.Id];
    }
    
    @isTest
    static void testOnBeforeUpdateInactive() {
     

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        Portal__c testPortal = new Portal__c(Name = 'Test Portal');
        insert testPortal;


        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Pending';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.Broker_s_Listing_ID_2__c = 'KARANSINGH';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
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
        listingRecord1.Propertyfinder_Region__c='Dubai - Dubai Hills Estate - Palm Hills';
        listingRecord1.Completion_Status__c='Completed';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        insert listingRecord1;


 


        PortalFeed__c portalfeed = new PortalFeed__c();
        portalfeed.portal_default__c=false;
        portalfeed.Name='Test';
        portalfeed.SystemIsListedOnPortals__c=false;
        portalfeed.SystemListing__c=listingRecord1.Id;
        portalfeed.SystemListingIdDel__c='test';
        portalfeed.SystemRequestListOnPortals__c=false;
        insert portalfeed;


        PortalListing__c portalListing = new PortalListing__c();
        portalListing.Listing_hz__c = listingRecord1.Id;
        portalListing.Portal__c = testPortal.Id;
        portalListing.SystemIsActive__c = true;
        portalListing.PortalFeed__c=portalfeed.Id;
        insert portalListing;


        
        // Call the trigger
        Test.startTest();

        // Prepare necessary data for testing
        List<Listing_hz__c> newList = new List<Listing_hz__c>{listingRecord1};
        List<Listing_hz__c> oldList = new List<Listing_hz__c>{};
        Map<Id, Listing_hz__c> newMap = new Map<Id, Listing_hz__c>{listingRecord1.Id => listingRecord1};
        Map<Id, Listing_hz__c> oldMap = new Map<Id, Listing_hz__c>{};
        Boolean isInsert = false; // Set appropriate values for these flags
        Boolean isUpdate = true;
        Boolean isDelete = false;
        Boolean isUndelete = false;

        // Instantiate ListingTriggerHandler with required parameters
        ListingTriggerHandler handler = new ListingTriggerHandler(newList, oldList, newMap, oldMap, isInsert, isUpdate, isDelete, isUndelete);

        // Call the method you want to test
        handler.onBeforeUpdate(newList);

        Test.stopTest();

        
        // Assertions
        listingRecord1 = [SELECT Id, SystemAllowedForPortals__c FROM Listing_hz__c WHERE Id = :listingRecord1.Id];
        
        List<PortalListing__c> updatedPortalListings = [SELECT Id, SystemIsActive__c FROM PortalListing__c WHERE Listing_hz__c = :listingRecord1.Id];
    }


}