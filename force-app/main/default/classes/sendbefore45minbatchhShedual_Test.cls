@isTest
public class sendbefore45minbatchhShedual_Test {

    @istest
    public static void  testschedule() {
    Test.StartTest();
    sendbefore45minbatchhShedual sh1 = new sendbefore45minbatchhShedual();      
    String sch = '0 5 * * * ?';
    system.schedule('Test check', sch, sh1);
    Test.stopTest();
    }
}