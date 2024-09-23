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

    // Method to delete Time records associated with a Project Resource
    public static void createTimeResource(Project_Resource__c resource) {
        Id projectId = resource.Project__c;
        Project__c project = [SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Id = :projectId LIMIT 1];
        
        List<Time__c> timesToCreate = new List<Time__c>();
    
        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            Decimal resourceHours = isWeekend(dateIter) ? null : resource.Default_hrs_weekday__c;
    
            Time__c newTime = new Time__c();
            newTime.Project_Resource__c = resource.Id;
            newTime.Project__c = projectId;
            newTime.Date__c = dateIter;
            newTime.Planned_hrs__c = resourceHours;
            newTime.Type__c = 'Planned';
            newTime.Category__c = 'Project Resource';
            newTime.Key__c = generateKey(newTime);
    
            timesToCreate.add(newTime);
        }
    
        if (!timesToCreate.isEmpty()) {
            insert timesToCreate;
            // Optionally, implement rollup logic here
        }
    }

    // Method to delete Time records associated with a Project Resource
    public static void deleteTimesForProjectResource(Project_Resource__c resource) {
        List<Time__c> timesToDelete = [SELECT Id FROM Time__c WHERE Project_Resource__c = :resource.Id];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }
    }    
    

    // Method to delete Time records associated with a Project Task
    public static void createTimeTask(Project_Task__c task) {
        Id projectId = task.Project__c;
        Project__c project = [SELECT Start_Date__c, End_Date__c FROM Project__c WHERE Id = :projectId LIMIT 1];
        
        List<Time__c> timesToCreate = new List<Time__c>();
    
        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            Decimal taskHours = isWeekend(dateIter) ? null : task.Default_hrs_weekday__c;
    
            Time__c newTime = new Time__c();
            newTime.Project_Task__c = task.Id;
            newTime.Project__c = projectId;
            newTime.Date__c = dateIter;
            newTime.Planned_hrs__c = taskHours;
            newTime.Type__c = 'Planned';
            newTime.Category__c = 'Project Task';
            newTime.Key__c = generateKey(newTime);
    
            timesToCreate.add(newTime);
        }
    
        if (!timesToCreate.isEmpty()) {
            insert timesToCreate;
            // Optionally, implement rollup logic here
        }
    }

    // Method to delete Time records associated with a Project Resource
     public static void deleteTimesForProjectTask(Project_Task__c task) {
        List<Time__c> timesToDelete = [SELECT Id FROM Time__c WHERE Project_Task__c = :task.Id];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }
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

    // Method to update Time records when Project dates change
    public static void updateProjectDates(Project__c project) {
        // Handle Project Budget Updates
        List<Project_Budget__c> projectBudgets = [SELECT Id, Budget_hrs_weekday__c 
                                                  FROM Project_Budget__c 
                                                  WHERE Project__c = :project.Id];
        
        for (Project_Budget__c budget : projectBudgets) {
            updateTimeForBudget(project, budget);
        }

        // Handle Project Role Updates
        List<Project_Role__c> projectRoles = [SELECT Id, Default_hrs_weekday__c 
                                              FROM Project_Role__c 
                                              WHERE Project__c = :project.Id];
        
        for (Project_Role__c role : projectRoles) {
            updateTimeForRole(project, role);
        }

        // Handle Project Resource Updates
        List<Project_Resource__c> projectResources = [SELECT Id, Default_hrs_weekday__c 
                                                      FROM Project_Resource__c 
                                                      WHERE Project__c = :project.Id];

        for (Project_Resource__c resource : projectResources) {
            updateTimeForResource(project, resource);
        }

        // Handle Project Task Updates
        List<Project_Task__c> projectTasks = [SELECT Id, Default_hrs_weekday__c 
                                              FROM Project_Task__c 
                                              WHERE Project__c = :project.Id];
        
        for (Project_Task__c task : projectTasks) {
            updateTimeForTask(project, task);
        }
    }

    // Method to update Time records for Project Budget when Project dates change
    private static void updateTimeForBudget(Project__c project, Project_Budget__c budget) {
        // Delete Times outside the new date range
        List<Time__c> timesToDelete = [SELECT Id 
                                       FROM Time__c 
                                       WHERE Project_Budget__c = :budget.Id 
                                       AND (Date__c < :project.Start_Date__c 
                                            OR Date__c > :project.End_Date__c)];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }

        // Create or Update Times within the new date range
        List<Time__c> timesToInsert = new List<Time__c>();
        List<Time__c> timesToUpdate = new List<Time__c>();

        Map<Date, Time__c> existingTimesMap = new Map<Date, Time__c>();
        for (Time__c timeRecord : [SELECT Id, Date__c, Budget_hrs__c 
                                   FROM Time__c 
                                   WHERE Project_Budget__c = :budget.Id 
                                   AND Date__c >= :project.Start_Date__c 
                                   AND Date__c <= :project.End_Date__c]) {
            existingTimesMap.put(timeRecord.Date__c, timeRecord);
        }

        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            if (existingTimesMap.containsKey(dateIter)) {
                Time__c timeRecord = existingTimesMap.get(dateIter);
                if (!isWeekend(dateIter)) {
                    timeRecord.Budget_hrs__c = budget.Budget_hrs_weekday__c;
                } else {
                    timeRecord.Budget_hrs__c = null;
                }
                timesToUpdate.add(timeRecord);
            } else {
                Time__c newTime = new Time__c();
                newTime.Project_Budget__c = budget.Id;
                newTime.Project__c = project.Id;
                newTime.Date__c = dateIter;
                newTime.Budget_hrs__c = isWeekend(dateIter) ? null : budget.Budget_hrs_weekday__c;
                newTime.Type__c = 'Budget';
                newTime.Category__c = 'Project Budget';
                newTime.Key__c = generateKey(newTime);
                timesToInsert.add(newTime);
            }
        }

        if (!timesToUpdate.isEmpty()) {
            update timesToUpdate;
        }
        
        if (!timesToInsert.isEmpty()) {
            insert timesToInsert;
        }
    }

    // Method to update Time records for Project Role when Project dates change
    private static void updateTimeForRole(Project__c project, Project_Role__c role) {
        // Delete Times outside the new date range
        List<Time__c> timesToDelete = [SELECT Id 
                                       FROM Time__c 
                                       WHERE Project_Role__c = :role.Id 
                                       AND (Date__c < :project.Start_Date__c 
                                            OR Date__c > :project.End_Date__c)];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }

        // Create Times within the new date range
        List<Time__c> timesToInsert = new List<Time__c>();

        Set<Date> existingDates = new Set<Date>();
        for (Time__c timeRecord : [SELECT Date__c 
                                   FROM Time__c 
                                   WHERE Project_Role__c = :role.Id 
                                   AND Date__c >= :project.Start_Date__c 
                                   AND Date__c <= :project.End_Date__c]) {
            existingDates.add(timeRecord.Date__c);
        }

        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            if (!existingDates.contains(dateIter)) {
                Time__c newTime = new Time__c();
                newTime.Project_Role__c = role.Id;
                newTime.Project__c = project.Id;
                newTime.Date__c = dateIter;
                newTime.Planned_hrs__c = isWeekend(dateIter) ? null : role.Default_hrs_weekday__c;
                newTime.Type__c = 'Planned';
                newTime.Category__c = 'Project Role';
                newTime.Key__c = generateKey(newTime);
                timesToInsert.add(newTime);
            }
        }

        if (!timesToInsert.isEmpty()) {
            insert timesToInsert;
        }
    }

    private static void updateTimeForResource(Project__c project, Project_Resource__c resource) {
        // Delete Times outside the new date range
        List<Time__c> timesToDelete = [SELECT Id 
                                       FROM Time__c 
                                       WHERE Project_Resource__c = :resource.Id 
                                       AND (Date__c < :project.Start_Date__c 
                                            OR Date__c > :project.End_Date__c)];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }
    
        // Create Times within the new date range
        List<Time__c> timesToInsert = new List<Time__c>();
        List<Time__c> timesToUpdate = new List<Time__c>();
    
        Map<Date, Time__c> existingTimesMap = new Map<Date, Time__c>();
        for (Time__c timeRecord : [SELECT Id, Date__c 
                                   FROM Time__c 
                                   WHERE Project_Resource__c = :resource.Id 
                                   AND Date__c >= :project.Start_Date__c 
                                   AND Date__c <= :project.End_Date__c]) {
            existingTimesMap.put(timeRecord.Date__c, timeRecord);
        }
    
        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            if (existingTimesMap.containsKey(dateIter)) {
                Time__c timeRecord = existingTimesMap.get(dateIter);
                if (!isWeekend(dateIter)) {
                    timeRecord.Planned_hrs__c = resource.Default_hrs_weekday__c;
                } else {
                    timeRecord.Planned_hrs__c = null;
                }
                timesToUpdate.add(timeRecord);
            } else {
                Time__c newTime = new Time__c();
                newTime.Project_Resource__c = resource.Id;
                newTime.Project__c = project.Id;
                newTime.Date__c = dateIter;
                newTime.Planned_hrs__c = isWeekend(dateIter) ? null : resource.Default_hrs_weekday__c;
                newTime.Type__c = 'Planned';
                newTime.Category__c = 'Project Resource';
                newTime.Key__c = generateKey(newTime);
                timesToInsert.add(newTime);
            }
        }
    
        if (!timesToUpdate.isEmpty()) {
            update timesToUpdate;
        }
        
        if (!timesToInsert.isEmpty()) {
            insert timesToInsert;
        }
    }
    
    private static void updateTimeForTask(Project__c project, Project_Task__c task) {
        // Delete Times outside the new date range
        List<Time__c> timesToDelete = [SELECT Id 
                                       FROM Time__c 
                                       WHERE Project_Task__c = :task.Id 
                                       AND (Date__c < :project.Start_Date__c 
                                            OR Date__c > :project.End_Date__c)];
        if (!timesToDelete.isEmpty()) {
            delete timesToDelete;
        }
    
        // Create Times within the new date range
        List<Time__c> timesToInsert = new List<Time__c>();
        List<Time__c> timesToUpdate = new List<Time__c>();
    
        Map<Date, Time__c> existingTimesMap = new Map<Date, Time__c>();
        for (Time__c timeRecord : [SELECT Id, Date__c 
                                   FROM Time__c 
                                   WHERE Project_Task__c = :task.Id 
                                   AND Date__c >= :project.Start_Date__c 
                                   AND Date__c <= :project.End_Date__c]) {
            existingTimesMap.put(timeRecord.Date__c, timeRecord);
        }
    
        for (Date dateIter = project.Start_Date__c; dateIter <= project.End_Date__c; dateIter = dateIter.addDays(1)) {
            if (existingTimesMap.containsKey(dateIter)) {
                Time__c timeRecord = existingTimesMap.get(dateIter);
                if (!isWeekend(dateIter)) {
                    timeRecord.Planned_hrs__c = task.Default_hrs_weekday__c;
                } else {
                    timeRecord.Planned_hrs__c = null;
                }
                timesToUpdate.add(timeRecord);
            } else {
                Time__c newTime = new Time__c();
                newTime.Project_Task__c = task.Id;
                newTime.Project__c = project.Id;
                newTime.Date__c = dateIter;
                newTime.Planned_hrs__c = isWeekend(dateIter) ? null : task.Default_hrs_weekday__c;
                newTime.Type__c = 'Planned';
                newTime.Category__c = 'Project Task';
                newTime.Key__c = generateKey(newTime);
                timesToInsert.add(newTime);
            }
        }
    
        if (!timesToUpdate.isEmpty()) {
            update timesToUpdate;
        }
        
        if (!timesToInsert.isEmpty()) {
            insert timesToInsert;
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
            String.valueOf(timeRecord.Project_Budget__r.Name) + '.' +
            String.valueOf(timeRecord.Project_Role__r.Name) + '.' +
            String.valueOf(timeRecord.Project_Resource__r.Name) + '.' +
            String.valueOf(timeRecord.Project_Task__r.Name);
    }
}