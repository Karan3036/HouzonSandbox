global class batchForCreateContactSendWP implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
    global final User currentOwner;
    global final User newOwner;
    global integer cnt=0;
    global  List<User> Userlist = new List<User>();
    global  List<Contact> con = new List<Contact>();
    global integer failedcnt=0;
    global String mobile1,msg1;
       
    global batchForCreateContactSendWP(List<Contact> newcon){
        con = newcon;
        Userlist = [Select Id,Name,Email,WhatsApp_Message__c,WhatsApp_URL__c,MobilePhone From User Where Id =:newcon[0].OwnerId];
        System.debug('Userlist::'+Userlist);
        System.debug('Name::'+Userlist[0].Name);
        System.debug('Email::'+Userlist[0].Email);
        System.debug('WhatsApp_URL__c::'+Userlist[0].WhatsApp_URL__c);
        System.debug('MobilePhone::'+Userlist[0].MobilePhone);
        System.debug('Name Contact::'+newcon[0].Name);
        String wplink;
        if(Userlist[0].WhatsApp_URL__c==null)
        {
            wplink='';
        }
        else{
            wplink='WhatsApp: '+Userlist[0].WhatsApp_URL__c + '\\n';
        }
        msg1 = 'Hi, 👋\\nThank you for contacting Maverick Realty.🤗 \\nOur agent '+Userlist[0].Name+' will contact to you shortly.\\n\\nAgent’s Details :\\nName:'+Userlist[0].Name+'\\nMobile: '+Userlist[0].MobilePhone+'\\n'+wplink+'E-Mail: '+Userlist[0].Email+'\\n\\nVisit our website to explore other exclusive properties in our portfolio and let us help you find the perfect home:\\n\\nhttps://www.maverickrealty.ae/properties\\n\\nMaverick Realty \\nOffice No 2003, Opal Tower \\nBusiness Bay, Dubai \\nPO BOX: 86236\\n\\nTel: + 971 4 457 9928 \\nwww.maverickrealty.ae \\ninfo@maverickrealty.ae';
    }    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug(Userlist);
        String aa=con[0].Id;
        system.debug(con);
        return Database.getQueryLocator('Select id,Name,MobilePhone  from Contact Where id =:aa');
    }    
    global void execute(Database.BatchableContext bc, List<Contact> con1){
        con1 = con;
        system.debug('con1:::'+con1);
        try{
            database.SaveResult[] ds=DAtabase.update(con1,false);
            for(database.SaveResult d:ds){
                System.debug('d-->'+d);
                if(d.issuccess()){
                    mobile1 = con1[0].MobilePhone;
                    //msg1 ='hello';
                }else{
                    failedcnt++;
                }
            }  
        }catch(Exception e){
            system.debug('update failed');
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
     }  
     
     global void finish(Database.BatchableContext bc){	
        system.debug('Finish Out Loop '+cnt);
        system.debug('Finish Out Loop mobile' +mobile1);
        system.debug('Finish Out Loop msg'+msg1);

        try{
            System.debug('mobile1::'+mobile1);
            System.debug('msg1::'+msg1);
            //mobile = mobile.substring(mobile + 1);
            mobile1 = mobile1.substring(1);
            System.debug('mobile1::'+mobile1);
            String Whats_App_Send_Api = system.label.Whats_App_Send_Api;
            String Send_Client_Secret = system.label.Send_Client_Secret; 
            Http http1 = new Http();
            HttpRequest req1= new HttpRequest();
            req1.setEndpoint(Whats_App_Send_Api);
            req1.setMethod('POST'); 
            req1.setHeader('Content-Type','application/json');
            String body1='{"number": "'+mobile1+'", "msg": "'+msg1+'","client_secret":"'+Send_Client_Secret+'"}';
            req1.setBody(body1);
            System.debug('body1::'+body1);
            HTTPResponse res1 = new http().send(req1);
            System.debug('status'+res1.getStatusCode());
            System.debug(res1.getBody());
        }
        catch ( System.CalloutException ex ) {
   
            System.debug( 'Error Message is ' + ex.getmessage() );
            system.debug( 'Line Number is ' + ex.getLineNumber() );
            system.debug( 'Stace Trace String is ' + ex.getStackTraceString() );
        }
    }
}