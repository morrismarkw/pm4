trigger ProjectTaskTrigger on Project_Task__c (after insert, after update) {
    if (Trigger.isInsert) {
        for (Project_Task__c task : Trigger.new) {
      //      TimeHelper.createTimePlanned(task, 'Planned', 'Project Task');
        }
    }
}