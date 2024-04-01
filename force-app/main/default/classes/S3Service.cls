public with sharing class S3Service {
  
    @AuraEnabled (cacheable=true)
    public static AWS_Config__c getS3ConfigSettings(){
        return AWS_Config__c.getOrgDefaults();
    }
}