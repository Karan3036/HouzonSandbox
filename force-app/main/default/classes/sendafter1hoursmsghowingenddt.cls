global class sendafter1hoursmsghowingenddt Implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{

        
global Database.queryLocator start(Database.BatchableContext bc) {
    
    String SOQL = 'Select id,EndDateTime,WhoId, Who.Name from Event where WhoId != null';
    return Database.getQueryLocator(SOQL);
}
global void execute(Database.BatchableContext bc, List<Event> Eventlist){  
    
    System.debug('____Showing End Time Afetr ! Hours Send MEssage _____');

    String mobile1,msg1; 
    String eventConOwnerName;
    String ownerWPMessage;
    String eventConFirstName;
    String userdepartment;
    String contactType;
    Set<Id> conSetId = new Set<Id>();
    Map<Id,List<Event>> relatedConEventsMap = new Map<Id,List<Event>>(); 
  
  for(Event e : Eventlist){
    conSetId.add(e.WhoId);
  }

  Map<Id,Contact> conMap = new Map<Id,Contact>([Select id,FirstName,Owner.WhatsApp_Message__c,MobilePhone,Owner.Name,Owner.FirstName,Owner.WhatsApp_URL__c,ContactType_hz__c from Contact where Id =: conSetId]);
   
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
    ownerWPMessage = conMap.get(e.WhoId).Owner.WhatsApp_Message__c;
    eventConFirstName = conMap.get(e.WhoId).FirstName;
    system.debug('contmobile::::'+mobile1);

            Datetime time1 = e.EndDateTime;
            DateTime now1 = DateTime.now();
            //Long time2 = time1.getTime()/(1000*60);
            System.debug('start Time  ::: '+time1);
            String s = time1.format('HH:mm:ss');
            System.debug('Currunt time :: '+now1);
            Long l = (now1.getTime()- time1.getTime())/(1000*60);
            System.debug('Diffrant'+l);
            System.debug('_____________Event for__________________');

                if(l>=60 && l<65)
                {
                    if(eventConFirstName == null){
                        eventConFirstName = '';
                }
                msg1 = 'Hello '+eventConFirstName+',👋 \\n\\nWe believe that the meeting with our property consultant '+eventConOwnerName+' went successful.If you wish to explore other similar options which are exclusive with us kindly visit our website and we will be happy to serve you again. \\n\\nwww.maverickrealty.ae/properties. \\n\\nHow was your experience with our property advisor? You can reply by typing from 1 to 5 as indicated below. \\n\\n1 ==> Terrible\\n2 ==> Bad\\n3 ==> Average\\n4 ==> Good\\n5 ==> Excellent';
                
                System.debug('Fire1:::');
                if(ownerWPMessage == 'Yes'){
                    
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