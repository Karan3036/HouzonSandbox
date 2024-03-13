@isTest
private class PdfGeneratorTest {

    @isTest
    static void testPdfGenerator() {

        Listing_hz__c testListing = new Listing_hz__c(Name = 'Test Listing');
        insert testListing;

        Property_hz__c testProperty = new Property_hz__c(Name = 'Test Property');
        insert testProperty;

        PropertyMedia__c testMedia1 = new PropertyMedia__c(FilenameUrlEncoded__c = 'url1', Property_hz__c = testProperty.Id);
        PropertyMedia__c testMedia2 = new PropertyMedia__c(FilenameUrlEncoded__c = 'url2', Property_hz__c = testProperty.Id);
        insert new List<PropertyMedia__c>{testMedia1, testMedia2};

        testListing.Property_hz__c = testProperty.Id;
        update testListing;

        Test.startTest();
        Test.setCurrentPageReference(new PageReference('/apex/YourVisualforcePage?id=' + testListing.Id));
        ApexPages.StandardController controller = new ApexPages.StandardController(testListing);
        PdfGenerator pdfGen = new PdfGenerator(controller);

        System.assertEquals('url1', pdfGen.link1);
        System.assertEquals('url2', pdfGen.link2);

        String result = PdfGenerator.sendPdf(testListing.Id, 'Single_Pdf');
        System.assertEquals('Success', result);


        Test.stopTest();
    }

    @isTest
    static void testGetTemplateRecords() {
        List<Template__c> templateRecords = new List<Template__c>();
        templateRecords.add(new Template__c(Name = 'Test Template', HTML__c = '<html><body></body></html>', CSS__c = 'body {}', Status__c = 'Published', Subject__c = 'Test Subject', Type__c = 'pdf_template'));
        insert templateRecords;

        Test.startTest();
        List<Template__c> retrievedTemplates = PdfGenerator.getTemplateRecords();
        Test.stopTest();

        System.assertEquals(templateRecords.size(), retrievedTemplates.size());
        System.assertEquals(templateRecords[0].Name, retrievedTemplates[0].Name);
        System.assertEquals(templateRecords[0].HTML__c, retrievedTemplates[0].HTML__c);
        System.assertEquals(templateRecords[0].CSS__c, retrievedTemplates[0].CSS__c);
        System.assertEquals(templateRecords[0].Status__c, retrievedTemplates[0].Status__c);
        System.assertEquals(templateRecords[0].Subject__c, retrievedTemplates[0].Subject__c);
        System.assertEquals(templateRecords[0].Type__c, retrievedTemplates[0].Type__c);
    }

    @isTest
    static void testSendPdf() {
        Listing_hz__c testListing = new Listing_hz__c(Name = 'Test Listing');
        insert testListing;

        Test.startTest();
        String result = PdfGenerator.sendPdf(testListing.Id, 'Single_Pdf');
        String result1 = PdfGenerator.sendPdf(testListing.Id, 'CreatePdf');
        String result2 = PdfGenerator.sendPdf(testListing.Id, 'ComparableMarketAnalysis');
        String result3 = PdfGenerator.sendPdf(testListing.Id, 'Multiple_page');
        
        System.assertEquals('Success', result);
    }
    // @isTest
    // static void testPdfGenerator() {
    //     Listing_hz__c testListing = new Listing_hz__c(Name = 'Test Listing');
    //     insert testListing;
        
    //     Property_hz__c testProperty = new Property_hz__c(Name = 'Test Property');
    //     insert testProperty;
        
    //     PropertyMedia__c testMedia = new PropertyMedia__c(FilenameUrlEncoded__c = 'test_url', Property_hz__c = testProperty.Id);
    //     insert testMedia;

    //     ListingProperty__c testListingProperty = new ListingProperty__c(Listing_hz__c = testListing.Id, Property_hz__c = testProperty.Id);
    //     insert testListingProperty;

    //     PageReference pageRef = Page.Single_Pdf;
    //     Test.setCurrentPage(pageRef);
    //     ApexPages.currentPage().getParameters().put('id', testListing.Id);

    //     Test.startTest();
    //     ApexPages.StandardController stdController = new ApexPages.StandardController(testListing);
    //     PdfGenerator controller = new PdfGenerator(stdController);
    //     Test.stopTest();

    //     System.assertEquals(testListing.Id, controller.currentListing.Id);
    //     System.assertEquals(testProperty.Name, controller.link1);
    //     System.assertEquals('test_url', controller.link2);
    // }

}