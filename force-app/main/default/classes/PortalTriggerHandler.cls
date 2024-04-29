public with sharing class PortalTriggerHandler {
    public void OnBeforeUpdate(Portal__c[] newPortal){
        ForceSiteURL__c forceSiteURL = ForceSiteURL__c.getOrgDefaults();
        System.debug('forceSiteURL---->'+forceSiteURL);
        for (Portal__c portal : newPortal) {
            if (portal.generator__c == 'Propertyfinder') {
                portal.XML_Feed_URL__c = forceSiteURL.SiteUrl__c + 'XMLFeedForPF?Id=' + portal.ID; 
            } else if (portal.generator__c == 'Bayut') {
                portal.XML_Feed_URL__c = forceSiteURL.SiteUrl__c + 'XMLFeed?Id=' + portal.ID;
            } else if (portal.generator__c == 'Dubizzle') {
                portal.XML_Feed_URL__c = forceSiteURL.SiteUrl__c + 'XMLFeedForDubizzle?Id=' + portal.ID;
            } else {
                portal.XML_Feed_URL__c = '';
            }
        }
    }

    public void OnAfterInsert(Portal__c[] newPortal) {
        List<Portal__c> portalsToUpdate = new List<Portal__c>();
        ForceSiteURL__c forceSiteURL = ForceSiteURL__c.getOrgDefaults();
        
        for (Portal__c portal : newPortal) {
            Portal__c updatedPortal = new Portal__c(
                Id = portal.Id,
                XML_Feed_URL__c = getXMLFeedURL(forceSiteURL.SiteUrl__c, portal.generator__c, portal.Id)
            );
            portalsToUpdate.add(updatedPortal);
        }
        
        update portalsToUpdate;
    }
    
    private String getXMLFeedURL(String siteUrl, String generator, Id portalId) {
        if (generator == 'Propertyfinder') {
            return siteUrl + 'XMLFeedForPF?Id=' + portalId; 
        } else if (generator == 'Bayut') {
            return siteUrl + 'XMLFeed?Id=' + portalId;
        } else if (generator == 'Dubizzle') {
            return siteUrl + 'XMLFeedForDubizzle?Id=' + portalId;
        } else {
            return '';
        }
    }
}