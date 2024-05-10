@isTest
private class HZ_Email_ServicesTest {

    @isTest
    static void testHandleInboundEmail() {
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        Messaging.InboundEmail testEmail2 = new Messaging.InboundEmail();
        testEmail.subject = 'propertyfinder.ae - Contact HOUZON REAL ESTATE BROKER L.L.C';
        testEmail.plainTextBody = 'Test plain text body for propertyfinder.ae email';

        testEmail2.subject = 'Other Email';
        testEmail2.plainTextBody = 'Test plain text body for propertyfinder.ae email';

        Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        Messaging.InboundEmailResult result = emailService.handleInboundEmail(testEmail, testEnvelope);
        Messaging.InboundEmailResult result2 = emailService.handleInboundEmail(testEmail2, testEnvelope);
        Test.stopTest();
        
        System.assertNotEquals(null, result);


    }

    @isTest
    static void testPropertyfinderContactCreation() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+919326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        String testEmailBody = 'Dear Vansh Mehra,\nTest User\ntest has sent you a message regarding your property\n3,500,000 AED -  Apartment - 2 3  -  1,660 sqft\nModern 2BR + Maid | Burj View | Direct Buyers Only\nHOUZON is proud to present this luxurious two apartment for sale in City Walk, Dubai. Multiple units...\nReference: VM-CW-2BR-00013\nAgent: Vansh Mehra';

        
        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.propertyfinderContactCreation(testEmailBody);
        Test.stopTest();
    }

    @isTest
    static void testNewLeadContactCreation() {
        String testEmailBody = 'Dear Vansh Mehra,\ntest has sent you a message regarding your property\n3,500,000 AED -  Apartment - 2 3  -  1,660 sqft\nModern 2BR + Maid | Burj View | Direct Buyers Only\nHOUZON is proud to present this luxurious two apartment for sale in City Walk, Dubai. Multiple units...\nReference: VM-CW-2BR-00013\nAgent: Vansh Mehra';


        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.newLeadContactCreation(testEmailBody);
        Test.stopTest();
    }

    @isTest
    static void testMissedCallContactCreation() {
        String testEmailBody = 'Dear Vansh Mehra,\ntest has sent you a message regarding your property\n3,500,000 AED -  Apartment - 2 3  -  1,660 sqft\nModern 2BR + Maid | Burj View | Direct Buyers Only\nHOUZON is proud to present this luxurious two apartment for sale in City Walk, Dubai. Multiple units...\nReference: VM-CW-2BR-00013\nAgent: Vansh Mehra';


        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.missedCallContactCreation(testEmailBody);
        Test.stopTest();
    }

    @isTest
    static void testCallSummaryContactCreation() {
        String testEmailBody = 'Dear Vansh Mehra,\ntest has sent you a message regarding your property\n3,500,000 AED -  Apartment - 2 3  -  1,660 sqft\nModern 2BR + Maid | Burj View | Direct Buyers Only\nHOUZON is proud to present this luxurious two apartment for sale in City Walk, Dubai. Multiple units...\nReference: VM-CW-2BR-00013\nAgent: Vansh Mehra';

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.callSummaryContactCreation(testEmailBody);
        Test.stopTest();

    }

    @isTest
    static void testLeadNotificationContactCreation() {
        String testEmailBody = 'Dear Vansh Mehra,\ntest has sent you a message regarding your property\n3,500,000 AED -  Apartment - 2 3  -  1,660 sqft\nModern 2BR + Maid | Burj View | Direct Buyers Only\nHOUZON is proud to present this luxurious two apartment for sale in City Walk, Dubai. Multiple units...\nReference: VM-CW-2BR-00013\nAgent: Vansh Mehra';

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.LeadNotificationContactCreation(testEmailBody);
        Test.stopTest();

    }

    @isTest
    static void testCreateInquiryAndLinkListing() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;

        // Create test data
        Listing_hz__c testListing = new Listing_hz__c(Name = 'Test Listing', Broker_s_Listing_ID__c = 'Test123',property_category__c='Residential');
        insert testListing;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;

        HZ_Email_Services emailService = new HZ_Email_Services();
        // Call the method
        Test.startTest();
        emailService.createInquiryAndLinkListing('Test123', new List<Contact>{testContact});
        Test.stopTest();

}
}