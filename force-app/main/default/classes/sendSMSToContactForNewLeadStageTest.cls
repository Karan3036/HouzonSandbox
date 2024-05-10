@isTest
public  class sendSMSToContactForNewLeadStageTest {

    private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'Hi, 👋 Test';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }


    static testmethod void testBatchExecution() {

        String OId = userInfo.getUserId();
        
        List<User> Userlist = [Select Id,Name,Profile.Name,Email,WhatsApp_Message__c,WhatsApp_URL__c,MobilePhone From User where Id =: OId];
        if(Userlist.size()>0){

            Userlist[0].WhatsApp_Message__c= 'Yes';
            update Userlist;
            }

        // Test data setup
        List<Contact> testContacts = new List<Contact>();

        Contact newLeadWithin1Hour = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            MobilePhone = '1234567890',
            OwnerId = UserInfo.getUserId(),
            ContactType_hz__c = 'Buyer',
            Stage__c = 'New Lead',
            New_Lead_Time_Stamp__c = Datetime.now().addHours(-1)
        );
        testContacts.add(newLeadWithin1Hour);


        // Insert the test data
        insert testContacts;
        
        
        Test.setMock(HttpCalloutMock.class, new RestMock());
     
    

        Test.startTest();
        // Execute the batch job
        sendSMSToContactForNewLeadStageAfter1hr batchInstance = new sendSMSToContactForNewLeadStageAfter1hr();
        Database.executeBatch(batchInstance);
        Test.stopTest();

      
    }

}