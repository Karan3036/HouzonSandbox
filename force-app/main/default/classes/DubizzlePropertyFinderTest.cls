@isTest
public with sharing class DubizzlePropertyFinderTest {
    @isTest
    static void testFetchLookupData() {
        // Test data setup
        String searchKey = 'Dubai';
        String sObjectApiName = 'SearchProperties__c';

        // Call the method
        Test.startTest();
        List<sObject> result = DubizzlePropertyFinder.fetchLookupData(searchKey, sObjectApiName);
        Test.stopTest();

        // Assert the result
        System.assertEquals(0, result.size(), 'Result should be empty for the provided search key');
    }

    @isTest
    static void testFetchDefaultRecord() {
        // Test data setup
        Listing_hz__c listing = new Listing_hz__c();
        listing.Name = 'Test1';
        listing.Status__c = 'Active';
        listing.ListingType__c = 'Rental';
        listing.PropertyType__c = 'Apartment';
        listing.Bedrooms_hz__c = 2;
        listing.FullBathrooms_hz__c = 2;
        listing.ListingPrice_hz__c = 1000;
        listing.City_hz__c = 'Test';
        listing.State_hz__c = 'Test';      
        listing.City_Propertyfinder__c='Dubai';
        listing.Property_Propertyfinder__c='Socio Tower 2';
        listing.Propertyfinder_Region__c='Dubai - Dubai Hills Estate - Socio Tower - Socio Tower 2';
        listing.Sub_Community_Propertyfinder__c='Socio Tower';
        listing.Community_Propertyfinder__c='Dubai Hills Estate';  
        insert listing;


        // Call the method
        Test.startTest();
        List<SearchProperties__c> result = DubizzlePropertyFinder.fetchDefaultRecord(listing.Id);
        Test.stopTest();

        // Assert the result
        System.assertEquals(0, result.size(), 'Result should be empty for the provided listing Id');
    }

    @isTest
    static void testFetchDubizzleLocationtext() {
    SearchProperties__c searchProperty = new SearchProperties__c();
    searchProperty.Dubizzle_Locationtext__c = 'Dubizzle Location Text';
    insert searchProperty;

    Test.startTest();
    String result = DubizzlePropertyFinder.fetchDubizzleLocationtext(searchProperty.Id);
    Test.stopTest();

    System.assertEquals('Dubizzle Location Text', result, 'Result should match the Dubizzle Location Text');
}

@isTest
static void testUpdateRecordData() {
    Listing_hz__c listing = new Listing_hz__c();
    listing.Name = 'Test2';
    listing.Status__c = 'Active';
    listing.ListingType__c = 'Rental';
    listing.PropertyType__c = 'Apartment';
    listing.Bedrooms_hz__c = 2;
    listing.FullBathrooms_hz__c = 2;
    listing.ListingPrice_hz__c = 1000;
    listing.City_hz__c = 'Test';
    listing.State_hz__c = 'Test';      
    listing.City_Propertyfinder__c='Dubai';
    listing.Property_Propertyfinder__c='Socio Tower 2';
    listing.Propertyfinder_Region__c='Dubai - Dubai Hills Estate - Socio Tower - Socio Tower 2';
    listing.Sub_Community_Propertyfinder__c='Socio Tower';
    listing.Community_Propertyfinder__c='Dubai Hills Estate';  
    insert listing;

    SearchProperties__c searchProperty = new SearchProperties__c();
    searchProperty.Dubizzle_Locationtext__c = 'Dubizzle Location Text';
    insert searchProperty;

    Test.startTest();
    String result = DubizzlePropertyFinder.updateRecordData(listing.Id, 'Updated Location Text', 'Updated Record Name', searchProperty.Id);
    Test.stopTest();

    System.assertEquals('Record updated successfully', result, 'Record should be updated successfully');

    Listing_hz__c updatedListing = [SELECT Id, Building_Dubizzle__c, LocationText_Dubizzle__c, DubizzelProperty_Id__c FROM Listing_hz__c WHERE Id = :listing.Id LIMIT 1];
    System.assertEquals('Updated Record Name', updatedListing.Building_Dubizzle__c, 'Building should be updated');
    System.assertEquals('Updated Location Text', updatedListing.LocationText_Dubizzle__c, 'Location Text should be updated');
    System.assertEquals(searchProperty.Id, updatedListing.DubizzelProperty_Id__c, 'Dubizzel Property Id should be updated');
    }

}