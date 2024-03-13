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
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
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
        listingRecord1.Completion_Status__c='Completed';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
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
        XMLFeedGenerator xmlGenerator = new XMLFeedGenerator();
        Test.stopTest();

        System.assertNotEquals(null, xmlGenerator.xmlstring);
    }

}