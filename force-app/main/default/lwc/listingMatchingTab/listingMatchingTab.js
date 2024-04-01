import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactFields from '@salesforce/apex/ListingMatchingController.getContactFields';
import createLinkedListing from '@salesforce/apex/ListingMatchingController.createLinkedListing';
import getAllContactsRecord from '@salesforce/apex/ListingMatchingController.getAllContacts';
import { refreshApex } from '@salesforce/apex';


const columns = [
    { label: 'Name', fieldName: 'Name', initialWidth: 170 },
    { label: 'Phone', fieldName: 'Phone', initialWidth: 160 },
    { label: 'Email', fieldName: 'Email', initialWidth: 250 },
    { label: 'Lead Source', fieldName: 'LeadSource', initialWidth: 120 }
];

export default class ListingMatchingTab extends LightningElement {
    @track searchedData = [];
    @track selectedFieldApiName;
    @track allContactsRecord = [];
    @track allContacts = [];
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
    @track selectedCriteriaValue = '';
    @track selectedCriteriaList = [];
    @track criteriaInputValues = [];
    @track isFilterAdded = true;
    @track selectedField = '';
    fieldOptions = [];
    objectName = 'Contact';
    fieldapiName ='LeadSource';
    @track selectedCriteria = '';
    selectedFieldApiName;
    selectedFields = [];

    // criteria fields
    criteriaOptions = [
        { label: 'Includes', value: 'includes' },
        { label: 'Not Includes', value: 'not include'},
        { label: 'Equals', value: 'equals'},
        { label: 'not equals', value: 'not equals'},
        { label: 'Maximum' , value: 'Maximum'},
        { label: 'Minimun' , value: 'Minimum'}
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
            this.isFilterAdded = false;
            const existingField = this.selectedCriteriaList.find(criteria => criteria.field === this.selectedField);
            if (existingField) {
                console.log('Filter with this field already exists.');
                this.showToast('Toast Warning', 'The Field is already added in the Filter Criteria', 'warning');
            } else {
                let filterNumber = 1;
                if (this.selectedCriteriaList.length > 0) {
                    const maxFilterNumber = Math.max(...this.selectedCriteriaList.map(criteria => criteria.filterNumber));
                    filterNumber = maxFilterNumber + 1;
                }
                const selectedFieldType = this.fieldOptions.find(option => option.value === this.selectedField).fieldType;
                const selectedFieldOption = this.fieldOptions.find(option => option.value === this.selectedField);
    
                this.selectedFields.push(this.selectedField);
    
                const newCriteria = {
                    apiName: this.selectedField,
                    field: selectedFieldOption.label,
                    criteria: this.selectedCriteria,
                    filterNumber,
                    inputValue: '',
                    inputVisible: true,
                    fieldType: selectedFieldType,
                    selectedFields: [this.selectedField]
                };
    
                this.selectedCriteriaList.push(newCriteria);
    
                console.log('the fetched data==>',newCriteria);
                console.log('new criteria list==>', this.selectedCriteriaList);
                console.log('Selected fields:', this.selectedFields);
            }
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

        this.selectedFieldApiName = this.selectedField; 

        console.log('field api name==>', this.selectedFieldApiName);
    }

    // tacking criteria chnage
    handleCriteriaChange(event) {
        this.selectedCriteria = event.detail.value;
        console.log("criteria==>",this.selectedCriteria);
    }
        
    handleSearch() {
        if (!this.allContactsRecord) {
            console.warn('Contacts data is not loaded yet.');
            return;
        }
    
        if (!this.selectedFieldApiName || !this.selectedCriteriaValue || this.selectedCriteriaValue.trim() === '') {
            this.showToast('Error', 'Please select a field and provide a search value.', 'error');
            return;
        }

        console.log('selected criteria in search==>',this.selectedCriteria);
    
        const searchValue = this.selectedCriteriaValue.toLowerCase();
        const filteredContacts = this.allContactsRecord.filter(contact => {
            const fieldValue = contact[this.selectedFieldApiName] ? String(contact[this.selectedFieldApiName]).toLowerCase() : '';
            if (this.selectedCriteria === 'not include') {
                return !fieldValue.includes(searchValue);
            } else if(this.selectedCriteria === 'includes') {
                return fieldValue.includes(searchValue);
            } else if(this.selectedCriteria === 'equals'){
                return fieldValue === searchValue;
            } else if (this.selectedCriteria === 'not equals'){
                return fieldValue !== searchValue;
            }
        });
    
        this.totalPages = Math.ceil(filteredContacts.length / this.pageSize);
    
        this.pageNumber = 1;
        this.searchedData = filteredContacts;
    
        if (filteredContacts.length === 0) {
            this.showToast('No Matches', `No contacts match the provided search value in the field ${this.selectedFieldApiName}.`, 'warning');
        }
    
        this.fetchContacts();
        this.refreshData();
    }
     
    handleInputChange(event) {
        this.selectedCriteriaValue = event.target.value;
        const index = event.target.dataset.index;
        this.selectedCriteriaList[index].inputValue = event.target.value;
        this.criteriaInputValues[index] = event.target.value;
    }
    
    // numbers will be assigned to filter
    addFilter(field, criteria) {
        this.selectedCriteriaList.push({ field, criteria, filterNumber: this.selectedCriteriaList.length + 1 });
    }

    // filter numbers will be updated
    removeFilter(event) {
        const index = event.target.dataset.index;
        const removedField = this.selectedCriteriaList[index].apiName;
        this.selectedCriteriaList[index].inputValue = '';
        
        if (this.selectedCriteriaList.length === 0) {
            this.isFilterAdded = true; // Set flag to false
        }

        const removedFieldIndex = this.selectedFields.indexOf(removedField);
        if (removedFieldIndex > -1) {
            this.selectedFields.splice(removedFieldIndex, 1);
        }
        
        this.selectedCriteriaList.splice(index, 1);
        this.selectedCriteriaList.forEach((criteria, i) => {
            criteria.filterNumber = i + 1;
        });
    
        this.selectedCriteriaList = [...this.selectedCriteriaList];
    
        const inputFieldContainer = this.template.querySelectorAll('.input-container')[index];
        if (inputFieldContainer) {
            inputFieldContainer.innerHTML = '';
        }
    }

    @wire(getAllContactsRecord)
    wiredAllContactRecord({error , data }){
        if (data) {
            this.allContactsRecord = data;
            this.searchedData = data;
            this.fetchContacts();
            this.totalPages = Math.ceil(data.length / this.pageSize); 
            console.log('contact records are==>' , this.allContactsRecord); 
        }
        else if (error) {
            console.error('Error retrieving contact records:', error);
        }
        console.log('records length' , this.allContactsRecord.length);
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


    fetchContacts() {
        const pageSize = 10;
        this.data = this.searchedData.slice(this.pageNumber * pageSize - pageSize , this.pageNumber * pageSize);
        this.totalPages = Math.ceil(this.searchedData.length / pageSize);
        this.refreshData();

        // getContacts({ pageNumber: this.pageNumber, pageSize, allContacts })
        //     .then(result => {
        //         this.data = result.contacts;
        //         this.allContacts = result.contacts;
        //         this.totalPages = Math.ceil(result.totalRecords / pageSize);
        //     })
        //     .catch(error => {
        //         console.error('Error fetching contacts:', error);
        //     });
        //     console.log('contact record==>' , this.allContacts.length);
        //     console.log('contact data' , this.data.length);
    }

    refreshData(){
        return refreshApex(this.data);
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
    printData(){
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
        // this.pageNumber = 1;
        this.searchedData = this.allContactsRecord;
        this.fetchContacts();
    
        this.selectedCriteriaList = [];
        this.selectedField = null;
        this.selectedCriteria = null;
        this.showInputBox = false;
        this.selectedRadioButton = 'allContacts';
        this.isFilterAdded = true;
    
        const allContactsRadio = this.template.querySelector('lightning-input[value="allContacts"]');
        if (allContactsRadio) {
            allContactsRadio.checked = true;
            this.handleRadioChange({ target: { value: 'allContacts' } });
        }
    }     
}