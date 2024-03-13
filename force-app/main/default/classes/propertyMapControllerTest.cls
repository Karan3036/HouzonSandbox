@isTest
public with sharing class propertyMapControllerTest {
    
    static testMethod void testPropertyMapController() {
        // Create test data for Listing object
        Listing_hz__c testListing = new Listing_hz__c(
            
            Name = 'Test Listing',
            Latitude_hz__c = '37.7749',
            Longitude_hz__c = '-122.4194',
            Address_hz__c = '123 Test St',
            Building_Dubizzle__c = 'Test Building'
        );
        insert testListing;

        propertyMapController.propertyMapController('Listing_hz__c',testListing.Id);
    }
}