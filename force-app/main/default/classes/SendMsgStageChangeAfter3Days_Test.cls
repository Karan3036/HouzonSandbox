@isTest
public class SendMsgStageChangeAfter3Days_Test {

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
        
            DateTime currenttime = system.now();
            Contact cc = New Contact();
            cc.LastName = 'Test';
            cc.MobilePhone = '+911234567891';
            cc.OwnerId = Userlist[0].Id;
            cc.Stage__c = 'Prospect';
            cc.Prospect_Time_Stamp__c = system.now();
            cc.LeadSource = 'Website';
           
            insert cc;
            cc.Prospect_Time_Stamp__c = currenttime.addMinutes(-4322);
            update cc;

            Test.setMock(HttpCalloutMock.class, new RestMock());
            Test.startTest();
            SendMsgStageChangeAfter3Days obj = new SendMsgStageChangeAfter3Days();
            DataBase.executeBatch(obj); 
            Test.stopTest();
        }  

    Static testMethod void test1(){

        String OId = userInfo.getUserId();
        
        List<User> Userlist = [Select Id,Name,Profile.Name,Email,WhatsApp_Message__c,WhatsApp_URL__c,MobilePhone From User where Id =: OId];
        if(Userlist.size()>0){

            Userlist[0].WhatsApp_Message__c= 'Yes';
            update Userlist;
            }

            DateTime currenttime = system.now();
            Contact cc = New Contact();
            cc.LastName = 'Test';
            cc.MobilePhone = '+911234567891';
            cc.OwnerId = Userlist[0].Id;
            cc.Stage__c = 'Contract Signed';
            cc.Contract_Signed_Time_Stamp__c = System.now();
            cc.LeadSource = 'Website';
            cc.OtherCity = 'Ahemdabad';
            cc.OtherCountry = 'India';
            cc.OtherPostalCode = '362012';
            cc.OtherState = 'Gujrat';
            cc.OtherStreet  = 'SG Hiway';
        
            insert cc;
            cc.Contract_Signed_Time_Stamp__c = currenttime.addMinutes(-4324);
            update cc;

            Test.setMock(HttpCalloutMock.class, new RestMock());
            Test.startTest();
            SendMsgStageChangeAfter3Days obj = new SendMsgStageChangeAfter3Days();
            DataBase.executeBatch(obj); 
            Test.stopTest();
        } 

    @isTest static void testMethod1(){
         
        SendMsgStageChangeAfter3DaysSchedular contactTaskSchedule = new SendMsgStageChangeAfter3DaysSchedular();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, contactTaskSchedule); 
    }  
    }