@isTest(seeAllData=false)
public class ContactTaskBatchTest {
    
    static testMethod void testMethod1(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'sttst2', Email='standarduser1@tesorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, MobilePhone = '+91 9326582649', Phone = '+919326582649',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@tesorg.com', ManagerId = UserInfo.getUserId());
        Insert u;
        System.runAs(u) {

            Contact con = new Contact();
            con.LastName='Test con';
            con.OwnerId=u.Id;
            con.MobilePhone='1211111111';
            con.ContactType_hz__c='Seller';
            con.Stage__c='Documents Received';
            con.OtherStreet='Oyo Flagship 37731 Road';
            con.OtherCity='Nanekarwadi';
            con.OtherState='MH';
            /*con.MailingStreet = 'Test';
            con.MailingCity = 'Test';
            con.MailingCountry = 'Test';*/
            con.OtherPostalCode='410501';
            con.OtherCountry='India';
            insert con;
            
            con.Stage__c = 'Active';
            update con;
            
            con.Stage__c = 'Documents Received';
            update con;


            // Test.StartTest();
            ContactTaskBatch obj = new ContactTaskBatch();
            ID batchprocessid = DataBase.executeBatch(obj);             
            // Test.StopTest();


        }


    }

}