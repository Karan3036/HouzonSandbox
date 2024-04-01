public with sharing class FilterPopupController {
    @AuraEnabled(cacheable=true)
    public static List<String> getContactFields() {
        List<String> fieldList = new List<String>();

        // Describe the Contact object
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = globalDescribe.get('Contact');
        Schema.DescribeSObjectResult describeResult = objectType.getDescribe();

        // Get all fields for the Contact object
        List<Schema.SObjectField> fields = describeResult.fields.getMap().values();

        // Extract field names and add them to the list
        for (Schema.SObjectField field : fields) {
            String fieldName = field.getDescribe().getName();
            fieldList.add(fieldName);
        }

        return fieldList;
    }
}