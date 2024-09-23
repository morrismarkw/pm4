trigger ProjectTaskTrigger on Project_Task__c (after insert, before delete) {
  if (Trigger.isInsert) {
      for (Project_Task__c task : Trigger.new) {
          TimeHelper.createTimeTask(task);
      }
  } else if (Trigger.isBefore && Trigger.isDelete) {
      for (Project_Task__c task : Trigger.old) {
          TimeHelper.deleteTimesForProjectTask(task);
      }
  }
}