import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContacts from '@salesforce/apex/ListingMatchingController.getContacts';
import getContactFields from '@salesforce/apex/ListingMatchingController.getContactFields';
import createLinkedListing from '@salesforce/apex/ListingMatchingController.createLinkedListing';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone' },
    { label: 'Email', fieldName: 'Email' },
    { label: 'Lead Source', fieldName: 'LeadSource' }
];

export default class ListingMatchingTab extends LightningElement {
    @track selectedFieldApiName;
    selectedField;
    fieldOptions = [];
    @track isModalOpen = false;
    @track isMailModalOpen = false;
    @track data = [];
    @track columns = columns;
    @track pageNumber = 1;
    @track totalPages = 0;
    @track pageSize = 10;
    @track selectedContacts = [];
    @track showInputBox = false;
    @track selectedCriteriaDisplay;
    @track FieldCriteria;
    @track criteriaSelected;
    @track isSendEmailDisabled = true;
    @track isCreateLinkedListingDisabled = true;
    selectedField;
    objectName = 'Contact';
    fieldapiName ='LeadSource';
    @track selectedCriteriaList = [];
    selectedCriteria;
    //varaible to store the selected fields
    selectedFieldApiName;
    //array to store selected fields
    selectedFields = [];

    // criteria fields
    criteriaOptions = [
        { label: 'Includes', value: 'includes' },
        { label: 'Not Includes', value: 'not include'},
        { label: 'Equals', value: 'equals'},
        { label: 'Not Equals', value: 'notEquals'},
        { label: 'True' , value: 'True'},
        { label: 'False' , value: 'False'},
        { label: 'Date Maximum' , value: 'Date Maximum'},
        { label: 'Date Minimun' , value: 'Date Minimun'}
    ];

    // open pop up
    openModal() {
        this.isModalOpen = true;
    }

    // close pop up
    closeModal() {
        this.isModalOpen = false;
    }

    mailModalOpen(){
        this.isMailModalOpen = true;
    }
    
    mailModalClose(){
        this.isMailModalOpen = false;
    }

    // when add button is clicked the filter will be visible on UI with numbers
    submitDetails() {
        this.isModalOpen = false;
        if (this.selectedField && this.selectedCriteria) {
            const existingField = this.selectedCriteriaList.find(criteria => criteria.field === this.selectedField);
            if (existingField) {
                console.log('Filter with this field already exists.');
            } else {
                let filterNumber = 1;
                if (this.selectedCriteriaList.length > 0) {
                    const maxFilterNumber = Math.max(...this.selectedCriteriaList.map(criteria => criteria.filterNumber));
                    filterNumber = maxFilterNumber + 1;
                }
                const selectedFieldType = this.fieldOptions.find(option => option.value === this.selectedField).fieldType;
                const selectedFieldOption = this.fieldOptions.find(option => option.value === this.selectedField);
                
                // Push the selected field into the selectedFields array
                this.selectedFields.push(this.selectedField);
    
                this.selectedCriteriaList.push({
                    apiName: this.selectedField,
                    field: selectedFieldOption.label,
                    criteria: this.selectedCriteria,
                    filterNumber,
                    inputValue: '',
                    inputVisible: true,
                    fieldType: selectedFieldType,
                    picklistOptions: selectedFieldType === 'Picklist' ? selectedFieldOption.picklistValues : [],
                    selectedFields: [this.selectedField]
                });
                console.log('new criteria list==>', this.selectedCriteriaList);
                console.log('Selected fields:', this.selectedFields);
            }
        }
    }
    
        
    handleInputChange(event) {
        const index = event.target.dataset.index;
        const inputValue = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
        this.selectedCriteriaList[index].inputValue = inputValue;
    }      

    // numbers will be assigned to filter
    addFilter(field, criteria) {
        this.selectedCriteriaList.push({ field, criteria, filterNumber: this.selectedCriteriaList.length + 1 });
    }

    // filter numbers will be updated
    removeFilter(event) {
        const index = event.target.dataset.index;
        this.selectedCriteriaList.splice(index, 1);
        this.selectedCriteriaList.forEach((criteria, i) => {
            criteria.filterNumber = i + 1;
        });
        this.selectedCriteriaList = [...this.selectedCriteriaList];
    }
    
    // contact fields are being fetched here
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

    // tracking field change
    handleChange(event) {
        this.selectedField = event.detail.value;
        this.selectedCriteriaList.forEach(criteria => {
            criteria.inputVisible = false;
            criteria.inputValue = '';
        });    
        console.log("selected fields==>" , this.selectedField);

        // Assign selectedFieldApiName with the selected field API name
        this.selectedFieldApiName = this.selectedField; 

        console.log('field api name==>', this.selectedFieldApiName);
    }

    // tacking criteria chnage
    handleCriteriaChange(event) {
        this.selectedCriteria = event.detail.value;
        console.log("criteria==>" , this.selectedCriteria);
    }

    // advanced check-box functionality
    handleAdvancedChange(event) {
        this.showInputBox = event.target.checked;
    }

    // radio button functionality
    handleRadioChange(event) {
        const selectedValue = event.target.value;
        if (selectedValue === 'allContacts') {
            this.fetchContacts(true);
        } else if (selectedValue === 'myContacts') {
            this.fetchContacts(false);
        }
        this.selectedRadioButton = selectedValue;
    }

    // contact records displayed on render
    connectedCallback() {
        this.fetchContacts();
    }


    // contact recods are fetched
    fetchContacts(allContacts = false) {
        const pageSize = 10;
        // Pass allContacts parameter to getContacts Apex method
        getContacts({ pageNumber: this.pageNumber, pageSize, allContacts })
            .then(result => {
                this.data = result.contacts;
                this.totalPages = Math.ceil(result.totalRecords / pageSize);
            })
            .catch(error => {
                console.error('Error fetching contacts:', error);
            });
    }
    
    // pagination start
    previousPage() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
            this.fetchContacts();
        }
    }

    nextPage() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber++;
            this.fetchContacts();
        }
    }
    // pagination end

    // views to dipalay record
    switchToListView() {
        // Logic to switch to list view
    }

    // view to display record
    switchToGridView() {
        // Logic to switch to grid view
    }

    createLinkedListing() {
        const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        console.log('selected rows==>'+selectedRows);

        if (selectedRows && selectedRows.length > 0) {
            const contactIds = selectedRows.map(contact => contact.Id);

            createLinkedListing({ contactIds })
                .then(result => {
                    this.showToast('Success', 'Linked Listing created successfully', 'success');
                })
                .catch(error => {
                    this.showToast('Error', 'Error creating Linked Listing', 'error');
                });
        } else {
            this.showToast('Toast Warning','Please Select atleast 1 Record','warning');
        }
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    // print button functionality
    printData() {
        window.print();
    }

    updateButtonStates(selectedRows){
        this.isSendEmailDisabled = !selectedRows || selectedRows.length == 0;
        this.isCreateLinkedListingDisabled = !selectedRows || selectedRows.length == 0;
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.updateButtonStates(selectedRows);
    }
    
    handleRefresh() {
        this.selectedCriteriaList = [];
        this.selectedField = null;
        this.selectedCriteria = null;
        this.showInputBox = false;
        this.selectedRadioButton = 'allContacts';
        const allContactsRadio = this.template.querySelector('lightning-input[value="allContacts"]');
        if (allContactsRadio) {
            allContactsRadio.checked = true;
            this.handleRadioChange({ target: { value: 'allContacts' } });
        }
    
        this.fetchContacts();
    }    
}