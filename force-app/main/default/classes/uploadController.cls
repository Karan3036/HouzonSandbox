public with sharing class uploadController {


    @AuraEnabled
    public static list<PropertyMedia__c> fetchdata(String recordId){
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c,Tags__c, Name, Size__c,ExternalLink__c, Property_hz__c,IsOnPortalFeed__c,	IsOnWebsite__c,IsOnExpose__c, SortOnExpose__c, SortOnPortalFeed__c, SortOnWebsite__c FROM PropertyMedia__c WHERE Property_hz__c = :recordId];
        return result;
    }

    @AuraEnabled
    public static Listing_hz__c getListingRecord(String recordId) {
        try {
            return [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id = :recordId LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching listing record: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static list<PropertyMedia__c> fetchdataforlisting(String recordId){
        Listing_hz__c listing = [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id= :recordId LIMIT 1];
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c, Tags__c, Name, ExternalLink__c, Size__c, Property_hz__c, IsOnPortalFeed__c, IsOnWebsite__c, IsOnExpose__c, SortOnExpose__c, SortOnPortalFeed__c, SortOnWebsite__c FROM PropertyMedia__c WHERE Property_hz__c = :listing.Property_hz__c ORDER BY Name];
        result.sort();
        return result;
    }

    @AuraEnabled
    public static Boolean createmedia(String Name, Decimal Size, String recordId, String externalUrl, String external_link ){
        PropertyMedia__c Media = new PropertyMedia__c();
        Media.FilenameUrlEncoded__c = externalUrl;
        Media.Name = Name;
        Media.Size__c = Size;
        Media.Property_hz__c = recordId;
        Media.ExternalLink__c = external_link;
        insert Media;
        return true;
    }

    @AuraEnabled
    public static Boolean createmediaforlisting(Id recordId, List<MediaData> mediaList){
        List<PropertyMedia__c> mediaToInsert = new List<PropertyMedia__c>();
        Listing_hz__c listing = [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id = :recordId LIMIT 1];
        for (MediaData media : mediaList) {
            
            PropertyMedia__c mediaRecord = new PropertyMedia__c();
            mediaRecord.FilenameUrlEncoded__c = media.externalUrl;
            mediaRecord.Name = media.Name;
            mediaRecord.Size__c = media.Size;
            mediaRecord.Property_hz__c = listing.Property_hz__c;
            
            mediaToInsert.add(mediaRecord);
        }
        
        insert mediaToInsert;
        
        return true;
        // Listing_hz__c listing = [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id= :recordId LIMIT 1];
        // // System.debug('externalUrl ==> ' + externalUrl);
        // PropertyMedia__c Media = new PropertyMedia__c();
        // Media.FilenameUrlEncoded__c = externalUrl;
        // Media.Name = Name;
        // Media.Size__c = Size;
        // Media.Property_hz__c = listing.Property_hz__c;
        // insert Media;
    
        // return true;
        
    }
    public class MediaData {
        @AuraEnabled
        public String Name { get; set; }
        @AuraEnabled
        public Decimal Size { get; set; }
        @AuraEnabled
        public String externalUrl { get; set; }

    }

    @AuraEnabled
    public static Boolean deletemedia(String id,String property_id){
        if(id !=null){
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c,IsOnExpose__c, Name, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Id = :id LIMIT 1];
        delete result;
        }
        if(property_id !=null){
            List<PropertyMedia__c> all_media = [SELECT Id, FilenameUrlEncoded__c, Name,IsOnExpose__c, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Property_hz__c = :property_id ];
            delete all_media;
        }
        return true;
    }

    @AuraEnabled
    public static Boolean deletelistingmedia(String id,String property_id){
        if(id !=null){
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c,IsOnExpose__c, Name, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Id = :id LIMIT 1];
        delete result;
        }
        if(property_id !=null){
            Listing_hz__c listing = [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id= :property_id LIMIT 1];
            List<PropertyMedia__c> all_media = [SELECT Id, FilenameUrlEncoded__c, Name, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Property_hz__c = :listing.Property_hz__c ];
            delete all_media;
        }
        return true;
    }

    @AuraEnabled
    public static Boolean update_media_name(String dataMapJSON) {
        try {
            List<MediaInfo> mediaInfoList = (List<MediaInfo>) JSON.deserialize(dataMapJSON, List<MediaInfo>.class);

            List<PropertyMedia__c> recordsToUpdate = new List<PropertyMedia__c>();
            
            // Collect recordIds to query outside the loop
            Set<String> recordIds = new Set<String>();
            for (MediaInfo info : mediaInfoList) {
                recordIds.add(info.recordId);
            }
            
            // Query records outside the loop
            Map<String, PropertyMedia__c> recordsMap = new Map<String, PropertyMedia__c>([SELECT Id, Name, Tags__c FROM PropertyMedia__c WHERE Id IN :recordIds]);

            for (MediaInfo info : mediaInfoList) {
                String recordId = info.recordId;
                String fileName = info.fileName;
                Set<String> picklistValues = info.picklistValues;
                
                PropertyMedia__c record = recordsMap.get(recordId);
                
                if (record != null) {
                    record.Name = fileName;
                    record.Tags__c = picklistValues != null && !picklistValues.isEmpty() ? String.join(picklistValues, ';') : '';
                    recordsToUpdate.add(record);
                }
            }

            // Update records
            if (!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }

            return true;

        } catch (Exception e) {
            // System.debug('Exception ==> ' + e);
            return false;
        }
    }


    public class MediaInfo {

        public String recordId;
        public String fileName;
        public Set<String> picklistValues;
    }

    @AuraEnabled
    public static String getCurrentDateTimeWithSeconds() {
        DateTime currentDateTime = DateTime.now();
        String currentDateTimeWithSeconds = currentDateTime.format('yyyy-MM-dd HH:mm:ss');
        return currentDateTimeWithSeconds;
    }

    @AuraEnabled
    public static Boolean updateSortOrder(List<PropertyMedia__c> mediaList){
        if(mediaList.size() > 0){ update mediaList;
        }
        return true;
    }
    @AuraEnabled
    public static Boolean updateOrderState(List<Id> expose_ids, List<Id> website_ids, List<Id> portal_ids, List<Id> expose_ids_false, List<Id> website_ids_false, List<Id> portal_ids_false){


        if(expose_ids !=null){
            List<propertyMedia__c> exposed_mediaList = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : expose_ids];
            List<propertyMedia__c> exposed_mediaList_to_update = new List<propertyMedia__c>();
            if(exposed_mediaList.size()>0){
                for(propertyMedia__c prop_e :exposed_mediaList ){
                    prop_e.IsOnExpose__c = true;
                    exposed_mediaList_to_update.add(prop_e);
                }
                update exposed_mediaList_to_update;    
            }
        }

        if(website_ids !=null){
            List<propertyMedia__c> website_mediaList = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : website_ids];
            List<propertyMedia__c> website_mediaList_to_update = new List<propertyMedia__c>();
            if(website_mediaList.size()>0){
                for(propertyMedia__c prop_w :website_mediaList ){
                    prop_w.IsOnWebsite__c = true;
                    website_mediaList_to_update.add(prop_w);
                }
                update website_mediaList_to_update;    
            }
        }

        if(portal_ids !=null){
            List<propertyMedia__c> portal_mediaList = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : portal_ids];
            List<propertyMedia__c> portal_mediaList_to_update = new List<propertyMedia__c>();
            if(portal_mediaList.size()>0){
                for(propertyMedia__c prop_p :portal_mediaList ){
                    prop_p.IsOnPortalFeed__c = true;
                    portal_mediaList_to_update.add(prop_p);
                }
                update portal_mediaList_to_update;    
            }
        }

        if(expose_ids_false !=null){
            List<propertyMedia__c> exposed_mediaList_false = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : expose_ids_false];
            List<propertyMedia__c> exposed_mediaList_to_update_false = new List<propertyMedia__c>();
            if(exposed_mediaList_false.size()>0){
                for(propertyMedia__c prop_e_f :exposed_mediaList_false ){
                    prop_e_f.IsOnExpose__c = false;
                    exposed_mediaList_to_update_false.add(prop_e_f);
                }
                update exposed_mediaList_to_update_false;    
            }
        }

        if(website_ids_false !=null){
            List<propertyMedia__c> website_mediaList_false = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : website_ids_false];
            List<propertyMedia__c> website_mediaList_to_update_false = new List<propertyMedia__c>();
            if(website_mediaList_false.size()>0){
                for(propertyMedia__c prop_w_f :website_mediaList_false ){
                    prop_w_f.IsOnWebsite__c = false;
                    website_mediaList_to_update_false.add(prop_w_f);
                }
                update website_mediaList_to_update_false;    
            }
        }

        if(portal_ids_false !=null){
            List<propertyMedia__c> portal_mediaList_false = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : portal_ids_false];
            List<propertyMedia__c> portal_mediaList_to_update_false = new List<propertyMedia__c>();
            if(portal_mediaList_false.size()>0){
                for(propertyMedia__c prop_p_f :portal_mediaList_false ){
                    prop_p_f.IsOnPortalFeed__c = false;
                    portal_mediaList_to_update_false.add(prop_p_f);
                }
                update portal_mediaList_to_update_false;    
            }
        }
        return true;
    }
    
}