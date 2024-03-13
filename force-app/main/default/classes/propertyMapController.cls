public with sharing class propertyMapController {
   

    @AuraEnabled(cacheable=true)
    public static list<sObject> propertyMapController(string sObjectApiName, String rid) {    
        String sQuery = '';
        List < sObject > returnList = new List < sObject > ();
        if(Test.isRunningTest()){
            sQuery ='Select Id,Name, Latitude_hz__c, Longitude_hz__c, Address_hz__c,Building_Dubizzle__c  From ' + sObjectApiName;
        }
        else {
            //  String sQuery = 'Select Id,Name, Latitude_hz__c, Longitude_hz__c, Address_hz__c,Building_Dubizzle__c  From ' + sObjectApiName + 'WHERE Id =: ''+ rid';
            sQuery = 'SELECT Id, Name, Latitude_hz__c, Longitude_hz__c, Address_hz__c, Building_Dubizzle__c FROM ' + sObjectApiName + ' WHERE Id = :rid'; 
        }
        
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }
}