@isTest
    public class sendafter1hoursmsghowingenddt_Test {

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
    
            List<Contact> clist = new List<Contact>();
    
            for(integer i=1;i<=10;i++){
                Contact cc = New Contact();
                cc.FirstName = 'test';
                cc.LastName = 'Test'+i;

                cc.MobilePhone = '+91123456789'+i;
                cc.OwnerId = Userlist[0].Id;
                cc.LeadSource = 'Website';
                clist.add(cc);
            }
       
        insert clist;
    
        List<Event> eventlist = new List<Event>();
        for(Contact c : clist){
    
            DateTime currenttime = system.now();
            Event e = new Event();
            e.Description = 'This is test record.';
            e.StartDateTime = currenttime.addMinutes(48);
            e.EndDateTime =  currenttime.addMinutes(62);
            e.Location = 'Ahmedabad';
            e.WhoId = c.id;
            eventlist.add(e);
        }
        insert eventlist;
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
    
        sendafter1hoursmsghowingenddt obj = new sendafter1hoursmsghowingenddt();
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

        Contact cc = New Contact();
        cc.FirstName = null;
        cc.LastName = 'Test';
        cc.MobilePhone = '+91123456789';
        cc.OwnerId = userInfo.getUserId();
        cc.LeadSource = 'Website';
        insert cc;
        
        List<Event> eventlist1 = new List<Event>();
        
        DateTime currenttime = system.now();
        Event e1 = new Event();
        e1.Description = 'This is test record.';
        e1.StartDateTime = currenttime;
        e1.EndDateTime =  currenttime.addHours(3);
        e1.Location = 'Ahmedabad';
        e1.WhoId = cc.id;
        eventlist1.add(e1);
        
        Event e2 = new Event();
        e2.Description = 'This is test record.';
        e2.StartDateTime = currenttime.addHours(-4);
        e2.EndDateTime =  currenttime.addMinutes(-62);
        e2.Location = 'Ahmedabad';
        e2.WhoId = cc.id;
        eventlist1.add(e2);
        
        insert eventlist1;
        
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        
        sendafter1hoursmsghowingenddt obj1 = new sendafter1hoursmsghowingenddt();
        DataBase.executeBatch(obj1); 
                
        Test.stopTest();
        }

        @isTest static void testMethod1(){
         
            sendafter1hoursmsghowingenddtSchedual contactTaskSchedule = new sendafter1hoursmsghowingenddtSchedual();
            String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, contactTaskSchedule); 
        }  
    }