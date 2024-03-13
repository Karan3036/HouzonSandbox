/**
 ** Title : TestPortalSyndicationController
 *
 ** @author : Nishit Suthar
 * @version 1.0
 * @description : Test class for PortalSyndicationController
 * @uses
 *! @history : None
 ** 		yyyy-mm-dd : 11th March, 2024
 */
    @isTest
    private class TestPortalSyndicationController {

        @isTest
        static void unitTest1() {

            Account testAccount1 = new Account(Name='Test Account 1');
            insert testAccount1;

            Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
            insert testContact1;  

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

            Listing_hz__c listingRecord2 = new Listing_hz__c();
            listingRecord2.Name = 'Test2';
            listingRecord2.Status__c = 'Active';
            listingRecord2.ListingType__c = 'Rental';
            listingRecord2.PropertyType__c = 'Apartment';
            listingRecord2.Bedrooms_hz__c = 2;
            listingRecord2.FullBathrooms_hz__c = 2;
            listingRecord2.ListingPrice_hz__c = 1000;
            listingRecord2.City_hz__c = 'Test';
            listingRecord2.Price_Unit__c='Price Yearly';
            listingRecord2.State_hz__c = 'Test';
            listingRecord2.Broker_s_Listing_ID__c='Test';
            listingRecord2.Description_hz__c='Testing Area';
            listingRecord2.Property_Sub_Type__c='Residential - Apartment';
            listingRecord2.PropertySubType_hz__c='Office';
            listingRecord2.RERA_Permit_Number__c='100';
            listingRecord2.Completion_Status__c='Completed';
            listingRecord2.Property_Status__c='Vacant on Transfer';
            listingRecord2.TotalArea_hz__c=1000;
            listingRecord2.Sub_Community_Propertyfinder__c='Test1';
            listingRecord2.Community_Propertyfinder__c='Test';
            listingRecord2.Property_Propertyfinder__c='Test';
            listingRecord2.LocationText_Dubizzle__c='Test';
            listingRecord2.City_Propertyfinder__c='test';
            listingRecord2.City_Dubizzle__c='Test';
            listingRecord2.Available_from__c=date.today()+1;
            listingRecord2.CompletionDate_hz__c=date.today()+1;
            listingRecord2.PropertyOwnerContact__c=testContact1.Id;
            insert listingRecord2;

            Portal__c portalRecord1 = new Portal__c();
            portalRecord1.Name = 'Test';
            portalRecord1.Status__c = true;
            portalRecord1.isActive__c = true;
            insert portalRecord1;

            PortalFeed__c portalfeed = new PortalFeed__c();
            portalfeed.portal_default__c=false;
            portalfeed.Name='Test';
            portalfeed.SystemIsListedOnPortals__c=false;
            portalfeed.SystemListing__c=listingRecord1.Id;
            portalfeed.SystemListingIdDel__c='test';
            portalfeed.SystemRequestListOnPortals__c=false;
            insert portalfeed;


            List<PortalListing__c> portalListingList = new List<PortalListing__c>();
            PortalListing__c portalListingRecord1 = new PortalListing__c();
            portalListingRecord1.Portal__c = portalRecord1.Id;
            portalListingRecord1.Listing_hz__c = listingRecord1.Id;
            portalListingRecord1.PortalFeed__c=portalfeed.Id;
            portalListingRecord1.SystemIsActive__c = true;
            portalListingList.add(portalListingRecord1);

            PortalListing__c portalListingRecord2 = new PortalListing__c();
            portalListingRecord2.Portal__c = portalRecord1.Id;
            portalListingRecord2.Listing_hz__c = listingRecord1.Id;
            portalListingRecord2.SystemIsActive__c = true;
            portalListingRecord2.PortalFeed__c=portalfeed.Id;
            portalListingList.add(portalListingRecord2);


            insert portalListingList;

            Test.startTest();
            PortalSyndicationController.createPortalListingRecord(listingRecord1.Id, portalRecord1.Id, 'Publish');
            PortalSyndicationController.fetchPortals(listingRecord1.Id);
            PortalSyndicationController.fetchPortals(listingRecord2.Id);
            Test.stopTest();
        }
    }