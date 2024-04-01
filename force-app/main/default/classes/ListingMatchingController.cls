public with sharing class ListingMatchingController {
    
    public class FilterCriteria {
        @AuraEnabled
        public String field;
        @AuraEnabled
        public String criteria;
        @AuraEnabled
        public String inputValue;
    }

    @AuraEnabled(cacheable =true)
    public static List<Contact> getAllContacts(){
        try {
            List<Contact> conList = new List<Contact>();

            conList = [SELECT Id, Name, FirstName, LastName, Phone, Email, LeadSource FROM Contact];
            return conList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable=true)
    public static PaginationWrapper getContacts(Integer pageNumber, Integer pageSize, List<FilterCriteria> filters) {
        PaginationWrapper result = new PaginationWrapper();
        try {
            Integer offset = (pageNumber - 1) * pageSize;
            String query = 'SELECT Id, Name, FirstName, LastName, Phone, Email, LeadSource FROM Contact';
            
            if (filters != null && !filters.isEmpty()) {
                query += ' WHERE ';
                for (Integer i = 0; i < filters.size(); i++) {
                    FilterCriteria filter = filters[i];
                    if (i > 0) {
                        query += ' AND ';
                    }
                    query += filter.field + ' ' + filter.criteria + ' \'' + filter.inputValue + '\'';
                }
            }
            
            query += ' LIMIT :pageSize OFFSET :offset';
            
            List<Contact> contacts = Database.query(query);
            result.contacts = contacts;
            
            result.totalRecords = [SELECT count() FROM Contact];
        } catch(Exception e) {
            System.debug('Error fetching contacts: ' + e.getMessage());
            throw new AuraHandledException('Error fetching contacts: ' + e.getMessage());
        }
        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getContactFields() {
        List<String> fieldListWithAPIName = new List<String>();
    
        // Describe the Contact object
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = globalDescribe.get('Contact');
        Schema.DescribeSObjectResult describeResult = objectType.getDescribe();
    
        // Get all fields for the Contact object
        Map<String, Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
    
        // Extract field API names and types and add them to the list
        for (String fieldName : fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            // Check if the field is not a formula field
            if (!fieldDescribe.isCalculated()) {
                String fieldType = String.valueOf(fieldDescribe.getType());
                String fieldWithAPIName = fieldDescribe.getName();
                fieldListWithAPIName.add(fieldWithAPIName);
            }
        }
    
        return fieldListWithAPIName;
    }        

    // Method to create linked listing records
    @AuraEnabled
    public static void createLinkedListing(List<Id> contactIds) {
        try {
            List<LinkedListing_hz__c> linkedListingsToInsert = new List<LinkedListing_hz__c>();
            List<Listing_hz__c> listingsToInsert = new List<Listing_hz__c>();
            List<Inquiry_hz__c> inquiriesToInsert = new List<Inquiry_hz__c>();
            
            // Create Listing record
            Listing_hz__c listing = new Listing_hz__c(
                Name = 'test',
                Listing_Agent_Firstname__c = 'test agent',
                Listing_Agent_Lastname__c = 'agent last',
                Listing_Agent_Phone__c = '1236534',
                Listing_Agent_Email__c = 'test@gmail.com',
                property_category__c='Commercial'
            );
            listingsToInsert.add(listing);
            
            insert listingsToInsert;

            // Create Inquiry record
            Inquiry_hz__c inquiry = new Inquiry_hz__c(
                Listing__c = listing.Id
                );
                inquiriesToInsert.add(inquiry);

                insert inquiriesToInsert;
            for (Id contactId : contactIds) {
                // Create Linked Listing record and relate it to Listing and Inquiry records
                LinkedListing_hz__c linkedListing = new LinkedListing_hz__c(
                    Contact__c = contactId,
                    Listing_hz__c = listing.Id,
                    Inquiry_hz__c = inquiry.Id
                );
                linkedListingsToInsert.add(linkedListing);
            }
            insert linkedListingsToInsert;

        } catch(Exception e) {
            System.debug('Error creating Linked Listing: ' + e.getMessage());
            throw new AuraHandledException('Error creating Linked Listing: ' + e.getMessage());
        }
    }

    public class PaginationWrapper {
        @AuraEnabled
        public List<Contact> contacts;
        @AuraEnabled
        public Integer totalRecords;
    }
}