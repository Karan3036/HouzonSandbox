import { LightningElement, wire, track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTemplateRecords from '@salesforce/apex/PdfGenerator.getTemplateRecords';
import sendPdf from '@salesforce/apex/PdfGenerator.sendPdf';
import { loadStyle } from 'lightning/platformResourceLoader';
import LightningCardCSS from '@salesforce/resourceUrl/createpdf';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import getListingNameById from '@salesforce/apex/PdfGenerator.getListingNameById';


export default class PdfGenerator extends NavigationMixin(LightningElement) {
    @api recordId;
    @track selectedTemplateId;
    @track selectedTemplateName;
    @track PageName = '';

    @track listingName;
    @track isLoading = false;

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

    renderedCallback() {
        
        Promise.all([
            loadStyle( this, LightningCardCSS )
            ]).then(() => {
            })
            .catch(error => {
                // console.log( error.body.message );
        });

    }

    @wire(getListingNameById, { recordId: '$recordId' })
    wiredListingName({ error, data }) {
        if (data) {
            this.listingName = data;
            this.isLoading = true;
        } else if (error) {
            console.error(error);
            this.isLoading = true;
        }
    }



    handleTemplateChange(event) {
        this.selectedTemplateId = event.detail.value;

        if (!this.templates.data || this.templates.data.length === 0) {
            return;
        }

        const selectedTemplate = this.templates.data.find(
            template => template.Id === this.selectedTemplateId
        );

        if (selectedTemplate) {
            this.selectedTemplateName = selectedTemplate.Name;

            if(this.selectedTemplateName == 'Single PDF'){
                this.PageName = 'Single_Pdf';
            }
            else if(this.selectedTemplateName == 'Comparable Small Landscape'){
                this.PageName = 'CreatePdf';
            }
            else if(this.selectedTemplateName == 'Comparative Market Analysis (CMA)'){
                this.PageName = 'ComparableMarketAnalysis';
            }
            else if(this.selectedTemplateName == 'Multiple PDFs'){
                this.PageName = 'Multiple_page';
            }

        } else {
            console.log('Selected template not found.');
        }
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());

    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    handleCreate() {
        if (!this.selectedTemplateId) {
            this.showToast('Error' , 'Select Template Please !!' , 'error');
            return;
        }

        sendPdf({ listingId: this.recordId, pageName: this.PageName })
        .then(result => {
            console.log(result);

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result,
                    objectApiName: 'ContentDocument',
                    actionName: 'view'
                }
            });
            
        })
        .catch(error => {
            console.error(error);
        });

    }
}