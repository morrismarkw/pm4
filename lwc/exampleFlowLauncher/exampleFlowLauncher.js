import { LightningElement, api, track } from 'lwc';

export default class ExampleFlowLauncher extends LightningElement {
    @api recordId;
    @api flowApiName = 'Test';
    @track isFlowVisible = false;

    handleLaunchFlow() {
        this.isFlowVisible = true;
    }

    handleFlowClose() {
        this.isFlowVisible = false;
    }
}