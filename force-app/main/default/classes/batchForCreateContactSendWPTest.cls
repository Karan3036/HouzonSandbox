@isTest 
public class batchForCreateContactSendWPTest {
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

    Static testMethod void test(){

        String OId = userInfo.getUserId();
    
        List<User> Userlist = [Select Id,Name,Profile.Name,Email,WhatsApp_Message__c,WhatsApp_URL__c,MobilePhone From User where Id =: OId];
        if(Userlist.size()>0){

        Userlist[0].WhatsApp_Message__c= 'Yes';
        update Userlist;
        }

        Contact cc = New Contact();
        cc.FirstName = 'test';
        cc.LastName = 'Test';
        cc.MobilePhone = '+91123456789';
        cc.OwnerId = Userlist[0].Id;
        cc.LeadSource = 'Website';
        insert cc;

            
 
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();

        batchForCreateContactSendWP obj = new batchForCreateContactSendWP(new List<Contact>{cc});
        DataBase.executeBatch(obj); 
                
        Test.stopTest();
    }
}