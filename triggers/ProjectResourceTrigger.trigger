trigger ProjectResourceTrigger on Project_Resource__c (after insert, after update) {
    if (Trigger.isInsert) {
        for (Project_Resource__c resource : Trigger.new) {
       //     TimeHelper.createTimePlanned(resource, 'Planned', 'Project Resource');
        }
    }
}