trigger ProjectBudgetTrigger on Project_Budget__c (after insert, after update, before delete) {
    if (Trigger.isInsert) {
        for (Project_Budget__c budget : Trigger.new) {
            TimeHelper.createTimeBudget(budget);
        }
    } else if (Trigger.isUpdate) {
        for (Project_Budget__c budget : Trigger.new) {
            // Check if relevant fields have changed
            Project_Budget__c oldBudget = Trigger.oldMap.get(budget.Id);
            if (budget.Selected_Budget__c != oldBudget.Selected_Budget__c || budget.Selected_Budget_hrs__c != oldBudget.Selected_Budget_hrs__c) {
                TimeHelper.updateTimeBudget(budget);
            }
        }
    } else if (Trigger.isBefore && Trigger.isDelete) {
        for (Project_Budget__c budget : Trigger.old) {
            TimeHelper.deleteTimesForProjectBudget(budget);
        }
    }
}