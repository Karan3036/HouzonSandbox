public class DemoMultipleListingController {
    public List<String> recordIds;
    public String xmlstring { get; set; }

    public DemoMultipleListingController() {
        recordIds = new List<String>{'a04Dg00000557ekIAA', 'a04Dg00000555tzIAA', 'a04Dg00000557epIAA', 'a04Dg00000557euIAA', 'a04Dg00000557ezIAA'};
        // List<String> fieldNames = getFieldNamesFromFieldSet('Listing_hz__c', 'FieldsForBayut');
        // System.debug('Field Names: ' + fieldNames);

        DOM.Document doc = new DOM.Document();
        dom.XmlNode rootNode = doc.createRootElement('Properties', null, null);

        // String query = generateDynamicQuery(fieldNames);
        List<String> fieldNames = getFieldNamesFromFieldSet('Listing_hz__c', 'FieldsForBayut');
        System.debug('Field Names: ' + fieldNames);

        // Pass recordIds list to generateDynamicQuery method
        String query = generateDynamicQuery(fieldNames, recordIds);

        List<SObject> records = Database.query(query);

        // List<SObject> records = Database.query(query);

        for (SObject record : records) {
            dom.XmlNode propertyNode = rootNode.addChildElement('Property', null, null);
            
            for (String fieldName : fieldNames) {
                if(fieldName != 'Feature_1__c' && 
                   fieldName != 'Feature_2__c' && 
                   fieldName != 'Feature_3__c' && 
                   fieldName != 'Feature_4__c' && 
                   fieldName != 'Feature_5__c' && 
                   fieldName != 'Feature_6__c'){
                    Object fieldValue = record.get(fieldName);
    
                    // Check for null before adding text node
                    if (fieldValue != null) {
                        dom.XmlNode fieldNode = propertyNode.addChildElement(fieldName, null, null);
                        fieldNode.addTextNode(String.valueOf(fieldValue));
                    }
                }
            }
            
            dom.XmlNode feature = propertyNode.addChildElement('Features', null, null);
            
            for (String fieldName : fieldNames) {
                if(fieldName == 'Feature_1__c' || 
                   fieldName == 'Feature_2__c' || 
                   fieldName == 'Feature_3__c' || 
                   fieldName == 'Feature_4__c' || 
                   fieldName == 'Feature_5__c' || 
                   fieldName == 'Feature_6__c'){
                    Object fieldValue = record.get(fieldName);
    
                    // Check for null before adding text node
                    if (fieldValue != null) {
                        dom.XmlNode fieldNode = feature.addChildElement(fieldName, null, null);
                        fieldNode.addTextNode(String.valueOf(fieldValue));
                    }
                }
            }
            
            dom.XmlNode lastupdate = propertyNode.addChildElement('Last_Updated', null, null);
            lastupdate.addTextNode('2024-02-14 14:30:19');
            
            dom.XmlNode ImageNode = propertyNode.addChildElement('Images', null, null);
            dom.XmlNode fieldNodeImage = ImageNode.addChildElement('Image', null, null);
            fieldNodeImage.addTextNode('https://s3.amazonaws.com/propertybase-clients/00D4J000000GqeCUAS/a0O8d000005rSnj/r5jnm6cba/01.jpeg');
            
            dom.XmlNode VideoNode = propertyNode.addChildElement('Videos', null, null);
            dom.XmlNode fieldNodeVideo = VideoNode.addChildElement('Video', null, null);
            fieldNodeVideo.addTextNode('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
            
            dom.XmlNode Portal = propertyNode.addChildElement('Portals', null, null);
            dom.XmlNode PortalValue1 = Portal.addChildElement('Portal', null, null);
            PortalValue1.addTextNode('Bayut');
            dom.XmlNode PortalValue2 = Portal.addChildElement('Portal', null, null);
            PortalValue2.addTextNode('Dubizzle');
            
        }

        xmlstring = escapeXml(doc.toXmlString());
        System.debug('xmlstring-->' + xmlstring);
    }

    public List<String> getFieldNamesFromFieldSet(String objectApiName, String fieldSetName) {
        List<String> fieldNames = new List<String>();

        try {
            // Retrieve the SObjectType for the given object API name
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
            if (objectType != null) {
                // Get the fieldset map for the given object type
                Map<String, Schema.FieldSet> fieldSetMap = objectType.getDescribe().fieldSets.getMap();

                // Check if the fieldset with the given name exists
                if (fieldSetMap.containsKey(fieldSetName)) {
                    // Get the fields from the fieldset
                    List<Schema.FieldSetMember> fieldSetMembers = fieldSetMap.get(fieldSetName).getFields();

                    // Extract field names and add them to the list
                    for (Schema.FieldSetMember fieldSetMember : fieldSetMembers) {
                        fieldNames.add(fieldSetMember.getFieldPath());
                    }
                }
            }
        } catch (Exception e) {
            // Handle exceptions as needed
            System.debug('Exception: ' + e.getMessage());
        }

        return fieldNames;
    }

    public String generateDynamicQuery(List<String> fieldNames, List<String> recordIds) {
        String query = 'SELECT Id';
    
        for (String fieldName : fieldNames) {
            query += ', ' + fieldName;
        }
    
        // Use IN clause to query multiple recordIds
        query += ' FROM Listing_hz__c WHERE Id IN :recordIds';
    
        return query;
    }
    
    
    // Function to escape special characters
    private String escapeXml(String input) {
        // input = input.replace('&', '&amp;');
        input = input.replace('&lt;', '<');
        input = input.replace('&gt;', '>');
        input = input.replace('Broker_s_Listing_ID__c', 'Property_Ref_No');
        input = input.replace('ListingType__c', 'Property_purpose');
        input = input.replace('PropertyType__c', 'Property_Type');
        input = input.replace('City_for_Bayut__c', 'City');
        input = input.replace('Locality_for_Bayut__c', 'Locality');
        input = input.replace('Sub_Locality_for_Bayut__c', 'Sub_Locality');
        input = input.replace('Tower_name_for_bayut__c', 'Tower_name');
        input = input.replace('Name', 'Property_Title');
        input = input.replace('Title_Arabic__c', 'Property_Title_AR');
        input = input.replace('Description_hz__c', 'Property_Description');
        input = input.replace('Description_Arabic__c', 'Property_Description_AR');
        input = input.replace('TotalArea_hz__c', 'Property_Size');
        input = input.replace('Bedrooms_hz__c', 'Bedrooms');
        input = input.replace('FullBathrooms_hz__c', 'Bathroom');
        input = input.replace('ListingPrice_hz__c', 'Price');
        input = input.replace('Listing_Agent_Full_Property_Title__c', 'Listing_Agent');
        input = input.replace('Listing_Agent_Phone__c', 'Listing_Agent_Phone');
        input = input.replace('Listing_Agent_Email__c', 'Listing_Agent_Email');
        input = input.replace('Feature_1__c', 'Feature');
        input = input.replace('Feature_2__c', 'Feature');
        input = input.replace('Feature_3__c', 'Feature');
        input = input.replace('Feature_4__c', 'Feature');
        input = input.replace('Feature_5__c', 'Feature');
        input = input.replace('Feature_6__c', 'Feature');
        input = input.replace('RERA_Permit_Number__c', 'Permit_Number');
        input = input.replace('Off_plan__c', 'Off_Plan');
        input = input.replace('Rent_Frequency__c', 'Rent_Frequency');
        input = input.replace('Furnished__c', 'Furnished');
        return input;
    }
}