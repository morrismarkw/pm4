trigger ProjectRoleTrigger on Project_Role__c (after insert, after delete) {
    if (Trigger.isInsert) {
        for (Project_Role__c role : Trigger.new) {
            TimeHelper.createTimeRole(role);
        }
    } else if (Trigger.isDelete) {
        for (Project_Role__c role : Trigger.old) {
            TimeHelper.deleteTimesForProjectRole(role);
        }
    }
}