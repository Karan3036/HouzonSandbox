public class DubizzlePropertyFinder {
       // Method to fetch lookup search result   
       @AuraEnabled(cacheable=true)
       public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName) {    
           List < sObject > returnList = new List < sObject > ();
           string sWildCardText = '%' + searchKey + '%';
           string sQuery = 'Select Id,CityName__c,CommunityName__c,SubcommunityName__c,PropertyName__c,SearchPropertiesFormula__c,Dubizzle_Building_name__c From ' + sObjectApiName + ' Where Dubizzle_Building_name__c	 Like : sWildCardText order by createdDate';
           for (sObject obj: database.query(sQuery)) {
               returnList.add(obj);
           }
           return returnList;
       }
       
     
       //Method to get the default record from PropertyFinder
       @AuraEnabled
       public static List<SearchProperties__c> fetchDefaultRecord(String recId) {
        try{
            System.debug('recId>>'+recId);
            List<Listing_hz__c> listinglst = [SELECT Id,DubizzelProperty_Id__c,Building_Dubizzle__c,LocationText_Dubizzle__c FROM Listing_hz__c WHERE ID=:recId];
            List<SearchProperties__c> searchproplst = [SELECT Id,Dubizzle_Building_name__c,Dubizzle_Locationtext__c FROM SearchProperties__c WHERE ID=:listinglst[0].DubizzelProperty_Id__c];
            return searchproplst;
            }catch(Exception e){
                System.debug('Exception -->>'+e);
                return null;
            }
       }

       @AuraEnabled(cacheable=true)
       public static String fetchDubizzleLocationtext(String PropertyId) {
           try {
               List<SearchProperties__c> searchPropertiesList = [SELECT Id, Dubizzle_Locationtext__c FROM SearchProperties__c WHERE Id = :PropertyId LIMIT 1];
               
               if (searchPropertiesList != null && !searchPropertiesList.isEmpty()) {
                   return searchPropertiesList[0].Dubizzle_Locationtext__c;
               }
           } catch (Exception e) {
               System.debug('Exception -->>' + e);
           }
           return null;
       }

    @AuraEnabled
    public static String updateRecordData(String recordId, String dubizzleLocationtext, String selectedRecordName,String SearchPropertyId) {
        try {
            Listing_hz__c recordToUpdate = [SELECT Id, Name,City_Dubizzle__c,Building_Dubizzle__c,LocationText_Dubizzle__c,Dubizzle_Region__c,SearchPropertyId__c FROM Listing_hz__c WHERE Id = :recordId LIMIT 1];

            recordToUpdate.Building_Dubizzle__c = selectedRecordName;
            recordToUpdate.LocationText_Dubizzle__c = dubizzleLocationtext;
            recordToUpdate.DubizzelProperty_Id__c = SearchPropertyId;
            update recordToUpdate;

            return 'Record updated successfully';
        } catch (Exception e) {
            return 'Error updating record: ' + e.getMessage();
        }
    }

     
 }