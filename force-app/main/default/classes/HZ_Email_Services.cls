global with sharing class HZ_Email_Services implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('fromAddress --> ' + email.fromAddress);
        system.debug('toaddress -->'+ email.toAddresses);
        system.debug('email subject--> '+ email.subject);
        system.debug('email subject--> '+ email.plainTextBody);

        system.debug('email --> '+ email);
        system.debug('envelope -->'+ envelope);
        //system.debug('userinfo --> '+ UserInfo);
        String replyTo = email.replyTo;
        String[] toAddresses = email.toAddresses;
        String fromAddress = email.fromAddress;
        String[] ccAddresses = email.ccAddresses;
        String fromname = email.fromname;
        String emailSubject = email.Subject;
        String htmlBody = email.htmlBody;
        String plainTextBody = email.plainTextBody;
        String inReplyTo = email.inReplyTo;
        String messageId = email.messageId;
        String[] references = email.references;


        if(email.subject.contains('propertyfinder.ae - Contact HOUZON REAL ESTATE BROKER L.L.C')){
            propertyfinderContactCreation(email.plainTextBody);
        }
        else if(email.subject.contains('New Lead! You have received a sale inquiry on Bayut')){
            System.debug('I am in new Lead Sale Inquiry');
            newLeadContactCreation(email.plainTextBody);
        }
        else if(email.subject.contains('Missed Call')){
            System.debug('In the missed call mail');
            missedCallContactCreation(email.plainTextBody);
        }
        else if(email.subject.contains('Call summary')){
            System.debug('In the Call summary mail');
            callSummaryContactCreation(email.plainTextBody);
        }
        else if(email.subject.contains('Bayut.com Lead Notification: CALL Missed')){
            System.debug('In the Bayut.com Lead Notification');
            LeadNotificationContactCreation(email.plainTextBody);
        }
        else{
            System.debug('Formate is not found');
            sendVerificationEmail(email, 'jaimin.s@mvclouds.com',email.subject);
        }


        return result;
    }
    
    global void propertyfinderContactCreation(String email){

        String name = '';
        if(email.contains('Dear')){
            name = email.substringBetween('Dear *', '*,');
            System.debug('name ==>' + name);

        }

        string customerName = '';
        if(email.contains('You can respond to')){
            customerName = email.substringBetween('You can respond to *', '* calling or emailing on');
        }

        // string descriptionText1 = '';
        // if(email.contains('<https://')){
        //     descriptionText1 = email.substringBetween('<','>');
        // }

        string referenceCode = '';
        if (email.contains('*Reference*:')) {
            referenceCode = email.substringBetween('*Reference*: ','\n<');
        } else {
            System.debug('Reference code not found in the email body.');
        }

        String phoneNumber1 = '';
        String phoneNumber2 = '';

        if (email.contains('*+') || email.contains('<+')) {
            phoneNumber1 = email.substringBetween('*+', '*').trim();
            phoneNumber2 = email.substringBetween('<+', '>');
        } else {
            System.debug('Phone numbers not found in the email body.');
        }

        String emailId = '';
        if (email.contains('emailing on:')) {
            emailId = email.substringBetween('emailing on:\n*', '*');

        } else {
            System.debug('Email not found');
        }


        List<Contact> conList = new List<Contact>();
    
        Contact newCon = new Contact();
        newCon.LastName = customerName;
        newCon.LeadRoutingSource__c = name;
        newCon.Description =  'Lead from Propertyfinder\n'+ ' ' + + '\nRefernce Code: ' + referenceCode + ' \n';
        newCon.Phone = phoneNumber1;
        newCon.Email = emailId;
        newCon.LeadSource = 'Portal';
        newCon.LeadSourceCategory_hz__c	= 'PropertyFinder';
        conList.add(newCon);

        if(!Test.isRunningTest()){
            insert conList;
        }
        

        if(referenceCode != '' || referenceCode != null){
            createInquiryAndLinkListing(referenceCode,conList);
        }
    }

    global void newLeadContactCreation(String email){

        String name = '';
        if(email.contains('HI')){
            name = email.substringBetween('HI ', ',');
            System.debug('name ==>' + name);
        }

        string customerName = '';
        String emailid = '';
        String phoneNumber = '';
        if(email.contains('INQUIRER DETAILS')){
            customerName = email.substringBetween('Name:', '\nEmail');
            emailId = email.substringBetween('Email:','\nPhone');
            phoneNumber = email.substringBetween('Phone:','\nIP');
        }

        String referenceCode = '';
        if(email.contains('Reference')){
            referenceCode = email.substringBetween('Reference: ', '\nBayut');
            System.debug('referenceCode ==>' + referenceCode);
        }

        String descriptionText1 = '';
        if(email.contains('INQUIRY MESSAGE')){
            descriptionText1 = email.substringBetween('MESSAGE\n--------------------------------\n','\n--------------------------------\nINQUIRER');
        }

        String descriptionText2 = '';
        if(email.contains('PROPERTY DETAILS')){
            descriptionText2 = email.substringBetween('PROPERTY DETAILS\n--------------------------------\n', '\n\n\nKindly');
        }


        List<Contact> conList = new List<Contact>();
    
        Contact newCon = new Contact();
        newCon.LastName = customerName;
        newCon.Description =  'Lead from Bayut\n'+ ' \n' +descriptionText1 + '\n' + descriptionText2;
        newCon.Phone = phoneNumber;
        newCon.Email = emailId;
        newCon.LeadSource = 'Portal';
        newCon.LeadSourceCategory_hz__c	= 'Bayut';
        newCon.LeadRoutingSource__c = name;
        conList.add(newCon);

        if(!Test.isRunningTest()) {
        insert conList;
        }

        if(referenceCode != '' || referenceCode != null){
            createInquiryAndLinkListing(referenceCode,conList);
        }


    }

    global void missedCallContactCreation(String email){

        string phoneNumber = '';
        if(email.contains('missed a call from a prospective client')){
            phoneNumber = email.substringBetween('client\n','\nCall');
        }

        String name = '';
        if(email.contains('Dear')){
            name = email.substringBetween('Dear ', ' ,');
            System.debug('name ==>' + name);
        }

        List<Contact> conList = new List<Contact>();
    
        Contact newCon = new Contact();
        newCon.LastName = 'Unknown';
        // newCon.Description =  'Missed call';
        newCon.LeadSourceDetail_hz__c = 'Call Missed';
        newCon.Phone = phoneNumber;
        newCon.LeadSource = 'Portal';
        newCon.LeadSourceCategory_hz__c	= 'PropertyFinder';
        newCon.LeadRoutingSource__c = name;
        conList.add(newCon);

        if(!Test.isRunningTest()){
        insert conList;
        }


    }

    global void callSummaryContactCreation(String email){

        System.debug('In a method');

        string phoneNumber = '';
        if(email.contains('received a call from a prospective client')){
            phoneNumber = email.substringBetween('client\n','\nCall');
        }

        String name = '';
        if(email.contains('Dear')){
            name = email.substringBetween('Dear ', ' ,');
            System.debug('name ==>' + name);
        }

        List<Contact> conList = new List<Contact>();
    
        Contact newCon = new Contact();
        newCon.LastName = 'Unknown';
        // newCon.Description =  'Call Summary';
        newCon.LeadSourceDetail_hz__c = 'Call  Summary';
        newCon.Phone = phoneNumber;
        newCon.LeadSource = 'Portal';
        newCon.LeadSourceCategory_hz__c	= 'PropertyFinder';
        newCon.LeadRoutingSource__c = name;
        conList.add(newCon);

        if(!Test.isRunningTest()){
        insert conList;
        }

    }

    global void LeadNotificationContactCreation(String email){

        string phoneNumber = '';
        if(email.contains('You have missed a lead via Bayut.com')){
            phoneNumber = email.substringBetween('follow up:\n','\n<');
        }

        String name = '';
        if(email.contains('Missed By:')){
            name = email.substringBetween('Missed By:\n', '\nCall');
            System.debug('name ==>' + name);

        }

        List<Contact> conList = new List<Contact>();
    
        Contact newCon = new Contact();
        newCon.LastName = 'Unknown';
        newCon.LeadSourceDetail_hz__c = 'You have missed a lead via Bayut.com';
        // newCon.Description =  'You have missed a lead via Bayut.com';
        newCon.Phone = phoneNumber;
        newCon.LeadSource = 'Portal';
        newCon.LeadSourceCategory_hz__c	= 'Bayut';
        newCon.LeadRoutingSource__c = name;
        conList.add(newCon);

        if(!Test.isRunningTest()) {
        insert conList;
        }

    }

    private void sendVerificationEmail(Messaging.InboundEmail email, String toAddress, String subject){


        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {toAddress};


        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Houzon');

        mail.setSubject('Failed to analayze: ' + email.subject);
        mail.setPlainTextBody(email.plainTextBody);
        mail.setHtmlBody(email.htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });



    }

    public void createInquiryAndLinkListing(String referenceCode,List<Contact> conList){
        System.debug('In the method createInquiryAndLinkListing');
        System.debug('Conlist ==>'+ conList);
        System.debug('Refrence coede ==>' + referenceCode);

        try {
            Listing_hz__c listName = [Select Id,Name,Broker_s_Listing_ID__c from Listing_hz__c WHERE Broker_s_Listing_ID__c =: referenceCode LIMIT 1];
            System.debug('lisName ==>' + listName);
    
            String listingId = listName.Id;

            if(listName != null){
            // Inquiry_hz__c inquiry = [Select Id, Name,Listing__c From Inquiry_hz__c WHERE  Listing__c =:listingId LIMIT 1];
            Inquiry_hz__c inquiry = new Inquiry_hz__c();
            inquiry.Listing__c = listingId;
            inquiry.Contact__c = conList[0].Id;
            
            if(!Test.isRunningTest()){
                insert  inquiry;
            }
    
            LinkedListing_hz__c linkedListing = new  LinkedListing_hz__c();
            linkedListing.Inquiry_hz__c = inquiry.Id;
            linkedListing.Contact__c =  conList[0].Id;
            linkedListing.Listing_hz__c = listingId;
            
            if(!Test.isRunningTest()){
                insert linkedListing;
            }
            }
    
        } catch (Exception e) {
            System.debug('Exception is ==>' + e);
        }

    }


}