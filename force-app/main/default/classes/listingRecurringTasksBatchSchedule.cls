global class listingRecurringTasksBatchSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchProcessdId = Database.executeBatch(new listingRecurringTasksBatch());
    } 
}