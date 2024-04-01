@isTest
private class ListingMatchingControllerTest {
    @isTest
    static void testGetContacts() {
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        for(Integer i = 0; i < 5; i++) {
            testContacts.add(new Contact(
                FirstName = 'TestFirst' + i,
                LastName = 'TestLast' + i,
                Phone = '123456789' + i,
                Email = 'test' + i + '@example.com',
                LeadSource = 'Web'
            ));
        }
        insert testContacts;

        ListingMatchingController.FilterCriteria filter = new ListingMatchingController.FilterCriteria();
        filter.field = 'LastName';
        filter.criteria = '=';
        filter.inputValue = 'TestLast1';
        List<ListingMatchingController.FilterCriteria> filters = new List<ListingMatchingController.FilterCriteria>{filter};

        Test.startTest();
        ListingMatchingController.PaginationWrapper result = ListingMatchingController.getContacts(1, 5, filters);
        Test.stopTest();

    }
    
    @isTest
    static void testGetContactFields() {
        Test.startTest();
        List<String> fields = ListingMatchingController.getContactFields();
        Test.stopTest();

        System.assertNotEquals(0, fields.size(), 'No contact fields retrieved');
        System.assert(fields.contains('FirstName'), 'FirstName field not found');

    }

    @isTest
    static void testCreateLinkedListing() {
        Contact testContact = new Contact(
            FirstName = 'TestFirst',
            LastName = 'TestLast',
            Phone = '123456789',
            Email = 'test@example.com',
            LeadSource = 'Web'
        );
        insert testContact;

        Test.startTest();
        ListingMatchingController.createLinkedListing(new List<Id>{testContact.Id});
        Test.stopTest();

        List<LinkedListing_hz__c> linkedListings = [SELECT Id FROM LinkedListing_hz__c WHERE Contact__c = :testContact.Id];
        System.assertEquals(1, linkedListings.size(), 'LinkedListing record not created');

    }
}