public class TimeHelper {

    // Method to create Time records for Project Budget
    public static void createTimeBudget(Project_Budget__c budget) {
        Id projectId = budget.Project__c;
        Project__c project = [SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Id = :projectId LIMIT 1];
        
        List<Time__c> timesToCreate = new List<Time__c>();

        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            Decimal budgetHours = isWeekend(dateIter) ? null : budget.Budget_hrs_weekday__c;

            Time__c newTime = new Time__c();
            newTime.Project_Budget__c = budget.Id;
            newTime.Project__c = projectId;
            newTime.Date__c = dateIter;
            newTime.Budget_hrs__c = budgetHours;
            newTime.Type__c = 'Budget';
            newTime.Category__c = 'Project Budget';
            newTime.Key__c = generateKey(newTime);

            timesToCreate.add(newTime);
        }

        if (!timesToCreate.isEmpty()) {
            insert timesToCreate;
            createProjectBudgetRollups(budget, timesToCreate);
        }
    }

    // Method to update Time records for Project Budget when Budget or Budget_dphr__c changes
    public static void updateTimeBudget(Project_Budget__c budget) {
        List<Time__c> existingTimes = [SELECT Id, Date__c, Budget_hrs__c 
                                       FROM Time__c 
                                       WHERE Project_Budget__c = :budget.Id];

        List<Time__c> timesToUpdate = new List<Time__c>();

        for (Time__c timeRecord : existingTimes) {
            Decimal budgetHours = isWeekend(timeRecord.Date__c) ? null : budget.Budget_hrs_weekday__c;
            timeRecord.Budget_hrs__c = budgetHours;
            timesToUpdate.add(timeRecord);
        }

        if (!timesToUpdate.isEmpty()) {
            update timesToUpdate;
        }
    }

    // Method to delete Time records associated with a Project Budget
    public static void deleteTimesForProjectBudget(Project_Budget__c budget) {
        List<Time__c> timesToDelete = [SELECT Id FROM Time__c WHERE Project_Budget__c = :budget.Id];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }
    }

    // Method to create Time records for Project Role
    public static void createTimeRole(Project_Role__c role) {
        Id projectId = role.Project__c;
        Project__c project = [SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Id = :projectId LIMIT 1];
        
        List<Time__c> timesToCreate = new List<Time__c>();

        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            Decimal plannedHours = isWeekend(dateIter) ? null : role.Default_hrs_weekday__c;

            Time__c newTime = new Time__c();
            newTime.Project_Role__c = role.Id;
            newTime.Project__c = projectId;
            newTime.Date__c = dateIter;
            newTime.Planned_hrs__c = plannedHours;
            newTime.Type__c = 'Planned';
            newTime.Category__c = 'Project Role';
            newTime.Key__c = generateKey(newTime);

            timesToCreate.add(newTime);
        }

        if (!timesToCreate.isEmpty()) {
            insert timesToCreate;
            createProjectRoleRollups(role, timesToCreate);
        }
    }

    // Method to delete Time records associated with a Project Role
    public static void deleteTimesForProjectRole(Project_Role__c role) {
        List<Time__c> timesToDelete = [SELECT Id FROM Time__c WHERE Project_Role__c = :role.Id];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }
    }

    // Placeholder method for Project Resource
    public static void createTimeResource(Project_Resource__c resource) {
        /* save for later */
    }

    // Placeholder method for Project Task
    public static void createTimeTask(Project_Task__c task) {
        /* save for later */
    }

    // Method to create rollups for Project Budget Time records
    private static void createProjectBudgetRollups(Project_Budget__c budget, List<Time__c> times) {
        List<Project_Budget_Rollup__c> rollupsToCreate = new List<Project_Budget_Rollup__c>();

        for (Time__c timeRecord : times) {
            Project_Budget_Rollup__c newRollup = new Project_Budget_Rollup__c();
            newRollup.Time__c = timeRecord.Id;
            newRollup.Project_Budget__c = budget.Id;
            newRollup.Budget_hrs__c = timeRecord.Budget_hrs__c;
            rollupsToCreate.add(newRollup);
        }

        if (!rollupsToCreate.isEmpty()) {
            insert rollupsToCreate;
        }
    }

    // Method to create rollups for Project Role Time records
    private static void createProjectRoleRollups(Project_Role__c role, List<Time__c> times) {
        List<Project_Role_Rollup__c> rollupsToCreate = new List<Project_Role_Rollup__c>();

        for (Time__c timeRecord : times) {
            Project_Role_Rollup__c newRollup = new Project_Role_Rollup__c();
            newRollup.Time__c = timeRecord.Id;
            newRollup.Project_Role__c = role.Id;
            newRollup.Planned_hrs__c = timeRecord.Planned_hrs__c;
            rollupsToCreate.add(newRollup);
        }

        if (!rollupsToCreate.isEmpty()) {
            insert rollupsToCreate;
        }
    }


    // Method to update rollup objects when a Time__c record is updated
    public static void updateRollupsForTime(Time__c timeRecord) {
        if (timeRecord.Project_Budget__c != null) {
            updateProjectBudgetRollup(timeRecord);
        } else if (timeRecord.Project_Role__c != null) {
            updateProjectRoleRollup(timeRecord);
        }
    }

    // Method to update Project_Budget_Rollup__c for a given Time__c record
    private static void updateProjectBudgetRollup(Time__c timeRecord) {
        Project_Budget_Rollup__c budgetRollup = [SELECT Id, Budget_hrs__c 
                                                 FROM Project_Budget_Rollup__c 
                                                 WHERE Time__c = :timeRecord.Id 
                                                 LIMIT 1];
        if (budgetRollup != null) {
            budgetRollup.Budget_hrs__c = timeRecord.Budget_hrs__c;
            update budgetRollup;
        }
    }

    // Method to update Project_Role_Rollup__c for a given Time__c record
    private static void updateProjectRoleRollup(Time__c timeRecord) {
        Project_Role_Rollup__c roleRollup = [SELECT Id, Planned_hrs__c 
                                             FROM Project_Role_Rollup__c 
                                             WHERE Time__c = :timeRecord.Id 
                                             LIMIT 1];
        if (roleRollup != null) {
            roleRollup.Planned_hrs__c = timeRecord.Planned_hrs__c;
            update roleRollup;
        }
    }


    // Helper method to check if a given date is a weekend
    private static Boolean isWeekend(Date dateValue) {
        Datetime dateTimeValue = Datetime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
        String dayOfWeek = dateTimeValue.format('EEEE');
        return dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday';
    }

    // Helper method to generate a unique key for Time records
    private static String generateKey(Time__c timeRecord) {
        return String.valueOf(timeRecord.Date__c) + '.' +
               String.valueOf(timeRecord.Category__c) + '.' +
               String.valueOf(timeRecord.Type__c) + '.' +
               String.valueOf(timeRecord.Project__c) + '.' +
               String.valueOf(timeRecord.Project_Budget__c) + '.' +
               String.valueOf(timeRecord.Project_Role__c);
    }
}