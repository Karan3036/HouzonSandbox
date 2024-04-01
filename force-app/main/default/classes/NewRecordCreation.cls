public with sharing class NewRecordCreation {

   @AuraEnabled(cacheable=true)
   public static contactWrapper fetchContact(Contact con){
       try {
           contactWrapper wrap = new contactWrapper();

           List<Contact> conlst = new List<Contact>();
           if((con.FirstName != null && con.FirstName != '') || (con.LastName != null && con.LastName != '') || (con.MobilePhone != null && con.MobilePhone != '') || (con.Phone != null && con.Phone != '')){
               String query = 'SELECT Id, Salutation, LastName, FirstName, Name, Email, MobilePhone, Phone, CompanyName__c, LeadSource FROM Contact WHERE ';
               if(con.FirstName != null && con.FirstName != '') query += ' FirstName LIKE \'%' + con.FirstName + '%\' AND ';
               if(con.LastName != null && con.LastName != '') query += ' LastName LIKE \'%' + con.LastName + '%\' AND ';
               if(con.MobilePhone != null && con.MobilePhone != '') query += ' MobilePhone LIKE \'%' + con.MobilePhone + '%\' AND ';
               if(con.Phone != null && con.Phone != '') query += ' Phone LIKE \'%' + con.Phone + '%\' AND ';
               query = query.removeEnd(' AND ');
               conlst = Database.query(query);
           }

           Integer count = 0;
           List<Contact> dupliem = new List<Contact>();
           Set<Contact> conSet = new Set<Contact>();
           if(con.Email != null && con.Email != ''){
               String fname = con.FirstName;
               String lname = con.LastName;
               count = [SELECT Id, Name, Email FROM Contact WHERE Email =:con.Email].size();
               dupliem = [SELECT Id, Salutation, LastName, FirstName, Name, Email, MobilePhone, Phone, CompanyName__c	, LeadSource FROM Contact WHERE Email LIKE: '%'+con.Email+'%'];
           }
           dupliem.addAll(conlst);
           conSet.addAll(dupliem);
           
           List<Contact> finalcon = new List<Contact>();
           finalcon.addAll(conSet);

           wrap.contactList = conlst;
           wrap.contactCount = count;
           wrap.duplicateEmail =  finalcon;
           
           return wrap;
       } catch (Exception e) {
           System.debug(e.getLineNumber() + '---' +e.getStackTraceString() +'---' +e.getMessage());
           return null;
       }
   }

     @AuraEnabled(cacheable=true)
   public static List<Contact> getContacts(Id conId){
       
       List<Contact> conlst = [SELECT Id,FirstName,LastName,Salutation,Email,CompanyName__c,MobilePhone,LeadSource,Phone FROM Contact WHERE Id =: conId];
       return conlst;
   }



   //Method to get recordType
   @AuraEnabled(cacheable=true)
   public static string getRecordType(String type){
       try {
           if(type == 'Rent'){
               return Schema.SObjectType.Listing_hz__c.getRecordTypeInfosByName().get('Rent').getRecordTypeId(); 
           }
           else if(type == 'Sale'){    
               return Schema.SObjectType.Listing_hz__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
           }    
           else{
               return null;
           }
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }

    //Method to fetch listings
    @AuraEnabled(cacheable=true)
    public static Map<String,List<Listing_hz__c>> fetchListings(Property_hz__c	 listin){

        
        try {
            String query = '';
            if( (listin.Name != null && listin.Name != '') || String.isNotBlank(listin.Address_hz__c) || String.isNotBlank(listin.City_hz__c)){
                query = 'SELECT Id, Name,Address_hz__c,City_hz__c,PropertyType__c,(Select id, Name from Listings__r) FROM Property_hz__c WHERE ';
                if(String.isNotBlank(listin.Name))query += ' Name LIKE \'%'+listin.Name+'%\' AND ';
                if(String.isNotBlank(listin.Address_hz__c))query += ' Address_hz__c LIKE \'%'+listin.Address_hz__c+'%\' AND ';
                if(String.isNotBlank(listin.City_hz__c))query += ' City_hz__c LIKE \'%'+listin.City_hz__c+'%\' AND ';
                query = query.removeEnd(' AND ');
                System.debug('query>>>'+query);
                
            }
                List<Property_hz__c> listinglst = Database.query(query);
                System.debug('listinglst>>>'+listinglst);
                Map<String,List<Listing_hz__c>> lstMap = new Map<String,List<Listing_hz__c>>();
                List<Listing_hz__c> lstIds = new List<Listing_hz__c>();
                String addrField;

                for(Property_hz__c c:listinglst){   
                    if(c.Listings__r!=null && !c.Listings__r.isEmpty()){
                        for(Listing_hz__c p : c.Listings__r){

                            if(c.City_hz__c!=null && c.City_hz__c!='' && String.isNotBlank(c.City_hz__c)){
                                addrField += c.City_hz__c + ', '; 
                            }
                            else{
                                addrField += '';
                            }

                            if(c.Address_hz__c!=null && c.Address_hz__c!='' && String.isNotBlank(c.Address_hz__c)){
                                addrField += c.Address_hz__c + ', '; 
                            }
                            else{
                                addrField += '';
                            }

                            System.debug('addrField>>>'+addrField);
                            if(!lstMap.containsKey(c.Id+'::'+c.Name+'::'+addrField)){
                                
                                lstMap.put(c.Id+'::'+c.Name+'::'+addrField,new List<Listing_hz__c>());
                            }
                            lstMap.get(c.Id+'::'+c.Name+'::'+addrField).add(p);  
                        }
                    }
                    else{
                        System.debug('else');

                        if(c.City_hz__c!=null && c.City_hz__c!='' && String.isNotBlank(c.City_hz__c)){
                            addrField += c.City_hz__c + ', '; 
                        }
                        else{
                            addrField += '';
                        }

                        if(c.Address_hz__c!=null && c.Address_hz__c!='' && String.isNotBlank(c.Address_hz__c)){
                            addrField += c.Address_hz__c + ', '; 
                        }
                        else{
                            addrField += '';
                        }
                        lstMap.put(c.Id+'::'+c.Name+'::'+addrField,new List<Listing_hz__c>());
                        System.debug('lstMap====>'+lstMap);
                    }
                }
                System.debug('lstMap>>>'+lstMap);
                return lstMap;
            
        } catch (Exception e) {
            System.debug('error-->>'+e.getMessage()+'---'+e.getStackTraceString());
            return null;
            
        }
    }

    //Method to get list of properties
    @AuraEnabled(cacheable=true)
    public static List<Property_hz__c> getListings(Id lisId){
        
        List<Property_hz__c> proplst = [SELECT Id,Name,City_hz__c,Address_hz__c,Bedrooms_hz__c,PropertyType__c FROM Property_hz__c WHERE Id =: lisId];
        return proplst;
    }

  

    @AuraEnabled
    public static List<Listing_hz__c> createListingRecord(String recordType, String aptnumname, String city, String propId, 
                                           String bedrooms, String proptype, String address) {
        try {
            // Create a new Listing record
            System.debug('recordType ==>' + recordType);
            Id listingrecordTypeId = SObjectType.Listing_hz__c.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();
            System.debug('listingrecordTypeId ==>' + listingrecordTypeId);

            List<Listing_hz__c> listingrec = new List<Listing_hz__c>();
            Listing_hz__c newListing = new Listing_hz__c();
            newListing.RecordTypeId = listingrecordTypeId; // Set Record Type Id
            newListing.Name = aptnumname;
            newListing.City_hz__c = city;
            newListing.Property_hz__c = propId;
            newListing.Address_hz__c = address;
            if(bedrooms != ''){
                newListing.Bedrooms_hz__c = Integer.valueOf(bedrooms); // Assuming Bedrooms is a Number field
            }
            newListing.PropertyType__c = proptype;

            if(propId == null){
                List<Property_hz__c> properties = new List<Property_hz__c>();
                Property_hz__c property = new Property_hz__c();
                property.Name = aptnumname;
                property.Address_hz__c = address;
                property.City_hz__c = city;
                property.RecordTypeId = SObjectType.Property_hz__c.getRecordTypeInfosByDeveloperName().get('Property').getRecordTypeId();
                if(bedrooms != ''){
                    property.Bedrooms_hz__c = Integer.valueOf(bedrooms); // Assuming Bedrooms is a Number field
                }
                properties.add(property);
                if (properties!=null){
                    insert properties;
                    newListing.Property_hz__c = properties[0].Id;
                }
            }

            // Insert the new Listing record
            listingrec.add(newListing);

            insert listingrec;

            return listingrec;
        } catch (Exception e) {
            // Handle any exceptions
            System.debug('Error creating listing record: ' + e.getMessage());
            // throw new AuraHandledException('Error creating listing record: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled
    public static Contact createContact(Map<String, Object> contactObj) {
        try {
            // Extract contact details from the passed map
            String firstName = (String) contactObj.get('FirstName');
            String lastName = (String) contactObj.get('LastName');
            String email = (String) contactObj.get('Email');
            String salutation = (String) contactObj.get('Salutation');
            String company = (String) contactObj.get('Company');
            String mobilePhone = (String) contactObj.get('MobilePhone');
            String phone = (String) contactObj.get('Phone');
            String leadSource = (String) contactObj.get('LeadSource');
            
            // Create new contact
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Salutation = salutation,
                CompanyName__c = company,
                MobilePhone = mobilePhone,
                Phone = phone,
                LeadSource = leadSource
            );
            
            // Insert the new contact record
            insert newContact;
            
            // Return the created contact record
            return newContact;
        } catch (Exception e) {
            // Handle any exceptions
            throw new AuraHandledException('Error creating contact: ' + e.getMessage());
        }
    }

    public class contactWrapper{
        @AuraEnabled
        public List<Contact> contactList {get;set;}
        @AuraEnabled
        public Integer contactCount {get;set;}
        @AuraEnabled
        public List<Contact> duplicateEmail {get;set;}
    }

    public class abRequest{
        
        // Contact Variable
        @AuraEnabled
        public string contactSalutation{get;set;}
        @AuraEnabled
        public String contactFirstName{get;set;}
        @AuraEnabled
        public String contactLastName{get;set;}
        @AuraEnabled
        public String contactEmail{get;set;}
        @AuraEnabled
        public String contactCompany{get;set;}
        @AuraEnabled
        public String contactMobilePhone{get;set;}
        @AuraEnabled
        public String contactPhone{get;set;}
        @AuraEnabled
        public String contactLeadSource{get;set;}
        @AuraEnabled
        public String contactId{get;set;}
        
        // Listing Variable
        @AuraEnabled
        public String listingRecordType{get;set;}
        @AuraEnabled
        public String listingCity{get;set;}
        @AuraEnabled
        public String listingtitle{get;set;}
        @AuraEnabled
        public String listingaddress{get;set;}
        @AuraEnabled
        public String listingPropertyId{get;set;}
        @AuraEnabled
        public String listingAppName{get;set;}
        @AuraEnabled
        public String listingStreetNumName{get;set;}
        @AuraEnabled
        public String listingStreet{get;set;}
        @AuraEnabled
        public String listingArea{get;set;}
        @AuraEnabled
        public String listingState{get;set;}
        @AuraEnabled
        public String listingZipcode{get;set;}
        @AuraEnabled
        public String listingBedrooms{get;set;}
        @AuraEnabled
        public String listingAssignedTo{get;set;}
        @AuraEnabled
        public String listingPropertyType{get;set;}
        @AuraEnabled
        public String listingappsource{get;set;}

 
    }
}