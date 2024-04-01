import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTemplateRecords from '@salesforce/apex/PdfGenerator.getTemplateRecords';

export default class PdfGeneratorComponent extends LightningElement {
    @track selectedTemplateId;
    @track selectedTemplateName;
    @track selectedTemplateHTML;
    @track selectedTemplateCSS;
    @track selectedTemplateStatus;
    @track selectedTemplateSubject;

    @wire(getTemplateRecords)
    templates;

    get templateOptions() {
        return this.templates.data
            ? this.templates.data.map(template => ({
                  label: template.Name,
                  value: template.Id
              }))
            : [];
    }

    handleTemplateChange(event) {
        this.selectedTemplateId = event.detail.value;

        if (!this.templates.data || this.templates.data.length === 0) {
            console.log('No templates available.');
            return;
        }

        const selectedTemplate = this.templates.data.find(
            template => template.Id === this.selectedTemplateId
        );

        if (selectedTemplate) {
            this.selectedTemplateName = selectedTemplate.Name;
            this.selectedTemplateHTML = selectedTemplate.HTML__c;
            this.selectedTemplateCSS = selectedTemplate.CSS__c;
            this.selectedTemplateStatus = selectedTemplate.Status__c;
            this.selectedTemplateSubject = selectedTemplate.Subject__c;

            console.log('Selected Template Id:', this.selectedTemplateId);
            console.log('Template Name:', this.selectedTemplateName);
        } else {
            console.log('Selected template not found.');
        }
    }

    handleCancel() {
        const cancelEvent = new CustomEvent('cancel');
        this.dispatchEvent(cancelEvent);
    }

    handleCreate() {
        // const successEvent = new ShowToastEvent({
        //     title: 'Success',
        //     message: 'Template created successfully',
        //     variant: 'success',
        // });
        // this.dispatchEvent(successEvent);

        // const cancelEvent = new CustomEvent('cancel');
        // this.dispatchEvent(cancelEvent);
        console.log('Clicked here1');
    }
}