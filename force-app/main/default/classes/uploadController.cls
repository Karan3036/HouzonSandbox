public with sharing class uploadController {
    // public uploadController() {
    // }

    @AuraEnabled
    public static list<PropertyMedia__c> fetchdata(String recordId){
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c, Name, Size__c,ExternalLink__c, Property_hz__c,IsOnPortalFeed__c,	IsOnWebsite__c,IsOnExpose__c, SortOnExpose__c, SortOnPortalFeed__c, SortOnWebsite__c FROM PropertyMedia__c WHERE Property_hz__c = :recordId];
        return result;
    }

    @AuraEnabled
    public static list<PropertyMedia__c> fetchdataforlisting(String recordId){
        Listing_hz__c listing = [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id= :recordId LIMIT 1];
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c, Name,ExternalLink__c, Size__c, Property_hz__c,IsOnPortalFeed__c,	IsOnWebsite__c,IsOnExpose__c, SortOnExpose__c, SortOnPortalFeed__c, SortOnWebsite__c FROM PropertyMedia__c WHERE Property_hz__c = :listing.Property_hz__c];
        return result;
    }

    @AuraEnabled
    public static Boolean createmedia(String Name, Decimal Size, String recordId, String Url, String external_link ){
        PropertyMedia__c Media = new PropertyMedia__c();
        Media.FilenameUrlEncoded__c = Url;
        Media.Name = Name;
        Media.Size__c = Size;
        Media.Property_hz__c = recordId;
        Media.ExternalLink__c = external_link;
        insert Media;
        return true;
    }

    @AuraEnabled
    public static Boolean createmediaforlisting(String Name, Decimal Size, String recordId, String Url){
        Listing_hz__c listing = [SELECT Id, Property_hz__c FROM Listing_hz__c WHERE Id= :recordId LIMIT 1];
        PropertyMedia__c Media = new PropertyMedia__c();
        Media.FilenameUrlEncoded__c = Url;
        Media.Name = Name;
        Media.Size__c = Size;
        Media.Property_hz__c = listing.Property_hz__c;
        insert Media;
        return true;
    }

    @AuraEnabled
    public static Boolean deletemedia(String id,String property_id){
        if(id !=null){
        List<PropertyMedia__c> result = [SELECT Id, FilenameUrlEncoded__c,IsOnExpose__c, Name, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Id = :id LIMIT 1];
        delete result;
        }
        if(property_id !=null){
            List<PropertyMedia__c> all_media = [SELECT Id, FilenameUrlEncoded__c, Name,IsOnExpose__c, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Property_hz__c = :property_id ];
            System.debug('all_media: '+all_media);
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
            System.debug('all_media: '+all_media);
            delete all_media;
        }
        return true;
    }

    @AuraEnabled
    public static Boolean update_media_name(String id,String fileName, String url){
        List<PropertyMedia__c> result = [SELECT Id, Name,FilenameUrlEncoded__c FROM PropertyMedia__c WHERE Id = :id LIMIT 1];
        result[0].Name = fileName;
        result[0].FilenameUrlEncoded__c = url;
        System.debug('result: '+result);
        update result;
        return true;
    }

    @AuraEnabled
    public static Boolean undeletemedia(String id){
        List<PropertyMedia__c> record_to_undelete = [SELECT Id, FilenameUrlEncoded__c, Name, Size__c, Property_hz__c FROM PropertyMedia__c WHERE Id = :id ALL ROWS];
        if(record_to_undelete.size() > 0){
            undelete record_to_undelete;
        }
        return true;
    }


    @AuraEnabled
    public static Boolean updateSortOrder(List<PropertyMedia__c> mediaList){
        if(mediaList.size() > 0){
            update mediaList;
        }
        return true;
    }
    @AuraEnabled
    public static Boolean updateOrderState(List<Id> expose_ids, List<Id> website_ids, List<Id> portal_ids){

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
        return true;
    }

    @AuraEnabled
    public static Boolean updateOrderState_toFalse(List<Id> expose_ids, List<Id> website_ids, List<Id> portal_ids){

        if(expose_ids !=null){
            List<propertyMedia__c> exposed_mediaList = [SELECT Id,Name,IsOnPortalFeed__c,IsOnWebsite__c,IsOnExpose__c FROM PropertyMedia__c WHERE Id IN : expose_ids];
            List<propertyMedia__c> exposed_mediaList_to_update = new List<propertyMedia__c>();
            if(exposed_mediaList.size()>0){
                for(propertyMedia__c prop_e :exposed_mediaList ){
                    prop_e.IsOnExpose__c = false;
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
                    prop_w.IsOnWebsite__c = false;
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
                    prop_p.IsOnPortalFeed__c = false;
                    portal_mediaList_to_update.add(prop_p);
                }
                update portal_mediaList_to_update;    
            }
        }
        return true;
    }
    
}