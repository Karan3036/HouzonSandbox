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
        String testEmailBody = 'Test email body for propertyfinder.ae email';
        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.propertyfinderContactCreation(testEmailBody);
        Test.stopTest();
    }

    @isTest
    static void testNewLeadContactCreation() {
        String testEmailBody = 'Test email body for Bayut New Lead email';

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.newLeadContactCreation(testEmailBody);
        Test.stopTest();
    }

    @isTest
    static void testMissedCallContactCreation() {
        String testEmailBody = 'Test email body for Missed Call email';

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.missedCallContactCreation(testEmailBody);
        Test.stopTest();
    }

    @isTest
    static void testCallSummaryContactCreation() {
        String testEmailBody = 'Test email body for Call Summary email';

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.callSummaryContactCreation(testEmailBody);
        Test.stopTest();

    }

    @isTest
    static void testLeadNotificationContactCreation() {
        String testEmailBody = 'Test email body for Bayut Lead Notification email';

        HZ_Email_Services emailService = new HZ_Email_Services();

        Test.startTest();
        emailService.LeadNotificationContactCreation(testEmailBody);
        Test.stopTest();

    }
}