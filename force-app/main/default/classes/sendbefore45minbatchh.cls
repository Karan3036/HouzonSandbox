global class sendbefore45minbatchh Implements Database.Batchable<sObject>,Database.AllowsCallouts{
   
    // global  List<Contact> con = new List<Contact>();
     
global Database.queryLocator start(Database.BatchableContext bc) {
     
   // String SOQL = 'select id,LastName,FirstName,MobilePhone,OwnerId,ContactType_hz__c,LastModifiedDate,New_Lead_Time_Stamp__c,Stage__c,CreatedDate,Owner.Name From Contact where Owner.Name <> \'Maverick Realty\' AND (Owner.Department=\'Sales\' OR Owner.Department=\'sales\') AND (ContactType_hz__c =\'Buyer\' OR ContactType_hz__c =\'Tenant\')';
    String SOQL = 'Select id,StartDateTime,WhoId, Who.Name from Event where WhoId != null';
    return Database.getQueryLocator(SOQL);
}
global void execute(Database.BatchableContext bc, List<Event> Eventlist){  
     System.debug('before45Minitus____');

     String mobile1,msg1; 
     String eventConOwnerName;
     String eventConFirstName;
     System.debug('eventConFirstName ::: '+eventConFirstName);
     String ownerWPMessage;
     Set<Id> conSetId = new Set<Id>();
     Map<Id,List<Event>> relatedConEventsMap = new Map<Id,List<Event>>(); 
   
   for(Event e : Eventlist){
     conSetId.add(e.WhoId);
   }

   Map<Id,Contact> conMap = new Map<Id,Contact>([Select id,FirstName,Owner.WhatsApp_Message__c,MobilePhone,Owner.Name,Owner.FirstName,Owner.WhatsApp_URL__c from Contact where Id =: conSetId]);
   for(Event e : Eventlist){
       
       if(relatedConEventsMap.containsKey(e.WhoId) && e.WhoId != null){
           List<Event> elist = relatedConEventsMap.get(e.WhoId);
           elist.add(e);
           relatedConEventsMap.put(e.WhoId, elist);
       }else{
         relatedConEventsMap.put(e.WhoId,new List<Event>{e});
       }      
     }

 for(Event e : Eventlist){

     mobile1= conMap.get(e.WhoId).MobilePhone;
     eventConOwnerName = conMap.get(e.WhoId).Owner.Name;
     eventConFirstName = conMap.get(e.WhoId).FirstName;
     System.debug('eventConFirstName ::: '+eventConFirstName);
     ownerWPMessage = conMap.get(e.WhoId).Owner.WhatsApp_Message__c;

     system.debug('contmobile::::'+mobile1);

             Datetime time1 = e.StartDateTime;
             DateTime now1 = DateTime.now();
             //Long time2 = time1.getTime()/(1000*60);
             System.debug('start Time  ::: '+time1);
             String s = time1.format('HH:mm a');
             System.debug('Currunt time :: '+now1);
             Long l = (time1.getTime()- now1.getTime())/(1000*60);
             System.debug('Diffrant'+l);
             System.debug('_____________Event for__________________');

             if(l>=45 && l<50)
                     {
                         if(conMap.get(e.WhoId).FirstName == null){
                             eventConFirstName = '';
                     }

                     msg1 = 'Hello '+eventConFirstName+',👋 \\n\\nThis is an auto-generated reminder message that your property viewing appointment with our property consultant '+eventConOwnerName+' is scheduled at: '+s+'. \\n\\nIn case you wish to re-schedule it, kindly contact the property advisor directly.If this message was sent to you in error, kindly reach out to our office directly on +971565266218 in order to avoid any confusions.';
                                 System.debug('Fire1:::');
                                 if(ownerWPMessage == 'Yes')
                                 {
                                     mobile1 = mobile1.substring(1);
                                     System.debug('mobile1::'+mobile1);
                                     String Whats_App_Send_Api = system.label.Whats_App_Send_Api;
                                     String Send_Client_Secret = system.label.Send_Client_Secret; 
                                     Http http1 = new Http();
                                     HttpRequest req1= new HttpRequest();
                                     System.debug('whTasmsebd');
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
                               }
                             }
                         } 
     global void finish(Database.BatchableContext bc){
 }
}