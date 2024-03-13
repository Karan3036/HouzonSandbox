public class SearchPropertyController {

       // Method to fetch lookup search result   
       @AuraEnabled(cacheable=true)
       public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName) {    
           List < sObject > returnList = new List < sObject > ();
           string sWildCardText = '%' + searchKey + '%';
           string sQuery = 'Select Id,CityName__c,CommunityName__c,SubcommunityName__c,PropertyName__c,SearchPropertiesFormula__c From ' + sObjectApiName + ' Where SearchPropertiesFormula__c Like : sWildCardText order by createdDate';
           for (sObject obj: database.query(sQuery)) {
               returnList.add(obj);
           }
           return returnList;
       }
       
       //Method to update the listing record values from PropertyFinder
       @AuraEnabled
       public static void updateListingsValue(String recId,Listing_hz__c listin) {
          try{
            List<Listing_hz__c> listinglst = [SELECT Id,Sub_Community_Propertyfinder__c,City_Propertyfinder__c,Community_Propertyfinder__c,Property_Propertyfinder__c,
            Propertyfinder_Region__c FROM Listing_hz__c WHERE ID=:recId];
            if(String.isNotBlank(listin.Sub_Community_Propertyfinder__c))
                listinglst[0].Sub_Community_Propertyfinder__c   = listin.Sub_Community_Propertyfinder__c;
            if(String.isNotBlank(listin.City_Propertyfinder__c))
                listinglst[0].City_Propertyfinder__c            = listin.City_Propertyfinder__c;
            if(String.isNotBlank(listin.Community_Propertyfinder__c))
                listinglst[0].Community_Propertyfinder__c       = listin.Community_Propertyfinder__c;
            if(String.isNotBlank(listin.Property_Propertyfinder__c))
                listinglst[0].Property_Propertyfinder__c        = listin.Property_Propertyfinder__c;
            if(String.isNotBlank(listin.Propertyfinder_Region__c))
                listinglst[0].Propertyfinder_Region__c          = listin.Propertyfinder_Region__c;
            if(String.isNotBlank(listin.SearchPropertyId__c))
            listinglst[0].SearchPropertyId__c   = listin.SearchPropertyId__c;
            update listinglst;
          }catch(Exception e){
            System.debug('Exception -->>'+e);
          }
       }

       //Method to get the default record from PropertyFinder
       @AuraEnabled
       public static List<SearchProperties__c> fetchDefaultRecord(String recId) {
        try{
            List<Listing_hz__c> listinglst = [SELECT Id,SearchPropertyId__c FROM Listing_hz__c WHERE ID=:recId];
            List<SearchProperties__c> searchproplst = [SELECT Id,SearchPropertiesFormula__c FROM SearchProperties__c WHERE ID=:listinglst[0].SearchPropertyId__c];
            return searchproplst;
            }catch(Exception e){
                System.debug('Exception -->>'+e);
                return null;
            }
       }

}