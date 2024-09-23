import { LightningElement, track } from 'lwc';

const generalTopics = [
    { topic: 'Project', term: 'Overview', description: 'The Project helps you track and manage the overall scope, budget, and time allocation for a project. It consolidates important metrics such as total budget, planned and utilized hours, and resource allocation. With detailed fields for duration, effective rates, and status indicators, this provides a comprehensive view of project progress, making it easier to monitor and adjust resources and timelines as needed.', object: 'Project' },
    { topic: 'Project Budgets', term: 'Overview', description: 'The Project Budgets help you allocate and track labor hours based on the dollar amounts from associated Opportunity Product Line Items. These amounts are converted into blended hours, which are evenly distributed across the project timeline, making it easier to manage and compare your planned labor hours against actual time spent.', object: 'Project Budget' },
    { topic: 'Project Roles', term: 'Overview', description: 'The Project Roles help you define and manage roles within a project, specifying planned labor for each role. By default, the planned hours are spread uniformly across the project’s timeline, but you can make manual adjustments as needed, making it easier to manage and compare your planned labor hours against both the project budget and actual time spent.', object: 'Project Roles' },
    { topic: 'Project Resources', term: 'Overview', description: 'The Project Resources help you define and manage resources within a project, specifying planned labor for each resource. By default, the planned hours are spread uniformly across the project’s timeline, but you can make manual adjustments as needed, making it easier to manage and compare your planned labor hours against both the project budget and actual time spent.', object: 'Project Resources' },
    { topic: 'Project Tasks', term: 'Overview', description: 'The Project Tasks help you manage specific tasks within a project that resources will use to bill their time. Tasks can be designated as billable or unbillable, providing a clear structure for tracking time entries and ensuring accurate billing and time management throughout the project.', object: 'Project Tasks' },
    { topic: 'Resources', term: 'Overview', description: 'The Resources help you track and manage individuals or teams who are assigned to projects. You can specify availability, assign them to roles and projects, and track their time utilization across various tasks and projects.', object: 'Resource' },
    { topic: 'Roles', term: 'Overview', description: 'The Roles help you categorize and manage different responsibilities and functions within your projects. You can define roles for resources, allocate planned hours, and track the performance of each role against the project’s goals.', object: 'Role' }
];

const projectHelpData = [
    { topic: 'Project', term: 'Account', description: 'The client or organization associated with this project.', object: 'Project' },
    { topic: 'Project', term: 'Budget ($)', description: 'The total allocated budget for the project, rolled up from the associated Project Budget records. Hours are based on dollar amounts and average rates from Opportunity Product Line Items. Budget must be allocated to the project before it can be moved to the "In Progress" stage.', object: 'Project' },
    { topic: 'Project', term: 'Budget ($/hr)', description: 'The average rate for the project, calculated from the associated Project Budget records.', object: 'Project' },
    { topic: 'Project', term: 'Budget (FTE)', description: 'The full-time equivalent resource allocation based on the project budget.', object: 'Project' },
    { topic: 'Project', term: 'Budget (FTE/weekday)', description: 'The average full-time equivalent resource allocation per weekday based on the project budget.', object: 'Project' },
    { topic: 'Project', term: 'Budget (hrs)', description: 'The total blended hours for the project, rolled up from the Project Budget and distributed across the timeline.', object: 'Project' },
    { topic: 'Project', term: 'Budget (hrs/weekday)', description: 'The average number of hours allocated per weekday, based on the total blended hours for the project.', object: 'Project' },
    { topic: 'Project', term: 'Duration (weekdays)', description: 'The total number of weekdays in the project timeline.', object: 'Project' },
    { topic: 'Project', term: 'Effective Rate ($/hr)', description: 'The effective hourly rate calculated from the billable hours.', object: 'Project' },
    { topic: 'Project', term: 'End Date', description: 'The scheduled end date for the project, marking the planned completion point.', object: 'Project' },
    { topic: 'Project', term: 'Indicators', description: 'Visual indicators that summarize the project’s key metrics or status.', object: 'Project' },
    { topic: 'Project', term: 'Owner', description: 'The user or group responsible for managing the project.', object: 'Project' },
    { topic: 'Project', term: 'Planned Resources (FTE/weekday)', description: 'The planned full-time equivalent resource allocation per weekday.', object: 'Project' },
    { topic: 'Project', term: 'Planned Resources (hrs)', description: 'The total planned hours for all resources, calculated to ensure proper resource management.', object: 'Project' },
    { topic: 'Project', term: 'Planned Resources (hrs/weekday)', description: 'The average number of planned hours per weekday for all resources.', object: 'Project' },
    { topic: 'Project', term: 'Planned Roles (FTE/weekday)', description: 'The average planned full-time equivalent allocation per weekday for all roles, offering a clearer view of resource management.', object: 'Project' },
    { topic: 'Project', term: 'Planned Roles (hrs)', description: 'The total number of planned hours for all roles in the project.', object: 'Project' },
    { topic: 'Project', term: 'Planned Roles (hrs/weekday)', description: 'The average number of planned hours per weekday for all roles.', object: 'Project' },
    { topic: 'Project', term: 'Protocol', description: 'A unique identifier for the project, typically reflecting naming conventions or client-specific requirements.', object: 'Project' },
    { topic: 'Project', term: 'Remaining ($)', description: 'The remaining budget for the project, calculated by subtracting the utilized budget from the total budget.', object: 'Project' },
    { topic: 'Project', term: 'Remaining (hrs)', description: 'The remaining hours available for the project, based on planned hours and actual utilization.', object: 'Project' },
    { topic: 'Project', term: 'Remaining Duration (weekdays)', description: 'The remaining number of weekdays until the project is completed.', object: 'Project' },
    { topic: 'Project', term: 'Stage', description: 'The current phase of the project (e.g., Planning, In Progress, Completed). The Stage must always move forward; it cannot revert to a previous stage.', object: 'Project' },
    { topic: 'Project', term: 'Stage Number', description: 'A numerical representation of the current stage, useful for reporting and automation purposes.', object: 'Project' },
    { topic: 'Project', term: 'Start Date', description: 'The planned start date of the project, marking the official kickoff.', object: 'Project' },
    { topic: 'Project', term: 'Status', description: 'The project’s current status, reflecting its overall health and activity level (e.g., Active, On Hold).', object: 'Project' },
    { topic: 'Project', term: 'Utilized ($)', description: 'The total amount of the budget that has been spent or utilized to date.', object: 'Project' },
    { topic: 'Project', term: 'Utilized (hrs)', description: 'The total hours that have been used so far in the project, allowing comparison against planned hours.', object: 'Project' }
];

const projectBudgetHelpData = [
    { topic: 'Project Budget', term: 'Budget ($)', description: 'The total allocated budget for the project, derived from associated Opportunity Product Line Items. This budget is converted into blended hours for effective tracking.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Budget (hrs)', description: 'The total labor hours available for the project based on the allocated budget and average rates.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Budget (hrs/weekday)', description: 'The average number of labor hours allocated per weekday, calculated based on the total blended hours for the project.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Manual Budget ($)', description: 'Manually entered budget in dollar amounts. This value is used for custom budget adjustments outside of standard allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Manual Budget ($/hr)', description: 'Manually entered budget rate per hour. Used to override standard rates for custom budget calculations.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Manual Budget (hrs)', description: 'Manually entered budget in labor hours. Used for custom hours adjustments outside of standard calculation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Opportunity', description: 'The associated Opportunity from which this project budget is derived. Provides context for the budget allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Opportunity Amount ($)', description: 'The total value of the associated Opportunity, used as a reference for budget allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Opportunity Product', description: 'The specific Opportunity Product associated with this budget, providing detailed source information for the allocated funds.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Opportunity Product Quantity (hrs)', description: 'The quantity of hours associated with the Opportunity Product, used in labor hour calculations for the budget.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Opportunity Product Total Price ($)', description: 'The total price of the Opportunity Product, used for budget allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Opportunity Quantity (hrs)', description: 'The total quantity of hours associated with the Opportunity, used for budget allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Selected Budget ($)', description: 'The specific budget amount selected for this project budget allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Selected Budget (hrs)', description: 'The specific number of hours selected for this project budget allocation.', object: 'Project Budget' },
    { topic: 'Project Budget', term: 'Type', description: 'The type of budget (e.g., Planned, Actual) being tracked.', object: 'Project Budget' }
];

const projectRolesHelpData = [
    { topic: 'Project Roles', term: 'Role', description: 'The specific role assigned within the project, such as Developer, Project Manager, or Analyst.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Default (FTE/weekday)', description: 'The default full-time equivalent allocation per weekday for this role. Used as a baseline for resource planning.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Default (hrs)', description: 'The default number of hours allocated for this role, calculated to ensure proper resource management.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Default (hrs/weekday)', description: 'The default number of hours allocated per weekday for this role, calculated to ensure proper resource allocation.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Duration (weekdays)', description: 'The total number of weekdays this role is planned to be active within the project.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Planned (FTE/weekday)', description: 'The planned full-time equivalent allocation per weekday for this role, based on project-specific requirements.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Planned (hrs)', description: 'The total planned hours for this role within the project, calculated based on resource needs and project timelines.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Planned (hrs/weekday)', description: 'The average number of planned hours per weekday for this role, used for resource scheduling and allocation.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Project', description: 'The project to which this role is assigned, providing context for the role’s responsibilities and planned hours.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Project Specifics', description: 'Additional details or notes related to this role within the project, used for custom requirements or role-specific information.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Project Role Label', description: 'A label representing this project role, used for easy identification and reference.', object: 'Project Roles' },
    { topic: 'Project Roles', term: 'Project Role Name', description: 'The name of the project role, typically auto-generated for uniqueness and reference.', object: 'Project Roles' }
];

const projectResourcesHelpData = [
    { topic: 'Project Resources', term: 'Resource', description: 'The name of the individual or team member assigned to the project.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Role', description: 'The specific role or responsibility assigned to this resource within the project.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Default (FTE/weekday)', description: 'The default full-time equivalent allocation per weekday for this resource, used as a baseline for planning.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Default (hrs)', description: 'The default number of hours allocated for this resource, calculated based on typical resource availability.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Default (hrs/weekday)', description: 'The default number of hours allocated per weekday for this resource, used for scheduling and resource allocation.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Duration (weekdays)', description: 'The total number of weekdays this resource is planned to be active within the project.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Planned (FTE/weekday)', description: 'The planned full-time equivalent allocation per weekday for this resource, calculated based on project needs.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Planned (hrs)', description: 'The total planned hours for this resource within the project, used for resource management and tracking.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Planned (hrs) Rollup', description: 'The total planned hours for this resource, rolled up from related tasks and assignments within the project.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Planned (hrs/weekday)', description: 'The average number of planned hours per weekday for this resource, used for scheduling and tracking.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Project', description: 'The project to which this resource is assigned, providing context for resource allocation and planning.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Project Specifics', description: 'Additional details or notes related to this resource within the project, used for custom requirements or resource-specific information.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Project Resource Label', description: 'A label representing this project resource, used for easy identification and reference.', object: 'Project Resources' },
    { topic: 'Project Resources', term: 'Project Resource Name', description: 'The name of the project resource, typically auto-generated for uniqueness and reference.', object: 'Project Resources' }
];

const projectTasksHelpData = [
    { topic: 'Project Tasks', term: 'Task Name', description: 'The name of the specific task or work item to be completed within the project.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Description', description: 'A detailed description of the task, including objectives, requirements, and any other relevant information.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Assigned To', description: 'The resource or role responsible for completing this task.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Planned (FTE/weekday)', description: 'The planned full-time equivalent allocation per weekday for this task, calculated based on resource availability.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Planned (hrs)', description: 'The total planned hours for this task, used for scheduling and resource allocation.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Planned (hrs/weekday)', description: 'The average number of planned hours per weekday for this task, used for scheduling and tracking progress.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Project', description: 'The project to which this task is associated, providing context and scope for the work to be completed.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Project Specifics', description: 'Additional details or notes related to this task within the project, used for custom requirements or task-specific information.', object: 'Project Tasks' },
    { topic: 'Project Tasks', term: 'Project Task Label', description: 'A label representing this project task, used for easy identification and reference.', object: 'Project Tasks' }
];

const timeHelpData = [
    { topic: 'Time', term: 'Type', description: 'The type of time entry, such as Billable, Non-Billable, Budget, Planned, Available, or Target. This helps categorize time entries for reporting and billing purposes.', object: 'Time' },
    { topic: 'Time', term: 'Category', description: 'The category of the time entry, such as Resource, Project Budget, Project Role, Project Resource, or Project Task. This categorization provides context for the time entry within the project structure.', object: 'Time' },
    { topic: 'Time', term: 'Date', description: 'The date on which the time entry was made, representing the day work was done.', object: 'Time' },
    { topic: 'Time', term: 'Hours', description: 'The number of hours logged for this entry, representing the time spent on a specific task or project.', object: 'Time' }
];


const helpData = [
    ...generalTopics,
    ...projectHelpData,
    ...projectBudgetHelpData,
    ...projectRolesHelpData,
    ...projectResourcesHelpData,
    ...projectTasksHelpData,
    ...timeHelpData
];

// Utility function to validate the structure of help data
function validateHelpData(data) {
    return data.every(item => {
        return item.hasOwnProperty('topic') &&
               item.hasOwnProperty('term') &&
               item.hasOwnProperty('description') &&
               item.hasOwnProperty('object');
    });
}

export default class HelpBot extends LightningElement {
    @track searchTerm = '';
    @track filteredHelpData = [];
    @track debug = 'v #11';

    connectedCallback() {
        // Validate help data structure
        if (!validateHelpData(helpData)) {
            console.error('Invalid help data structure detected.');
            this.debug = 'v #11 | Error: Invalid help data structure';
            return;
        }
    }

    handleSearch(event) {
        try {
            this.searchTerm = event.target.value.trim();

            // Log before processing
            console.log(`Search Term: "${this.searchTerm}"`);

            // Convert search term to lowercase for case-insensitive search
            let searchTermCopy = this.searchTerm.toLowerCase();

            // Log the current state before filtering
            console.log('Processed Search Term:', searchTermCopy);

            if (searchTermCopy) {
                this.filteredHelpData = helpData.filter(item => 
                    item.term.toLowerCase().includes(searchTermCopy) ||
                    item.topic.toLowerCase().includes(searchTermCopy) ||
                    item.description.toLowerCase().includes(searchTermCopy) ||
                    item.object.toLowerCase().includes(searchTermCopy)
                );
            } else {
                this.filteredHelpData = []; // Clear the results if the search term is empty
            }

            // Log the filtered results for debugging
            console.log('Filtered Help Data:', JSON.stringify(this.filteredHelpData));

            // Update the debug variable to reflect the new state
            this.debug = `v #12 | Original Search Term: ${this.searchTerm} | Processed Search Term: ${searchTermCopy} | Results: ${this.filteredHelpData.length}`;
        } catch (error) {
            // Log the error for debugging with the error object details
            console.error('Error in handleSearch:', error);

            // Update the debug variable with error information
            this.debug = `v #12 | Error: ${error.message} | Error Object: ${JSON.stringify(error)}`;
        }
    }

    get noResults() {
        // Ensure filteredHelpData is defined and is an array
        return this.searchTerm && Array.isArray(this.filteredHelpData) && this.filteredHelpData.length === 0;
    }
}