import { LightningElement, wire, track } from 'lwc';
import getContactFields from '@salesforce/apex/FilterPopupController.getContactFields';

export default class FilterPopup extends LightningElement {
    selectedField;
    fieldOptions = [];

    @wire(getContactFields)
    wiredContactFields({ error, data }) {
        if (data) {
            this.fieldOptions = data.map(field => ({
                label: field,
                value: field
            }));
        } else if (error) {
            console.error('Error retrieving contact fields:', error);
        }
    }

    connectedCallback() {
        // Listen for the custom event from ListingMatching component
        this.addEventListener('openfilterpopup', this.openPopup);
    }
    handleChange(event) {
        this.selectedField = event.detail.value;
        // You can handle selected field change here if needed
    }
}