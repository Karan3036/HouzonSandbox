public with sharing class PortalTriggerHandler {
    public void OnBeforeInsert(Portal__c[] newPortal){
        ForceSiteURL__c forceSiteURL = ForceSiteURL__c.getOrgDefaults();
        System.debug('forceSiteURL---->'+forceSiteURL);
        for (Portal__c portal : newPortal) {
            if (portal.generator__c == 'Propertyfinder') {
                portal.XML_Feed_URL__c = forceSiteURL.SiteUrl__c + 'XMLFeedForPF?Id=' + portal.ID; 
            } else if (portal.generator__c == 'Bayut') {
                portal.XML_Feed_URL__c = forceSiteURL.SiteUrl__c + 'XMLFeed?Id=' + portal.ID;
            } else if (portal.generator__c == 'Dubizzle') {
                portal.XML_Feed_URL__c = forceSiteURL.SiteUrl__c + 'XMLFeed?Id=' + portal.ID;
            } else {
                portal.XML_Feed_URL__c = '';
            }
        }
    }
}