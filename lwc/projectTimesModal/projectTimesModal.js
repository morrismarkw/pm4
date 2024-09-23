import { LightningElement, api, track } from 'lwc';

export default class LwcModal extends LightningElement {
    @api recordId;
    @api type = 'None';
    @track isModalVisible = false;

    get buttonLabel() {
        return `${this.type !== 'None' ? this.type : 'All'} Times`;
    }

    handleLaunchModal() {
        this.isModalVisible = true;
    }

    handleModalClose() {
        this.isModalVisible = false;
    }
}