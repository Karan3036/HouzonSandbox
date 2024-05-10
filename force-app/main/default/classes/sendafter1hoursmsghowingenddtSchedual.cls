global class sendafter1hoursmsghowingenddtSchedual  implements Schedulable{
   
    global void execute(SchedulableContext sc) {
        sendafter1hoursmsghowingenddt batch = New sendafter1hoursmsghowingenddt();
             database.executeBatch(batch,200);
   }
}