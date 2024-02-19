public class XMLFeedGeneratorForPF {
    public String recordID;
    public String xmlstring { get; set; }

    public XMLFeedGeneratorForPF() {
        recordID = ApexPages.currentPage().getParameters().get('Id').escapeHtml4();
        List<String> fieldNames = getFieldNamesFromFieldSet('Listing_hz__c', 'FieldsForPF');
        System.debug('Field Names: ' + fieldNames);
        String query = generateDynamicQuery(fieldNames);

        List<SObject> records = Database.query(query);

        DOM.Document doc = new DOM.Document();
        dom.XmlNode rootNode = doc.createRootElement('list', null, null);
        rootNode.setAttribute('last_update', '2024-02-09 17:05:00');
        rootNode.setAttribute('listing_count', String.valueOf(records.size()));


        for (SObject record : records) {
            dom.XmlNode propertyNode = rootNode.addChildElement('property', null, null);
            propertyNode.setAttribute('last_update', '2024-02-09 17:05:00');
            
            for (String fieldName : fieldNames) {
                if(fieldName != 'Listing_Agent_Full_Name__c' && 
                   fieldName != 'Listing_Agent_Email__c' && 
                   fieldName != 'Listing_Agent_Phone__c' && 
                   fieldName != 'OwnerId'){
                    Object fieldValue = record.get(fieldName);
    
                    // Check for null before adding text node
                    if (fieldValue != null) {
                        dom.XmlNode fieldNode = propertyNode.addChildElement(fieldName, null, null);
                        fieldNode.addTextNode(String.valueOf(fieldValue));
                    }
                }
            }
            
            dom.XmlNode feature = propertyNode.addChildElement('agent', null, null);
            
            for (String fieldName : fieldNames) {
                if(fieldName == 'Listing_Agent_Full_Name__c' || 
                   fieldName == 'Listing_Agent_Email__c' || 
                   fieldName == 'Listing_Agent_Phone__c' || 
                   fieldName == 'OwnerId'){
                    Object fieldValue = record.get(fieldName);
    
                    // Check for null before adding text node
                    if (fieldValue != null) {
                        dom.XmlNode fieldNode = feature.addChildElement(fieldName, null, null);
                        fieldNode.addTextNode(String.valueOf(fieldValue));
                    }
                }
            }
            
            dom.XmlNode ImageNode = propertyNode.addChildElement('photo', null, null);
            dom.XmlNode fieldNodeImage = ImageNode.addChildElement('url', null, null);
            fieldNodeImage.setAttribute('last_update', '2024-02-09 17:05:00');
            fieldNodeImage.setAttribute('watermark', 'yes');
            fieldNodeImage.addTextNode('https://s3.amazonaws.com/propertybase-clients/00D4J000000GqeCUAS/a0O8d000005rSnj/r5jnm6cba/01.jpeg');
            
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

    public String generateDynamicQuery(List<String> fieldNames) {
        String query = 'SELECT Id';

        for (String fieldName : fieldNames) {
            query += ', ' + fieldName;
        }

        query += ' FROM Listing_hz__c WHERE Id = :recordID LIMIT 1';

        return query;
    }
    
    // Function to escape special characters
    private String escapeXml(String input) {
        // input = input.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
        input = input.replace('&lt;', '<');
        input = input.replace('&gt;', '>');
        input = input.replace('OwnerId', 'id');
        input = input.replace('Broker_s_Listing_ID__c', 'reference_number');
        input = input.replace('RERA_Permit_Number__c', 'permit_number');
        input = input.replace('ListingPrice_hz__c', 'price');
        input = input.replace('ShortformOfPropertyType__c', 'property_type');
        input = input.replace('City_Propertyfinder__c', 'city');
        input = input.replace('Community_Propertyfinder__c', 'community');
        input = input.replace('Sub_community', 'sub_community');
        input = input.replace('Property_Propertyfinder__c', 'property_name');
        input = input.replace('Offer_Type__c', 'offering_type');
        input = input.replace('Name', 'title_en');
        input = input.replace('Description_hz__c', 'description_en');
        input = input.replace('ShortformOfPrivateAmenities__c', 'private_amenities');
        input = input.replace('View_hz__c', 'view');
        input = input.replace('TotalArea_hz__c', 'size');
        input = input.replace('Bedrooms_hz__c', 'bedroom');
        input = input.replace('FullBathrooms_hz__c', 'bathroom');
        input = input.replace('Completion_Status__c', 'completion_status');
        input = input.replace('Listing_Agent_Full_title_en__c', 'name');
        input = input.replace('Listing_Agent_Email__c', 'email');
        input = input.replace('Listing_Agent_Phone__c', 'phone');
        input = input.replace('Floor__c', 'floor');
        input = input.replace('Furnished__c', 'furnished');
        return input;
    }
}
