public class XMLFeedGeneratorForPF {
    public String recordID;
    public String xmlstring { get; set; }

    public XMLFeedGeneratorForPF() {
        
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



        // List<PortalListing__c> PortalListings = [Select Id, Listing_hz__c, Portal__c, Portal__r.LastModifiedDate from PortalListing__c Where Portal__c =: recordID AND SystemIsActive__c = True];
        for (PortalListing__c PortalList : PortalListings) {
            if (PortalList.Listing_hz__c != null) {
                ListingIds.add(PortalList.Listing_hz__c);
            }
        }
        List<String> fieldNames = getFieldNamesFromFieldSet('Listing_hz__c', 'FieldsForPF');
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
        for (PropertyMedia__c media : [SELECT FilenameUrlEncoded__c, Property_hz__c, LastModifiedDate FROM PropertyMedia__c WHERE Property_hz__c IN :PropertyIds]) {
            if (!propertyMediaUrlsMap.containsKey(media.Property_hz__c)) {
                propertyMediaUrlsMap.put(media.Property_hz__c, new List<PropertyMedia__c>());
            }
            propertyMediaUrlsMap.get(media.Property_hz__c).add(media);
        }

        DOM.Document doc = new DOM.Document();
        dom.XmlNode rootNode = doc.createRootElement('list', null, null);
        rootNode.setAttribute('last_update', PortalListings[0].Portal__r.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss'));
        rootNode.setAttribute('listing_count', String.valueOf(records.size()));

        for (SObject record : records) {
            dom.XmlNode propertyNode = rootNode.addChildElement('property', null, null);
            String lastModifiedDate = '';
            if (record.get('LastModifiedDate') != null) {
                Datetime lastModifiedDatetime = (Datetime)record.get('LastModifiedDate');
                lastModifiedDate = lastModifiedDatetime.format('yyyy-MM-dd HH:mm:ss');
            }
            propertyNode.setAttribute('last_update', lastModifiedDate);
            
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
            
            // Include image URLs from map
            if (propertyMediaUrlsMap.containsKey((Id)record.get('Property_hz__c'))) {
                dom.XmlNode ImageNode = propertyNode.addChildElement('photo', null, null);
                for (PropertyMedia__c media : propertyMediaUrlsMap.get((Id)record.get('Property_hz__c'))) {
                    dom.XmlNode fieldNodeImage = ImageNode.addChildElement('url', null, null);
                    fieldNodeImage.setAttribute('last_update', media.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss'));
                    fieldNodeImage.setAttribute('watermark', 'yes');
                    fieldNodeImage.addTextNode(media.FilenameUrlEncoded__c);
                }
            }
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

    // private String escapeXml(String input) {
    //     input = input.replace('OwnerId', 'id');
    //     input = input.replace('Broker_s_Listing_ID__c', 'reference_number');
    //     input = input.replace('RERA_Permit_Number__c', 'permit_number');
    //     input = input.replace('ListingPrice_hz__c', 'price');
    //     input = input.replace('ShortformOfPropertyType__c', 'property_type');
    //     input = input.replace('City_Propertyfinder__c', 'city');
    //     input = input.replace('Community_Propertyfinder__c', 'community');
    //     input = input.replace('Sub_community', 'sub_community');
    //     input = input.replace('Property_Propertyfinder__c', 'property_name');
    //     input = input.replace('Offer_Type__c', 'offering_type');
    //     input = input.replace('Name', 'title_en');
    //     input = input.replace('Description_hz__c', 'description_en');
    //     input = input.replace('ShortformOfPrivateAmenities__c', 'private_amenities');
    //     input = input.replace('View_hz__c', 'view');
    //     input = input.replace('TotalArea_hz__c', 'size');
    //     input = input.replace('Bedrooms_hz__c', 'bedroom');
    //     input = input.replace('FullBathrooms_hz__c', 'bathroom');
    //     input = input.replace('Completion_Status__c', 'completion_status');
    //     input = input.replace('Listing_Agent_Full_title_en__c', 'name');
    //     input = input.replace('Listing_Agent_Email__c', 'email');
    //     input = input.replace('Listing_Agent_Phone__c', 'phone');
    //     input = input.replace('Floor__c', 'floor');
    //     input = input.replace('Furnished__c', 'furnished');
    //     return input;
    // }
        
    private String escapeXml(String input) {
        Map<String, String> replacements = new Map<String, String>{
            'OwnerId' => 'id',
            'Broker_s_Listing_ID__c' => 'reference_number',
            'RERA_Permit_Number__c' => 'permit_number',
            'ListingPrice_hz__c' => 'price',
            'ShortformOfPropertyType__c' => 'property_type',
            'City_Propertyfinder__c' => 'city',
            'Community_Propertyfinder__c' => 'community',
            'Sub_community' => 'sub_community',
            'Property_Propertyfinder__c' => 'property_name',
            'Offer_Type__c' => 'offering_type',
            'Name' => 'title_en',
            'Description_hz__c' => 'description_en',
            'ShortformOfPrivateAmenities__c' => 'private_amenities',
            'View_hz__c' => 'view',
            'TotalArea_hz__c' => 'size',
            'Bedrooms_hz__c' => 'bedroom',
            'FullBathrooms_hz__c' => 'bathroom',
            'Completion_Status__c' => 'completion_status',
            'Listing_Agent_Full_title_en__c' => 'name',
            'Listing_Agent_Email__c' => 'email',
            'Listing_Agent_Phone__c' => 'phone',
            'Floor__c' => 'floor',
            'Furnished__c' => 'furnished',
            'DTCM_Permit_hz__c' => 'dtcm_permit',
            'Service_Charge__c' => 'service_charge',
            'Number_Of_Cheques__c' => 'cheques',
            'Title_Arabic__c' => 'title_ar',
            'Description_Arabic__c' => 'description_ar',
            'Commercial_Amenities__c' => 'commercial_amenities',
            'LotSize_hz__c' => 'plot_size',
            'YearBuilt_hz__c' => 'year_built',
            'Floor_Level__c' => 'floor',
            'Stories__c' => 'stories',
            'NumberOfParkingSpaces__c' => 'parking',
            'Title_Deed__c' => 'title_deed',
            'Availability_Date__c' => 'availability_date',
            'Developer_Name__c' => 'Developer',
            'CompletionStatus_hz__c' => 'completion_status'
        };
        
        for (String key : replacements.keySet()) {
            input = input.replace(key, replacements.get(key));
        }

        return input;
    }
}