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

        return [SELECT Id, Name, HTML__c, CSS__c, Status__c, Subject__c
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
        System.debug('In the visualforcepage controller');
        String listingId = ApexPages.currentPage().getParameters().get('id');
        currentListing = [SELECT Id, Name FROM Listing_hz__c WHERE Id = :listingId LIMIT 1];
        System.debug('currentListing ==>' + currentListing);

        List<Property_hz__c> p = [select id,Name,(select FilenameUrlEncoded__c from PropertyMedia__r) from Property_hz__c where id =: [select Property_hz__c from Listing_hz__c where id =: listingId].Property_hz__c];

        String defualtUrl = 'https://jonsnowbucket3421.s3.amazonaws.com/nordwood-themes-r53t-tg6j4c-unsplash.jpg';

        if(p.size() > 0){

            System.debug(p[0].Name);
            System.debug(p[0].PropertyMedia__r);
            List<PropertyMedia__c> Medialist = p[0].PropertyMedia__r;
            System.debug(Medialist);
            
            for (Integer i = 0; i < Medialist.size(); i++) {
                PropertyMedia__c media = Medialist.get(i);
                if (media.FilenameUrlEncoded__c != null) {
                    urlList.add(media.FilenameUrlEncoded__c);
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
    
        
            System.debug(urlList.size());
            System.debug(urlList);
            System.debug(link1);

        }
        else{

            link1 = link2 = link3 = link4 = link5 = link6 = link7 = link8 = defualtUrl;
        }
      

    }

    @AuraEnabled
    public static String sendPdf(String listingId, String pageName) {
        Listing_hz__c listing = [SELECT id, name FROM Listing_hz__c WHERE id = :listingId];
        System.debug(pageName);


        PageReference pdf = new pagereference('/apex/CreatePdf?id='+listingId);

        if(pageName == 'Single_Pdf'){
            pdf = new pagereference('/apex/Single_Pdf?id='+listingId);
        }
        else if(pageName == 'CreatePdf'){
            pdf = new pagereference('/apex/CreatePdf?id='+listingId);
        }
        else if(pageName == 'ComparableMarketAnalysis'){
            pdf = new pagereference('/apex/ComparableMarketAnalysis?id='+listingId);
        }
        else if(pageName == 'Multiple_page'){
            pdf = new pagereference('/apex/Multiple_page?id='+listingId);
        }
        
        pdf.getParameters().put('id', listingId);
    
        Blob body;
        try {
            // returns page as a PDF
            body = pdf.getContent();
        } catch (Exception e) {
            body = Blob.valueOf('data');
        }
    
        // insert content version
        ContentVersion CV = new ContentVersion();
        CV.Title = listing.Name + '.pdf';
        CV.PathOnClient = listing.Name + '.pdf';
        CV.VersionData = body;
        CV.FirstPublishLocationId = listingId;
        // insert CV;
    
        return 'Success';
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