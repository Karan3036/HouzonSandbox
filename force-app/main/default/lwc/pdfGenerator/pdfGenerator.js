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

    connectedCallback(){
        console.log('RecordID ==>' , this.recordId);
    }

    renderedCallback() {
        
        Promise.all([
            loadStyle( this, LightningCardCSS )
            ]).then(() => {
                console.log( 'Files loaded' );
            })
            .catch(error => {
                console.log( error.body.message );
        });

    }

    @wire(getListingNameById, { recordId: '$recordId' })
    wiredListingName({ error, data }) {
        if (data) {
            this.listingName = data;
            console.log('Listing Name:', this.listingName);
            this.isLoading = true;
        } else if (error) {
            console.error(error);
            this.isLoading = true;
        }
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
            // console.log('Selected Template Id:', this.selectedTemplateId);
            // console.log('Template Name:', this.selectedTemplateName);

            if(this.selectedTemplateName == 'Single PDF'){
                this.PageName = 'Single_Pdf';
                // console.log(this.PageName);
            }
            else if(this.selectedTemplateName == 'Comparable Small Landscape'){
                this.PageName = 'CreatePdf';
                // console.log(this.PageName);
            }
            else if(this.selectedTemplateName == 'Comparative Market Analysis (CMA)'){
                this.PageName = 'ComparableMarketAnalysis';
                // console.log(this.PageName);
            }
            else if(this.selectedTemplateName == 'Multiple PDFs'){
                this.PageName = 'Multiple_page';
                // console.log(this.PageName);
            }

        } else {
            console.log('Selected template not found.');
        }
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());

    }

    handleCreate() {
        // console.log('clicked');
        console.log(this.recordId);
        if (!this.selectedTemplateId) {
            console.error('Selected template is missing HTML or CSS.');
            return;
        }

        // console.log(this.selectedTemplateName);
        // console.log('PageName',this.PageName);

        sendPdf({ listingId: this.recordId, pageName: this.PageName })
        .then(result => {
            console.log(result);
        })
        .catch(error => {
            console.error(error);
        });

        const vfPageUrl = `/apex/${this.PageName}?id=${this.recordId}`;

        // if(this.PageName == 'Single_Pdf'){
        //     let vfPageName = 'Single_Pdf';
        //     vfPageUrl = `/apex/${vfPageName}?id=${this.recordId}`;
        //     console.log(vfPageUrl);
        // }
        // else if(this.PageName == 'CreatePdf'){
        //     let vfPageName = 'CreatePdf';
        //     vfPageUrl = `/apex/${vfPageName}?id=${this.recordId}`;
        //     console.log(vfPageUrl);
        // }

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: vfPageUrl
            }
        });

    }


}