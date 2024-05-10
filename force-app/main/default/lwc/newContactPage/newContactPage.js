import { LightningElement, track, api, wire } from 'lwc';
import fetchContact from '@salesforce/apex/NewRecordCreation.fetchContact'; //For Fetching duplicate record
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import SALUTATION_FIELD from '@salesforce/schema/Contact.Salutation';
import LEADSOURCE_FIELD from '@salesforce/schema/Contact.LeadSource';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import abContactPageCss from '@salesforce/resourceUrl/newContactpageCss';
import getContacts from '@salesforce/apex/NewRecordCreation.getContacts';
import { NavigationMixin } from 'lightning/navigation';
import createContact from '@salesforce/apex/NewRecordCreation.createContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class NewContactPage extends NavigationMixin(LightningElement) {

    // variable for fetching value from the Input Field
    @track fname;
    @track lname;
    @track email;
    @track salutation;
    @track company;
    @track mobilephn = '';
    @track phone;
    @track leadsource;
    @track contactId;

    // Picklist value
    salutationVal;
    leadsourceVal;

    a_Record_URL;

    @track radioId;

    @track duplicateConName; //Store duplicate contact list
    @track duplicaterecord; //Duplicate contact show/hide
    @track contactcount; //Duplicate Contact Count
    @track exisCon = 0; //Existing Contact Count

    checkvalue = {}; //Input field validation
    @api isLoaded = false; //Spinner show/hide

    @track blurr = false;

    // Data tracking variable between Landing page and Contact page
    @track abRequest = {};
    @api
    get abRequestObj() {
        return this.abRequest;
    }
    set abRequestObj(value) {
        this.abRequest = value;
    }

   

    renderedCallback() {
        Promise.all([
                loadStyle(this, abContactPageCss)
            ]).then(() => {
                // console.log('Files loaded');
            })
            .catch(error => {
                console.log(error.body.message);
            });
    }

    // Constructor || RAVI || 03/02/2022
    connectedCallback() {
        try {

            if (this.abRequest != undefined) {
                this.salutation = this.abRequest.contactSalutation;
                this.fname = this.abRequest.contactFirstName;
                this.lname = this.abRequest.contactLastName;
                this.email = this.abRequest.contactEmail;
                this.company = this.abRequest.contactCompany;
                this.mobilephn = this.abRequest.contactMobilePhone;
                this.phone = this.abRequest.contactPhone;
                this.leadsource = this.abRequest.contactLeadSource;
                this.contactId = this.abRequest.contactId;
            }
            this.a_Record_URL = window.location.origin;
            // console.log('this.a_Record_URL>>>'+this.a_Record_URL);
        } catch (error) {
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ContactPage Connectedcallback',
                    error: error.message,
                }
            }));
        }
    }

    // Get Salutaion Picklist Value  || RAVI || 03/02/2022
    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA',
        fieldApiName: SALUTATION_FIELD
    })
    wiredSalPicklist({ error, data }) {
        try {
            if (data) {
                this.salutationVal = [{ label: '---None---', value: '', selected: true }, ...data.values];
            } else {
                // console.log('---ERROR---', error);
            }
        } catch (error) {
        
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ContactPage, Method: SalPicklist',
                    error: error.message
                }
            }));
        }
    }

    // Get Lead Source Picklist Value   || RAVI || 03/02/2022
    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA',
        fieldApiName: LEADSOURCE_FIELD
    })
    wiredLeadPicklist({ error, data }) {
        try {
            if (data) {
                this.leadsourceVal = [{ label: '---None---', value: '', selected: true }, ...data.values];
            } else {
                // console.log('---ERROR---', error);
            }
        } catch (error) {

            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ContactPage, Method: LeadPicklist',
                    error: error.message
                }
            }));
        }
    }

    // Fetch value from Combobox     || RAVI || 03/02/2022 || 
    handlechange(event) {
        try {
            if (event.target.name == 'salutation') {
                this.salutation = event.target.value;
            } else if (event.target.name == 'leadSource') {
                this.leadsource = event.target.value;
            }
        } catch (error) {
            
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ContactPage, Method: handlechange',
                    error: error.message
                }
            }));
        }
    }

    changeEmail(event){
        this.email = event.target.value;
        console.log(this.email);
    }

    changeFirstName(event){
        this.fname = event.target.value;
    }

    changeLastName(event){
        this.lname = event.target.value;
    }
    ChangePhone(event){
        console.log(event.target.value);
        this.mobilephn = event.target.value;
        console.log(this.mobilephn);
    }
    
    // Fetch value from Input-Field     || RAVI || 03/02/2022 || 
    onblurvalue(event) {
        
        var evrel = event.relatedTarget;
        // console.log({evrel});
        var clist = undefined;
        var blist = undefined;
        if(evrel != undefined){
            clist = evrel.classList.contains('cls_input');
            blist = evrel.classList.contains('btn-0');
        }
        // console.log({clist});
       if(evrel == undefined || clist == true || blist == true){
            try {

                if (event.target.name == 'fname') {
                    this.fname = event.target.value;
                    // console.log('this.fname>>>'+this.fname);
                } else if (event.target.name == 'lname') {
                    this.lname = event.target.value;
                    console.log('this.lname>>>'+this.lname);
                } else if (event.target.name == 'email') {
                    this.email = event.target.value;
                    // console.log('this.email>>'+this.email);
                } else if (event.target.name == 'company') {
                    this.company = event.target.value;
                } else if (event.target.name == 'mobile') {
                    this.mobilephn = event.target.value;
                    console.log(this.mobilephn);
                } else if (event.target.name == 'phone') {
                    this.phone = event.target.value;
                }
                if (this.fname != '' || this.lname != '' || this.email != '' || this.mobilephn != '' || this.phone != '')  {
                    if (event.target.name == 'fname' || event.target.name == 'lname' || event.target.name == 'email' || event.target.name == 'mobile' || event.target.name == 'phone') {
                        this.duplicateConName = '';
                        this.duplicaterecord = false;
                        this.contactcount = '';
                        this.fetchCon();   
                    }
                }
            } catch (error) {
                this.dispatchEvent(new CustomEvent('error', {
                    detail: {
                        method: 'ContactPage, Method: onblurvalue',
                        error: error.message
                    }
                }));
            }
        }
    }


    // Fetch Duolicate Contact  || RAVI || 03/02/2022 || 
    fetchCon() {
        let cont = { 'sobjectType': 'Contact' };
        this.contactId = '';
        cont.FirstName = this.fname;
        cont.LastName = this.lname;
        cont.Email = this.email;
        cont.MobilePhone = this.mobilephn;

        fetchContact({ con: cont })
            .then(result => {
                this.exisCon = 0;
                this.isLoaded = true;
                this.duplicaterecord = true;
                this.duplicateConName = '';
                this.contactcount = '';
                if (this.email != '' && this.email != undefined) {
                    this.exisCon = result.contactCount;
                    // console.log('this.exisCon>>>',this.exisCon);
                }
                // if (result.contactList.length > 0) {
                if (result.duplicateEmail.length > 0) {
                    this.duplicaterecord = true;
                    setTimeout(() => {
                        this.isLoaded = false;
                        this.contactcount = result.duplicateEmail.length;
                        // this.contactcount = result.contactList.length;
                        // this.duplicateConName = result.contactList;
                        this.duplicateConName = result.duplicateEmail;
                    }, 500);
                } else {
                    setTimeout(() => {
                        this.isLoaded = false;
                        this.duplicaterecord = false;
                    }, 500);
                }
            })
            .catch(error => {
                // console.log({error});
                this.dispatchEvent(new CustomEvent('error', {
                    detail: {
                        method: 'ContactPage, Method: Fetchcon',
                        error: error.message
                    }
                }));
            });
    }


    // Open Contact detail Page     || RAVI || 11/02/2022
    handleClick(event) {
        try {
            const conId = event.currentTarget.dataset.id;
            window.open(this.a_Record_URL+'/lightning/r/Contact/' + conId + '/view', '_blank');
        } catch (error) {
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ContactPage, Method: handleclick',
                    error: error.message
                }
            }));
        }
    }

    handleClear(){
        // console.log('Clicked on the Clear button');

        const inputFields = this.template.querySelectorAll('lightning-input');
        inputFields.forEach(field => {
            field.value = 'test@gmail.com';
            field.setCustomValidity(''); 
            field.reportValidity();
            field.value = '';
        });
        this.fname = null;
        this.lname = null;
        this.email = null;
        this.salutation = null;
        this.company = null;
        this.mobilephn =null;
        this.phone = null;
        this.leadsource =null;
        this.email = null;
        this.contactId = '';
        this.duplicateConName = null;
        this.duplicaterecord = null;
        this.contactcount = null;
        this.exisCon = 0;
        this.checkvalue = {};
        this.isLoaded = false;
        this.blurr = false;
        this.abRequest = {};

    }


    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    //Pass Data and Go To Next Step || Devansh || 10/02/2022
    handleNext(event) {
        try {
            
            if(this.lname == '' || this.lname == null){
                this.showToast('Error', 'Last Name cannot be empty', 'error');
                return; 
            }

            if(this.mobilephn == '' || this.mobilephn == null){
                this.showToast('Error', 'Mobile Phone can not be empty', 'error');
                return;
            }
            if(this.mobilephn.length > 15){
                this.showToast('Error', 'Mobile Lengh should not be grater than 15', 'error');
                return;
            }
         

            // console.log('handle next');
            // if (this.isInputValid()) {
                // console.log('valid input');
                this.createNewContact();
                this.handleClear();
            // }
 
        } catch (error) {
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ContactPage, Method: handleNext',
                    error: error.message
                }
            }));
        }
    }

    // Input Field Validation   || RAVI || 15/02/2022 || 
    // isInputValid() {
    //     try {
    //         let isValid = true;
    //         let inputFields = this.template.querySelectorAll('.cls_input');
    //         inputFields.forEach(inputField => {
    //             if (!inputField.checkValidity()) {
    //                 inputField.reportValidity();
    //                 isValid = false;
    //             }
    //             this.checkvalue[inputField.name] = inputField.value;
    //         });
    //         return isValid;
    //     } catch (error) {
    //         this.dispatchEvent(new CustomEvent('error', {
    //             detail: {
    //                 method: 'ContactPage, Method: isInputValid',
    //                 error: error.message
    //             }
    //         }));
    //     }
    // }

    getRadio(event) {

        try {
            this.radioId = event.target.id;
            this.radioId = this.radioId.split('-')[0];
            // console.log('radioId>>>'+this.radioId);
            this.contactId = this.radioId;
            // console.log('conId>>>'+this.contactId);
            getContacts({ conId: this.radioId })
                .then(result => {
                    let conlst = { 'sobjectType': 'Contact' };
                    // console.log({result});
                    this.salutation = result[0].Salutation;
                    this.fname = result[0].FirstName;
                    this.lname = result[0].LastName;
                    this.email = result[0].Email;
                    this.company = result[0].pba__CompanyName__c;
                    this.mobilephn = result[0].MobilePhone;
                    this.phone = result[0].Phone;
                    this.leadsource = result[0].LeadSource;
                
                })
                .catch(error => {
                    console.log({ error });
                })
        } catch (error) {
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ConatctPage, Method: getRadio()',
                    error: error.message
                }
            }));
        }
    }

    createNewContact() {
        try {
            // Prepare the contact object

            console.log(this.mobilephn);
            let newContact = {
                FirstName: this.fname,
                LastName: this.lname,
                Email: this.email,
                Salutation: this.salutation,
                Company: this.company,
                MobilePhone: this.mobilephn,
                Phone: this.phone,
                LeadSource: this.leadsource
            };
            console.log('newContact ==>' + JSON.stringify(newContact));

            // Call the Apex method to create the contact
            createContact({ contactObj: newContact })
                .then(result => {
                    // Handle success
                    // console.log('Contact created successfully:', result);

                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: result.Id,
                            objectApiName: 'Contact',
                            actionName: 'view'
                        }
                    });
                })
                .catch(error => {
                    // Handle error
                    console.error('Error creating contact:', error);
                });
        } catch (error) {
            // Handle any unexpected errors
            console.error('Error creating contact:', error);
        }
    }
  
}