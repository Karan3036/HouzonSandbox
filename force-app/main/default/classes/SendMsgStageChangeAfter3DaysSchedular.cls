global with sharing class SendMsgStageChangeAfter3DaysSchedular implements Schedulable{
    global void execute(SchedulableContext sc) {

        SendMsgStageChangeAfter3Days batch = New SendMsgStageChangeAfter3Days();
               database.executeBatch(batch,200);
    }
}