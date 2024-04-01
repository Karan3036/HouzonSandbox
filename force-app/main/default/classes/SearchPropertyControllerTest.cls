/**
 ** Title : SearchPropertyControllerTest
 *
 ** @author : Harsh Shah
 * @version 1.0
 * @description : Test class for SearchPropertyController
 * @uses
 *! @history : None
 ** 		yyyy-mm-dd : 11th March, 2024
 */
@isTest
public with sharing class SearchPropertyControllerTest {
    @isTest
    static void testFetchLookupData() {
        String searchKey = 'Test';
        String sObjectApiName = 'SearchProperties__c';

        Test.startTest();
        List<sObject> result = SearchPropertyController.fetchLookupData(searchKey, sObjectApiName);
        Test.stopTest();

        System.assertEquals(0, result.size(), 'Result should be empty for the provided search key');
    }

    @isTest
    static void testUpdateListingsValue() {
       

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
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        insert listingRecord1;

        Test.startTest();
        SearchPropertyController.updateListingsValue(listingRecord1.Id, listingRecord1);
        Test.stopTest();
        listingRecord1 = [SELECT Sub_Community_Propertyfinder__c FROM Listing_hz__c WHERE Id = :listingRecord1.Id];
        System.assertNotEquals(null, listingRecord1.Sub_Community_Propertyfinder__c, 'Sub Community should not be null after update');
    }

    @isTest
    static void testFetchDefaultRecord() {
       

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
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        insert listingRecord1;


        Test.startTest();
        List<SearchProperties__c> result = SearchPropertyController.fetchDefaultRecord(listingRecord1.Id);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Result should be empty for the provided listing Id');
    }
}