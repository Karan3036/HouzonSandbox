public with sharing class PdfGenerator {

    public Listing_hz__c currentListing { get; set; }
    public List<String> urlList { get; set; }
    public String link1 {get; set;}
    public String link2 {get; set;}
    public String link3 {get; set;}
    public String link4 {get; set;}
    public String link5 {get; set;}
    public String link6 {get; set;}
    public String link7 {get; set;}
    public String link8 {get; set;}
    public String link9 {get; set;}
    public String link10{get; set;}
    public String link11{get; set;}

    public String Today { get { return Date.today().format(); }}

    @AuraEnabled(cacheable = true)
    public static List<Template__c> getTemplateRecords() {

        return [SELECT Id, Name, HTML__c, CSS__c, Status__c, Subject__c,Type__c
                FROM Template__c
                WHERE Type__c = 'pdf_template'];
    }

    public String getReferer()
    {
        String listingId = ApexPages.currentPage().getParameters().get('id');
        String baseurl = ApexPages.currentPage().getHeaders().get('referer');
        String recordUrl = baseurl + listingId;
        return recordUrl;

    }

    public PdfGenerator(ApexPages.StandardController stdController){
        urlList = new List<String>();
        String listingId = ApexPages.currentPage().getParameters().get('id');
        currentListing = [SELECT Id, Name FROM Listing_hz__c WHERE Id = :listingId LIMIT 1];

        List<Property_hz__c> p = [select id,Name,(select Name,FilenameUrlEncoded__c,Size__c from PropertyMedia__r ORDER BY Name) from Property_hz__c where id =: [select Property_hz__c from Listing_hz__c where id =: listingId].Property_hz__c];

        String defualtUrl = '/resource/NoImage'; 

        if(p.size() > 0){

            List<PropertyMedia__c> Medialist = p[0].PropertyMedia__r;
            
            for (Integer i = 0; i < Medialist.size(); i++) {
                PropertyMedia__c media = Medialist.get(i);
                if (media.FilenameUrlEncoded__c != null && media.Size__c != null) {
                    // String temp = media.FilenameUrlEncoded__c.replace(' ', '%20');

                    urlList.add(media.FilenameUrlEncoded__c);
                    // urlList.add(temp);

                }
            } 
            
            link1 = urlList.size() >= 1 ? urlList[0] : defualtUrl;
            link9 = urlList.size() >= 1 ? urlList[0] : defualtUrl;
            link2 = urlList.size() >= 2 ? urlList[1] : defualtUrl;
            link10 = urlList.size() >= 2 ? urlList[1] : defualtUrl;
            link3 = urlList.size() >= 3 ? urlList[2] : defualtUrl;
            link11 = urlList.size() >= 3 ? urlList[2] : defualtUrl;
            link4 = urlList.size() >= 4 ? urlList[3] : defualtUrl;
            link5 = urlList.size() >= 5 ? urlList[4] : defualtUrl;
            link6 = urlList.size() >= 6 ? urlList[5] : defualtUrl;
            link7 = urlList.size() >= 7 ? urlList[6] : defualtUrl;
            link8 = urlList.size() >= 8 ? urlList[7] : defualtUrl;
    
        }
        else{

            link1 = link2 = link3 = link4 = link5 = link6 = link7 = link8 = link9 = link10 = link11 = defualtUrl;
        }

        System.debug('urlList ==> ' + urlList);
      

    }

    @AuraEnabled
    public static ID sendPdf(String listingId, String pageName) {
        Listing_hz__c listing = [SELECT id, name FROM Listing_hz__c WHERE id = :listingId];
        System.debug('In send Pdf method');

        String ListingName = '';


        PageReference pdf = new pagereference('/apex/CreatePdf?id='+listingId);

        if(pageName == 'Single_Pdf'){
            pdf = new pagereference('/apex/Single_Pdf?id='+listingId);
            ListingName += 'Listing Single Pdf : ';
        }
        else if(pageName == 'CreatePdf'){
            pdf = new pagereference('/apex/CreatePdf?id='+listingId);
            ListingName += 'Comprable Small Landscape : ';
        }
        else if(pageName == 'ComparableMarketAnalysis'){
            pdf = new pagereference('/apex/ComparableMarketAnalysis?id='+listingId);
            ListingName += 'Comarative Market Analysis(CMA) : ';
        }
        else if(pageName == 'Multiple_page'){
            pdf = new pagereference('/apex/Multiple_page?id='+listingId);
            ListingName += 'Listing Multiple Pdf : ';
        }
        
        pdf.getParameters().put('id', listingId);
    
        Blob body;
        try {
            // returns page as a PDF
            body = pdf.getContent();
            System.debug('body ==> ' + body);
        } catch (Exception e) {
            body = Blob.valueOf('data');
            System.debug(' Error body ==> ' + body);
        }

        if(listing != null){
            ListingName += listing.Name;
        }
    
        // insert content version
        ContentVersion CV = new ContentVersion();
        CV.Title = listing.Name + '.pdf';
        CV.PathOnClient = listing.Name + '.pdf';
        CV.VersionData = body;
        CV.FirstPublishLocationId = listingId;
        insert CV;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        if(CV != null){
            return contentDocumentId;
        }

        else{
            return null;
        }
    
        
    }

    @AuraEnabled(cacheable=true)
    public static String getListingNameById(String recordId) {
        try {
            Listing_hz__c listing = [SELECT Id,Name FROM Listing_hz__c WHERE Id = :recordId LIMIT 1];
            return listing.Name;
        } catch (Exception e) {
            return null;
        }
    }


}