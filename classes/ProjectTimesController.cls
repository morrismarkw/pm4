public with sharing class ProjectTimesController {

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecordsForType(String objectApiName, Id projectId) {
        String query = 'SELECT Id, Nickname__c FROM ' + objectApiName + ' WHERE Project__c = :projectId';
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<Time__c> getTimeRecordsForType(String parentObjectApiName, Id parentRecordId) {
        //String fieldToQuery = (parentObjectApiName == 'Project_Budget__c') ? 'Budget_hrs__c' : 'Planned_hrs__c';
        //String fieldToQuery = '';
    
        String query = 'SELECT Id, Date__c, Budget_hrs__c, Planned_hrs__c, ' + 
                       'Is_Future__c, Is_Future_and_Today__c, Is_Last_Month__c, Is_Last_Week__c, ' +
                       'Is_Next_Month__c, Is_Next_Week__c, Is_Past__c, Is_This_Month__c, ' +
                       'Is_This_Week__c, Is_This_Year__c, Is_Today__c, Is_Weekday__c ' +
                       'FROM Time__c WHERE ' + parentObjectApiName + ' = :parentRecordId';
    
        List<Time__c> timeRecords = Database.query(query);
        return timeRecords;
    }
}