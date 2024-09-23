trigger TimeTrigger on Time__c (after update) {
    for (Time__c newTime : Trigger.new) {
        Time__c oldTime = Trigger.oldMap.get(newTime.Id);
        
        if (newTime.Budget_hrs__c != oldTime.Budget_hrs__c || 
            newTime.Planned_hrs__c != oldTime.Planned_hrs__c) {
            TimeHelper.updateRollupsForTime(newTime);
        }
    }
}