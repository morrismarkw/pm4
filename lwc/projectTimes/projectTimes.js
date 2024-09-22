import { LightningElement, api, track, wire } from 'lwc';
import getRecordsForType from '@salesforce/apex/ProjectTimesController.getRecordsForType';
import getTimeRecordsForType from '@salesforce/apex/ProjectTimesController.getTimeRecordsForType';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import TIME_OBJECT from '@salesforce/schema/Time__c';

export default class ProjectTimes extends LightningElement {
    @api recordId;
    @api type = 'None';
    @track debug = 'v 2';
    @track optionsLineItem = [];
    @track timeRecords = [];
    @track selectedRows = [];
    @track totalHours = 0;
    @track selectedHours = 0;
    @track optionType = [
        { label: 'None', value: 'None' },
        { label: 'Budget', value: 'Budget' },
        { label: 'Role', value: 'Role' },
        { label: 'Resource', value: 'Resource' },
        { label: 'Task', value: 'Task' }
    ];
    @track timeFilterOptions = [
        { label: 'All', value: 'All' },
        { label: 'Future', value: 'Future' },
        { label: 'Future and Today', value: 'FutureAndToday' },
        { label: 'Last Month', value: 'LastMonth' },
        { label: 'Last Week', value: 'LastWeek' },
        { label: 'Next Month', value: 'NextMonth' },
        { label: 'Next Week', value: 'NextWeek' },
        { label: 'Past', value: 'Past' },
        { label: 'This Month', value: 'ThisMonth' },
        { label: 'This Week', value: 'ThisWeek' },
        { label: 'This Year', value: 'ThisYear' },
        { label: 'Today', value: 'Today' }
    ];
    @track sortedBy = 'Date__c';
    @track sortedDirection = 'asc';
    @track selectedTimeFilter = 'All';
    @track isTimeFilterDisabled = true;
    @track noRecordsFound = false;
    @track isPlannedEditable = false;

    selectedLineItem = '';
    selectedType = 'None';
    selectedNickname = '';

    connectedCallback() {
        if (this.type !== 'None') {
            this.handleTypeChange();
        }
    }
    

    get objectApiName() {
        const typeToObjectMap = {
            Budget: 'Project_Budget__c',
            Role: 'Project_Role__c',
            Resource: 'Project_Resource__c',
            Task: 'Project_Task__c'
        };
        return typeToObjectMap[this.type !== 'None' ? this.type : this.selectedType] || '';
    }

    get labelLineItem() {
        const type = this.type !== 'None' ? this.type : this.selectedType;
        return type !== 'None' ? `${type} Line Item` : 'Line Item';
    }

    get showTypePicklist() {
        return this.type === 'None';
    }

    get isLineItemDisabled() {
        return !this.objectApiName || this.objectApiName === '';
    }

    get isTimeFilterDisabled() {
        return this.selectedLineItem === '';
    }

    get isLineItemSelected() {
        return this.selectedLineItem !== '';
    }


    get columns() {
        const baseColumns = [
            {
                label: 'Date',
                fieldName: 'Date__c',
                type: 'date',
                sortable: true,
                cellAttributes: {
                    class: 'slds-text-title_bold'
                },
                typeAttributes: {
                    timeZone: 'UTC'
                }
            },
            {
                label: 'Weekday Indicator',
                fieldName: 'weekdayIndicator',
                type: 'text',
                cellAttributes: {
                    style: {
                        fieldName: 'backgroundColor'
                    }
                }
            }
        ];
    
        const plannedColumn = {
            label: 'Planned (hrs)',
            fieldName: 'Planned_hrs__c',
            type: 'number',
            typeAttributes: {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            },
            cellAttributes: {
                alignment: 'left',
                wrapText: true
            },
            sortable: true,
            editable: this.isPlannedEditable
        };
    
        const budgetColumn = {
            label: 'Budget (hrs)',
            fieldName: 'Budget_hrs__c',
            type: 'number',
            typeAttributes: {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            },
            cellAttributes: {
                alignment: 'left',
                wrapText: true
            },
            sortable: true,
            editable: false
        };
    
        if (this.selectedType === 'Budget') {
            baseColumns.push(budgetColumn);
        } else {
            baseColumns.push(plannedColumn);
        }
    
        return baseColumns;
    }
    

    get showDatatable() {
        return this.selectedLineItem !== '' && this.timeRecords.length > 0;
    }

    get rowSummary() {
        const rowText = this.timeRecords.length === 1 ? 'Row' : 'Rows';
        return `${this.timeRecords.length} ${rowText} (${this.selectedRows.length} selected)`;
    }

    get hourSummary() {
        const hourText = this.totalHours === 1 ? 'Hour' : 'Hours';
        return `${this.totalHours.toFixed(2)} ${hourText} (${this.selectedHours.toFixed(2)} selected)`;
    }

    get noRecordsMessage() {
        return this.noRecordsFound ? 'No Times found, please adjust your Date filter.' : '';
    }

    @wire(getObjectInfo, { objectApiName: TIME_OBJECT })
    wiredTimeObjectInfo({ data, error }) {
        if (data) {
            this.isPlannedEditable = data.fields.Planned_hrs__c.updateable;
        } else if (error) {
            this.isPlannedEditable = false;
        }
    }

    @wire(getRecordsForType, { objectApiName: '$objectApiName', projectId: '$recordId' })
    wiredTypeRecords({ error, data }) {
        if (data) {
            this.optionsLineItem = [{ label: 'None', value: '' }, ...data.map(record => ({ label: record.Nickname__c, value: record.Id }))];
        } else if (error) {
            this.optionsLineItem = [{ label: 'None', value: '' }];
        }
    }

    handleTypeChange(event) {
        this.selectedType = event ? event.detail.value : this.type;
        if (this.selectedType === 'None') {
            this.clearLineItemSelection();
        } else {
            this.optionsLineItem = [{ label: 'None', value: '' }];
            this.timeRecords = [];
        }
        //this.columns = [...this.columns];
    }
    

    handleLineItemChange(event) {
        this.selectedLineItem = event.detail.value;
        this.selectedNickname = this.optionsLineItem.find(option => option.value === this.selectedLineItem)?.label || '';
        this.isTimeFilterDisabled = this.selectedLineItem === '';
        this.fetchTimeRecords();
    }

    handleTimeFilterChange(event) {
        this.selectedTimeFilter = event.detail.value;
        this.fetchTimeRecords();
    }

    handleSort(event) {
        const fieldName = event.detail.fieldName;
        this.sortedBy = fieldName;
        this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows;
        this.selectedHours = this.calculateTotalHours(this.selectedRows);
        this.isTimeFilterDisabled = this.selectedRows.length > 0;
    }

    handleCellChange(event) {
        const updatedRecord = event.detail.draftValues[0];
        this.updateRecordInApex(updatedRecord);
    }

    sortData(fieldName, direction) {
        let parseData = JSON.parse(JSON.stringify(this.timeRecords));
        let keyValue = (a) => {
            const value = a[fieldName];
            return value ? value.toString().toLowerCase() : '';
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            const xValue = keyValue(x);
            const yValue = keyValue(y);
            if (xValue > yValue) {
                return isReverse * 1;
            } else if (xValue < yValue) {
                return isReverse * -1;
            }
            return 0;
        });
        this.timeRecords = parseData;
    }

    fetchTimeRecords() {
        if (!this.selectedLineItem || this.selectedType === 'None') {
            this.timeRecords = [];
            this.totalHours = 0; 
            this.selectedHours = 0; 
            this.selectedRows = []; 
            this.noRecordsFound = true;
            return;
        }

        getTimeRecordsForType({ 
            parentObjectApiName: this.objectApiName, 
            parentRecordId: this.selectedLineItem, 
            timeFilter: this.selectedTimeFilter 
        })
            .then(data => {
                this.timeRecords = data.map(record => ({
                    ...record,
                    backgroundColor: record.Is_Weekday__c ? 'background-color: #3D0681;' : 'background-color: #F3F3F3;'
                }));
                this.applyTimeFilter();
                this.noRecordsFound = this.timeRecords.length === 0;
                this.totalHours = this.calculateTotalHours(this.timeRecords);
                this.selectedHours = this.calculateTotalHours(this.selectedRows);
                this.sortData(this.sortedBy, this.sortedDirection);
            })
            .catch(error => {
                this.timeRecords = [];
                this.totalHours = 0;
                this.selectedHours = 0;
                this.selectedRows = [];
                this.noRecordsFound = true;
            });
    }  

    applyTimeFilter() {
        this.timeRecords = this.timeRecords.filter(record => {
            switch (this.selectedTimeFilter) {
                case 'ThisWeek':
                    return record.Is_This_Week__c;
                case 'ThisMonth':
                    return record.Is_This_Month__c;
                case 'LastWeek':
                    return record.Is_Last_Week__c;
                case 'LastMonth':
                    return record.Is_Last_Month__c;
                case 'NextWeek':
                    return record.Is_Next_Week__c;
                case 'NextMonth':
                    return record.Is_Next_Month__c;
                case 'Past':
                    return record.Is_Past__c;
                case 'Future':
                    return record.Is_Future__c;
                case 'FutureAndToday':
                    return record.Is_Future_and_Today__c;
                case 'Today':
                    return record.Is_Today__c;
                default:
                    return true;
            }
        });
    }

    calculateTotalHours(records) {
        return records.reduce((total, record) => {
            return total + (this.selectedType === 'Budget' ? (record.Budget_hrs__c || 0) : (record.Planned_hrs__c || 0));
        }, 0);
    }

    clearLineItemSelection() {
        this.selectedLineItem = '';
        this.selectedNickname = '';
        this.optionsLineItem = [{ label: 'None', value: '' }];
        this.timeRecords = [];
        this.totalHours = 0;
        this.selectedHours = 0;
        this.selectedRows = []; 
        this.isTimeFilterDisabled = true;
    }
}