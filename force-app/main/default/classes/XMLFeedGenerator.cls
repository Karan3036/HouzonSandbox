public class XMLFeedGenerator {
    public String recordID;
    public String xmlstring { get; set; }

    public XMLFeedGenerator() {
        
        if(!Test.isRunningTest()){
        	recordID = ApexPages.currentPage().getParameters().get('Id').escapeHtml4();
        }
        Set<Id> ListingIds = new Set<Id>();
        
        List<PortalListing__c> PortalListings;

        if(!Test.isRunningTest()){
            PortalListings = [Select Id, Listing_hz__c, Portal__c, Portal__r.LastModifiedDate from PortalListing__c Where Portal__c =: recordID AND SystemIsActive__c = True];
        }
        else {
            PortalListings = [Select Id, Listing_hz__c, Portal__c, Portal__r.LastModifiedDate from PortalListing__c LIMIT 10];
        }
        
        //List<PortalListing__c> PortalListings = [Select Id, Listing_hz__c, Portal__c, Portal__r.LastModifiedDate from PortalListing__c Where Portal__c =: recordID AND SystemIsActive__c = True];
        for (PortalListing__c PortalList : PortalListings) {
            if (PortalList.Listing_hz__c != null) {
                ListingIds.add(PortalList.Listing_hz__c);
            }
        }
        List<String> fieldNames = getFieldNamesFromFieldSet('Listing_hz__c', 'FieldsForBayut');
        System.debug('Field Names: ' + fieldNames);
        String query = generateDynamicQuery(fieldNames, ListingIds);

        List<SObject> records = Database.query(query);

        Set<Id> PropertyIds = new Set<Id>();
        for (SObject record : records) {
            Id propertyId = (Id)record.get('Property_hz__c');
            if (propertyId != null) {
                PropertyIds.add(propertyId);
            }
        }

        // Map to store PropertyMedia__c records related to each Property_hz__c
        Map<Id, List<PropertyMedia__c>> propertyMediaUrlsMap = new Map<Id, List<PropertyMedia__c>>();
        for (PropertyMedia__c media : [SELECT FilenameUrlEncoded__c, ExternalLink__c, SortOnPortalFeed__c, Property_hz__c, LastModifiedDate, Tags__c FROM PropertyMedia__c WHERE Property_hz__c IN :PropertyIds AND IsOnPortalFeed__c = true Order BY SortOnPortalFeed__c ASC NULLS LAST, Name ASC]) {
            if (!propertyMediaUrlsMap.containsKey(media.Property_hz__c)) {
                propertyMediaUrlsMap.put(media.Property_hz__c, new List<PropertyMedia__c>());
            }
            propertyMediaUrlsMap.get(media.Property_hz__c).add(media);
        }

        DOM.Document doc = new DOM.Document();
        dom.XmlNode rootNode = doc.createRootElement('Properties', null, null);

        for (SObject record : records) {

            boolean hasFeatureValues = false;
            for (String fieldName : fieldNames) {
                if (fieldName.startsWith('Feature_')) {
                    Object fieldValue = record.get(fieldName);
                    if (fieldValue != null) {
                        hasFeatureValues = true;
                        break;
                    }
                }
            }

            dom.XmlNode propertyNode = rootNode.addChildElement('Property', null, null);
            
            for (String fieldName : fieldNames) {
                if(fieldName != 'Feature_1__c' && 
                   fieldName != 'Feature_2__c' && 
                   fieldName != 'Feature_3__c' && 
                   fieldName != 'Feature_4__c' && 
                   fieldName != 'Feature_5__c' && 
                   fieldName != 'Feature_6__c'){
                    Object fieldValue = record.get(fieldName);
    
                    if (fieldValue != null) {
                        dom.XmlNode fieldNode = propertyNode.addChildElement(fieldName, null, null);
                        fieldNode.addTextNode(String.valueOf(fieldValue));
                    }
                }
            }

            if (hasFeatureValues) {
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
            }

            String lastModifiedDate = '';
            if (record.get('LastModifiedDate') != null) {
                Datetime lastModifiedDatetime = (Datetime)record.get('LastModifiedDate');
                lastModifiedDate = lastModifiedDatetime.format('yyyy-MM-dd HH:mm:ss');
            }
            
            dom.XmlNode lastupdate = propertyNode.addChildElement('Last_Updated', null, null);
            lastupdate.addTextNode(lastModifiedDate);

            // Include image URLs from map
            if (propertyMediaUrlsMap.containsKey((Id)record.get('Property_hz__c'))) {
                dom.XmlNode ImageNode = propertyNode.addChildElement('Images', null, null);
                dom.XmlNode AllNode = null;
                dom.XmlNode FloorNode = null;
                dom.XmlNode VideoNode = null;
                for (PropertyMedia__c media : propertyMediaUrlsMap.get((Id)record.get('Property_hz__c'))) {
                    String imageUrl = String.isNotBlank(media.ExternalLink__c) ? media.ExternalLink__c : media.FilenameUrlEncoded__c;
                    if (media.Tags__c != null) {
                        List<String> tagsList = media.Tags__c.split(';');
                        for (String tag : tagsList) {
                            if (tag == 'Floorplan') {
                                if (FloorNode == null) {
                                    FloorNode = propertyNode.addChildElement('Floor_Plans', null, null);
                                }
                                dom.XmlNode fieldNodeImage = FloorNode.addChildElement('Floor_Plan', null, null);
                                fieldNodeImage.addTextNode(imageUrl);
                            } else if (tag == 'Virtual Tour' || tag == '360tour') {
                                if (VideoNode == null) {
                                    VideoNode = propertyNode.addChildElement('Videos', null, null);
                                }
                                dom.XmlNode fieldNodeImage = VideoNode.addChildElement('Video', null, null);
                                fieldNodeImage.addTextNode(imageUrl);
                            }
                        }
                    }   else {
                        dom.XmlNode fieldNodeImage = ImageNode.addChildElement('Image', null, null);
                        fieldNodeImage.addTextNode(imageUrl);
                    }
                }
            }
            
            dom.XmlNode Portal = propertyNode.addChildElement('Portals', null, null);
            dom.XmlNode PortalValue1 = Portal.addChildElement('Portal', null, null);
            PortalValue1.addTextNode('Bayut');
            
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

    public String generateDynamicQuery(List<String> fieldNames, Set<Id> ListingIds) {
        String query = 'SELECT Id, Property_hz__c, LastModifiedDate';

        for (String fieldName : fieldNames) {
            query += ', ' + fieldName;
        }

        query += ' FROM Listing_hz__c WHERE Id IN :ListingIds';

        return query;
    }
    
    // Function to escape special characters
    private String escapeXml(String input) {
        Map<String, String> replacements = new Map<String, String>{
            'Broker_s_Listing_ID__c' => 'Property_Ref_No',
            'ListingType__c' => 'Property_purpose',
            'PropertyType__c' => 'Property_Type',
            'City_Propertyfinder__c' => 'City',
            'Community_Propertyfinder__c' => 'Locality',
            'Sub_Community_Propertyfinder__c' => 'Sub_Locality',
            'Property_Propertyfinder__c' => 'Tower_name',
            'Name' => 'Property_Title',
            'Title_Arabic__c' => 'Property_Title_AR',
            'Description_hz__c' => 'Property_Description',
            'Description_Arabic__c' => 'Property_Description_AR',
            'TotalArea_hz__c' => 'Property_Size',
            'Bedrooms_hz__c' => 'Bedrooms',
            'FullBathrooms_hz__c' => 'Bathroom',
            'ListingPrice_hz__c' => 'Price',
            'Listing_Agent_Full_Property_Title__c' => 'Listing_Agent',
            'Listing_Agent_Phone__c' => 'Listing_Agent_Phone',
            'Listing_Agent_Email__c' => 'Listing_Agent_Email',
            'Feature_1__c' => 'Feature',
            'Feature_2__c' => 'Feature',
            'Feature_3__c' => 'Feature',
            'Feature_4__c' => 'Feature',
            'Feature_5__c' => 'Feature',
            'Feature_6__c' => 'Feature',
            'RERA_Permit_Number__c' => 'Permit_Number',
            'Off_Plan_New__c' => 'Off_Plan',
            'Rent_Frequency__c' => 'Rent_Frequency',
            'Furnished__c' => 'Furnished'
        };
        
        for (String key : replacements.keySet()) {
            input = input.replace(key, replacements.get(key));
        }

        return input;
    }
}