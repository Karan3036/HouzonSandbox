@isTest
private class PdfGeneratorTest {

    @isTest
    static void testPdfGenerator() {

        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra', MobilePhone = '+919326582649',AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Withdrawn';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
        listingRecord1.Description_hz__c='Testing Area';
        listingRecord1.PropertySubType_hz__c='Industrial';
        listingRecord1.Property_Sub_Type__c='Residential - Apartment';
        listingRecord1.RERA_Permit_Number__c='100';
        listingRecord1.TotalArea_hz__c=1000;
        listingRecord1.Sub_Community_Propertyfinder__c='Test';
        listingRecord1.Community_Propertyfinder__c='Test';
        listingRecord1.Property_Propertyfinder__c='Test';
        listingRecord1.LocationText_Dubizzle__c='Test';
        listingRecord1.City_Propertyfinder__c='test';
        listingRecord1.Price_Unit__c='Price Yearly';
        listingRecord1.Completion_Status__c='Completed';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        listingRecord1.Houzon_Broker_s_Listing_ID__c='Test';
        listingRecord1.Propertyfinder_Region__c = 'Dubai - Dubai Hills Estate - Emerald Hills';
        insert listingRecord1;

        Property_hz__c testProperty = new Property_hz__c(Name = 'Test Property');
        insert testProperty;

        PropertyMedia__c testMedia1 = new PropertyMedia__c(FilenameUrlEncoded__c = 'url1', Property_hz__c = testProperty.Id);
        PropertyMedia__c testMedia2 = new PropertyMedia__c(FilenameUrlEncoded__c = 'url2', Property_hz__c = testProperty.Id);
        insert new List<PropertyMedia__c>{testMedia1, testMedia2};

        listingRecord1.Property_hz__c = testProperty.Id;
        update listingRecord1;

        Test.startTest();
        Test.setCurrentPageReference(new PageReference('/apex/YourVisualforcePage?id=' + listingRecord1.Id));
        ApexPages.StandardController controller = new ApexPages.StandardController(listingRecord1);
        PdfGenerator pdfGen = new PdfGenerator(controller);

        String result = PdfGenerator.sendPdf(listingRecord1.Id, 'Single_Pdf');


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
    }

    @isTest
    static void testSendPdf() {
       
        Account testAccount1 = new Account(Name='Test Account 1');
        insert testAccount1;

        Contact testContact1 = new Contact(FirstName='Vansh', LastName='Mehra',MobilePhone = '+919326582649', AccountId=testAccount1.Id,ContactType_hz__c='Landlord',Stage__c='Active',Stage_hz__c='Off-Market', Email='vansh@houzon.com');
        insert testContact1;  

        Listing_hz__c listingRecord1 = new Listing_hz__c();
        listingRecord1.Name = 'Test1';
        listingRecord1.Status__c = 'Withdrawn';
        listingRecord1.ListingType__c = 'Rental';
        listingRecord1.PropertyType__c = 'Apartment';
        listingRecord1.Bedrooms_hz__c = 2;
        listingRecord1.FullBathrooms_hz__c = 2;
        listingRecord1.ListingPrice_hz__c = 1000;
        listingRecord1.City_hz__c = 'Test';
        listingRecord1.State_hz__c = 'Test';
        listingRecord1.Broker_s_Listing_ID__c='Test';
        listingRecord1.Description_hz__c='Testing Area';
        listingRecord1.PropertySubType_hz__c='Industrial';
        listingRecord1.Property_Sub_Type__c='Residential - Apartment';
        listingRecord1.RERA_Permit_Number__c='100';
        listingRecord1.TotalArea_hz__c=1000;
        listingRecord1.Sub_Community_Propertyfinder__c='Test';
        listingRecord1.Community_Propertyfinder__c='Test';
        listingRecord1.Property_Propertyfinder__c='Test';
        listingRecord1.LocationText_Dubizzle__c='Test';
        listingRecord1.City_Propertyfinder__c='test';
        listingRecord1.Price_Unit__c='Price Yearly';
        listingRecord1.Completion_Status__c='Completed';
        listingRecord1.City_Dubizzle__c='Test';
        listingRecord1.Property_Status__c='Vacant on Transfer';
        listingRecord1.Available_from__c=date.today()+1;
        listingRecord1.CompletionDate_hz__c=date.today()+1;
        listingRecord1.property_category__c='Commercial';
        listingRecord1.PropertyOwnerContact__c=testContact1.Id;
        listingRecord1.Houzon_Broker_s_Listing_ID__c='Test1';
        listingRecord1.Propertyfinder_Region__c = 'Dubai - Dubai Hills Estate - Emerald Hills';
        insert listingRecord1;


        Test.startTest();
        String result = PdfGenerator.sendPdf(listingRecord1.Id, 'Single_Pdf');
        String result1 = PdfGenerator.sendPdf(listingRecord1.Id, 'CreatePdf');
        String result2 = PdfGenerator.sendPdf(listingRecord1.Id, 'ComparableMarketAnalysis');
        String result3 = PdfGenerator.sendPdf(listingRecord1.Id, 'Multiple_page');
        
    }
  

}