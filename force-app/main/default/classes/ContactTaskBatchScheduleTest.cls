@isTest
public class ContactTaskBatchScheduleTest {
    
     @isTest static void testMethod1(){
         
        ContactTaskBatchSchedule contactTaskSchedule = new ContactTaskBatchSchedule();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, contactTaskSchedule); 
    }  

}