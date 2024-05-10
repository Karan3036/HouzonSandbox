//Issue with the What's app Integration



global class SendMsgStageChangeAfter3Days Implements Database.Batchable<sObject>,Database.AllowsCallouts{


    global Database.queryLocator start(Database.BatchableContext bc) {
     //String NewLead = 'New Lead'; 
     // String SOQL = 'select id,LastName,FirstName,MobilePhone,OwnerId,ContactType_hz__c,LastModifiedDate,New_Lead_Time_Stamp__c,Stage__c,CreatedDate,Owner.Name From Contact where Owner.Name <> \'Maverick Realty\' AND (Owner.Department=\'Sales\' OR Owner.Department=\'sales\') AND (ContactType_hz__c =\'Buyer\' OR ContactType_hz__c =\'Tenant\')';
     //Select id,Name,FirstName,Contract_Signed_Time_Stamp__c,MobilePhone,OwnerId,ContactType_hz__c,LastModifiedDate,New_Lead_Time_Stamp__c,Stage__c,CreatedDate,Prospect_Time_Stamp__c from contact where Owner.Name <> 'Maverick Realty' AND (Owner.Department='Sales' OR Owner.Department='sales') AND (ContactType_hz__c ='Buyer' OR ContactType_hz__c ='Tenant') AND (Stage__c='Prospect' OR Stage__c='Contract Signed')];
     String SOQL = 'Select id,Name,FirstName,Contract_Signed_Time_Stamp__c,Owner.WhatsApp_Message__c,Prospect_Time_Stamp__c,ContactType_hz__c,Owner.WhatsApp_URL__c,MobilePhone,Owner.Name,Owner.Department,Owner.FirstName,OwnerId,LastModifiedDate,New_Lead_Time_Stamp__c,Stage__c,CreatedDate from contact where Owner.WhatsApp_Message__c = \'Yes\' AND (Stage__c=\'Prospect\' OR Stage__c=\'Contract Signed\')';
     System.debug('Point#5 #6');
     return Database.getQueryLocator(SOQL);
    }

    global void execute(Database.BatchableContext bc, List<Contact> Conlist){  

    String mobile1,msg1; 
    String ownername; 
    String WhatsAppUrl;
    String ownerWPMessage;
    Long j;
    Long j1;
    Datetime time4 = System.now(); 
        for(Contact cc:Conlist){
           
            System.debug('Point#5');
            System.debug('Name::'+cc.OwnerId);
    		System.debug('CreatedDate::'+cc.CreatedDate);
            System.debug('ContactType_hz__c::'+cc.ContactType_hz__c);
            mobile1 = cc.MobilePhone;
            ownername = cc.Owner.Name;
            WhatsAppUrl = cc.Owner.WhatsApp_URL__c;
            ownerWPMessage = cc.Owner.WhatsApp_Message__c;
           
            
            if(cc.Prospect_Time_Stamp__c!=null){
                Datetime time3 = cc.Prospect_Time_Stamp__c ;
                j = ((integer)(time4.getTime()/(1000*60)) - (time3.getTime()/(1000*60)));
                System.debug('time3:::'+time3);
                System.debug('time4 :::'+time4);
                System.debug('j Value :::'+j);
                System.debug('Number::' +cc.MobilePhone);
                System.debug('Prospect_Time_Stamp__c different Minitus ::: '+j);
           }
			if(cc.Contract_Signed_Time_Stamp__c !=null){

                Datetime time5 = cc.Contract_Signed_Time_Stamp__c ;
            	System.debug('_________Point 5 _______________________________ :::');
                j1 = ((integer)(time4.getTime()/(1000*60)) - (time5.getTime()/(1000*60)));
                System.debug('j1 Value:::'+j1);
                System.debug('Number::' +cc.MobilePhone);
           }
           System.debug('j ::: '+j);
           System.debug('Stage :: ' +cc.Stage__c);
           if(((j>=4320 && j<4325) || (j>=12960 && j<12965)) && cc.Stage__c == 'Prospect')
           {   
               System.debug('_________Point 6  ::: ___________');
               if(ownerWPMessage == 'Yes'){
                       
                       mobile1 = mobile1.substring(1);
                       System.debug('mobile1::'+mobile1);
                           if(cc.FirstName==null){
                               cc.FirstName ='';
                           }
                       String msg2='Hello '+cc.FirstName+',\\n'+ownername+' from Maverick added an update regarding your enquiry: \\nStart Chat: ' +WhatsAppUrl+'\\nHave you had the chance to explore our website that has all the recent Dubai property sale transactions data \\nhttps://www.maverickrealty.ae/dubai-transactions/\\n*Payments Disclaimer*, kindly visit: https://rb.gy/youpua';
                       System.debug('message ::: ' +msg2);
                       String Whats_App_Send_Api = system.label.Whats_App_Send_Api;
                       String Send_Client_Secret = system.label.Send_Client_Secret; 
                       Http http1 = new Http();
                       HttpRequest req1= new HttpRequest();
                       req1.setEndpoint(Whats_App_Send_Api);
                       req1.setMethod('POST'); 
                       req1.setHeader('Content-Type','application/json');
                       String body1='{"number": "'+mobile1+'", "msg": "'+msg2+'","client_secret":"'+Send_Client_Secret+'"}';
                       req1.setBody(body1);
                       HTTPResponse res1 = new http().send(req1);
                       System.debug('status'+res1.getStatusCode());
                   }
               System.debug('Fire:::');
            }

           //Point 6

           if(j1>=4320 && j1<=4325 && cc.Stage__c == 'Contract Signed')
           {   
            System.debug('_________Point 5  ::: ___________');
                   if(ownerWPMessage == 'Yes'){
                       
                       mobile1 = mobile1.substring(1);
                       System.debug('mobile1::'+mobile1);
                           if(cc.FirstName==null){
                               cc.FirstName ='';
                           }
                       String msg2='Hello '+cc.FirstName+' \\n\\nThank you for doing business with us. If you had a positive experience kindly rate our services by using the below link:\\n\\nhttps://www.maverickrealty.ae/client-feedback/ \\n\\nIn case you have encountered any issues feel free to email us your concern on info@maverickrealty.ae and we will do our best to resolve it as soon as possible.';
                       System.debug('message ::: ' +msg2);
                       String Whats_App_Send_Api = system.label.Whats_App_Send_Api;
                       String Send_Client_Secret = system.label.Send_Client_Secret; 
                       Http http1 = new Http();
                       HttpRequest req1= new HttpRequest();
                       req1.setEndpoint(Whats_App_Send_Api);
                       req1.setMethod('POST'); 
                       String token1='ac00d5a659bf3483dd72';
                       req1.setHeader('Content-Type','application/json');
                       String body1='{"number": "'+mobile1+'", "msg": "'+msg2+'","client_secret":"'+Send_Client_Secret+'"}';
                       req1.setBody(body1);
                       HTTPResponse res1 = new http().send(req1);
                       System.debug('status'+res1.getStatusCode());
                   }
               System.debug('Fire:::');
           }
        }
    }

 global void finish(Database.BatchableContext bc){
     
  }

}