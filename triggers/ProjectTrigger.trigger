trigger ProjectTrigger on Project__c (after update) {
    for (Project__c project : Trigger.new) {
    //    if (project.Start_Date__c != Trigger.oldMap.get(project.Id).Start_Date__c || 
    //        project.End_Date__c != Trigger.oldMap.get(project.Id).End_Date__c) {
    //        TimeHelper.updateTimePlanned(project);
    //    }
    }
}