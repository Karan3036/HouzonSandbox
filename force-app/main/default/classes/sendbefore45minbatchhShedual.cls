global class sendbefore45minbatchhShedual  implements Schedulable{
   
    global void execute(SchedulableContext sc) {

       sendbefore45minbatchh batch = New sendbefore45minbatchh();
       database.executeBatch(batch,200);
   }
}