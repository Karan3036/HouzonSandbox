@isTest
public class updateMultiSelectPicklistFieldTest {
    static testMethod void  testContactDeleteController()
    {
  
        Contact con = CreateContact('Test','Test','Landlord');
		con.Stage__c = 'Disqualified';
  		con.Reason_for_Lead_Disqualification__c = 'Agent';
        update con;
    }
    static Contact createContact(String fname, String lname, String contType) {
        
        Contact c = new Contact();
        c.FirstName = fname;
        c.LastName = lname;
        c.ContactType_hz__c = contType;
        c.Stage__c = 'Active';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingCountry = 'India';
        c.LeadSource = 'Open House';
        c.MobilePhone ='11122222222'; 
        insert c;

        c.ContactType_hz__c='Investor;Landlord';
        update c;

    
        Contact[] contactArray = new List<Contact>(); 
        contactArray.add(c);
        updateMultiSelectPicklistField.updateMSelectPickField(contactArray);
        return c;

        
    }
}