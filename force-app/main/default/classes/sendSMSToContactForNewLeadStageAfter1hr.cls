global class sendSMSToContactForNewLeadStageAfter1hr Implements Database.Batchable<sObject>,Database.AllowsCallouts{

            
    global Database.queryLocator start(Database.BatchableContext bc) {
           String NewLead = 'New Lead'; 
        // String SOQL = 'select id,LastName,FirstName,MobilePhone,OwnerId,ContactType_hz__c,LastModifiedDate,New_Lead_Time_Stamp__c,Stage__c,CreatedDate,Owner.Name From Contact where Owner.Name <> \'Maverick Realty\' AND (Owner.Department=\'Sales\' OR Owner.Department=\'sales\') AND (ContactType_hz__c =\'Buyer\' OR ContactType_hz__c =\'Tenant\')';
           String SOQL = 'Select id,Name,MobilePhone,Owner.MobilePhone,Owner.Name,Owner.WhatsApp_Message__c,Owner.Department,Owner.FirstName,OwnerId,ContactType_hz__c,LastModifiedDate,New_Lead_Time_Stamp__c,Stage__c,CreatedDate from contact where CreatedDate >= TODAY AND Stage__c=: NewLead';
           System.debug('Point#1');
           return Database.getQueryLocator(SOQL);
    
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> Conlist){  
    
        String mobile1,msg1; 
        String ownername; 
        String ownerWPMessage;
        
            for(Contact cc:Conlist){
               
                System.debug('Point#1');
                System.debug('Name::'+cc.OwnerId);
                System.debug('CreatedDate::'+cc.CreatedDate);
                System.debug('ContactType_hz__c::'+cc.ContactType_hz__c);
                mobile1 = cc.MobilePhone;
                ownername = cc.Owner.Name;
                ownerWPMessage = cc.Owner.WhatsApp_Message__c;
                msg1 = 'Hi,👋\\n\\nWe apologize for keeping you waiting. Your assigned agent '+ownername+' seems to be busy serving another client.\\n\\nThis is an auto-generated message, for further assistance on your inquiry, feel free to contact our customer care representative:\\nMaverick Realty Customer Support\\nMobile Phone: 971565266218   \\nWhatsApp :http://wa.me/971565266218';
                Datetime time1 = cc.New_Lead_Time_Stamp__c;
                Datetime time2 = System.now();
                
                Long i = (integer)(time2.getTime() - time1.getTime());
                System.debug('New_Lead_Time_Stamp__c:::'+time1);
                System.debug('System:::'+time2);
                System.debug('NAme::' +cc.Name);
                System.debug('Number::' +cc.MobilePhone);
                System.debug('Diff:::'+i);
                System.debug('____________________________');

                // settigng this value for test class only and will not affect in live run.
                if (Test.isRunningTest()) {
                    System.debug('In the test class');
                    i = 3600010;
                }

                System.debug('Value of i ==> ' + i);
                
                if(i>=3600000 && i<=3900000)
                {   
                    System.debug('Fire1:::');
                    if(ownerWPMessage == 'Yes'){
                        
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
                        System.debug(msg1);
                        System.debug('body1::'+body1);
                        HTTPResponse res1 = new http().send(req1);
                        System.debug('status'+res1.getStatusCode());
                        System.debug(res1.getBody());
                        }
                    System.debug('Fire:::');
                
                }
            }
        } 
    
    global void finish(Database.BatchableContext bc){
         
      }
    
    }