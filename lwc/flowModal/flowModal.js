import { LightningElement, api, track } from 'lwc';

export default class FlowModal extends LightningElement {
    @api flowApiName;
    @api recordId;
    @track isFlowStarted = false;
    @track showFlow = false;

    get inputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            }
        ];
    }

    startFlow() {
        if (this.recordId && !this.isFlowStarted) {
            this.showFlow = true;
            this.isFlowStarted = true;
        }
    }

    renderedCallback() {
        if (this.isRendered) return;
        this.isRendered = true;
        if (this.recordId) {
            this.startFlow();
        }
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.closeModal();
        }
    }

    closeModal() {
        this.isFlowStarted = false;
        this.showFlow = false;
        this.dispatchEvent(new CustomEvent('close'));
    }
}