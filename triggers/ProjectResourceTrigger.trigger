trigger ProjectResourceTrigger on Project_Resource__c (after insert, before delete) {
    if (Trigger.isInsert) {
        for (Project_Resource__c resource : Trigger.new) {
            TimeHelper.createTimeResource(resource);
        }
    } else if (Trigger.isBefore && Trigger.isDelete) {
        for (Project_Resource__c resource : Trigger.old) {
            TimeHelper.deleteTimesForProjectResource(resource);
        }
    }
}