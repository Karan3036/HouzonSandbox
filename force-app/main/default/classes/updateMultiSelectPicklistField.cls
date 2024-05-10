public class updateMultiSelectPicklistField {
    public static void updateMSelectPickField (Contact[] Contact1){
        for(Contact c: Contact1){        
            String pickValuesStr;

			if(!String.isBlank(c.ContactType_hz__c)){
                System.Debug('Contact Type is not Blank');
                
				List<String> pickValues = c.ContactType_hz__c.split(';');
				for(String str : pickValues){
					if(String.isBlank(pickValuesStr)){
						pickValuesStr = str;
					}
					else{
						pickValuesStr = pickValuesStr + '; ' + str;
					}
				}
			}
            
			c.Contact_Type_Multiselect_to_Text__c = pickValuesStr;
           // if(Trigger.IsUpdate){
            	if(c.Stage__c == 'Disqualified' && c.Reason_for_Lead_Disqualification__c == 'Agent'){
                    c.ContactType_hz__c	= 'Real Estate Broker';
                }    
            //}
            
        }
    }
}