import { LightningElement, track, api, wire } from 'lwc';
import getRecordType from '@salesforce/apex/NewRecordCreation.getRecordType'; //landingPage method
import fetchListings from '@salesforce/apex/NewRecordCreation.fetchListings'; //landingPage method
import getListings from '@salesforce/apex/NewRecordCreation.getListings'; //landingPage method
import createListingRecord from '@salesforce/apex/NewRecordCreation.createListingRecord'; //landingPage method
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import PROPERTYTYPE_FIELD from '@salesforce/schema/Listing_hz__c.PropertyType__c';
import APPSOURCE_FIELD from '@salesforce/schema/Listing_hz__c.Appraisal_Source__c';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
// import NewListingPagecss from '@salesforce/resourceUrl/NewListingPage';
// import getUserList from '@salesforce/apex/NewRecordCreation.getUserList';
import UserName from '@salesforce/schema/User.Name';
import { getRecord } from 'lightning/uiRecordApi';
import userId from '@salesforce/user/Id';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

   
   export default class NewListingPage extends NavigationMixin(LightningElement) {

       @track wordCount = 0;
       @track bool; //boolean variable used for accordion
       @track bool2;
       @track iconName = 'utility:chevrondown';
       @track rentId; //variable to fetch Rent type recordId
       @track saleId; //variable to fetch Sale type recordId
       @track rtype = ''; //Stores RecordType
       @track title = ''; //Stores Title
       @track address = ''; //Stores address
       @track city = ''; //Stores city
       @track propowner = ''; //Stores Property Owner Field 
       @track listingId; //Listing id to open record page
       @track mylist = []; //Stores list from backend
       @track radioId; //Get property id
       @track foundDupli; //Check duplicate detected or not.
       @track isLoading; // Used for spinner
       @track propId; //Send property id to next page
       a_Record_URL; //Stores baseUrl
       checkvalue = {}; //check validity of field
       @track aptnumname = ''; //Stores apartment
       @track streetnumname = ''; //Stores Street number/name
       @track street = ''; //Stores Street
       @track area = ''; //Stores Area
       @track state = ''; //Stores State
       @track zipcode = ''; //Stores zipcode
       @track proptype = ''; //Stores PropertyType    
       @track bedrooms = ''; //Stores bedrooms
       @track appsource = ''; //Stores Appsource
       @track selectedUserIdvalue; //Agent Id
       @track id2;
   
       @track userRecord; //Used to display related user record on search
       @track usrViewBool; //Boolean to check user record.        
       crUsrName = ''; //Stores clicked username from list. 
   
       @api eventRecordId; //Stores id of the user 
   
       appsourceval; //Stors picklist value of appsource    
       proptypeval; //Stors picklist value of propertytype
   
   
       @api
       get abRequestObj() {
           return this.abRequest;
       }
       set abRequestObj(value) {
           this.abRequest = value;
       }

       connectedCallback() {
           try {
   
            // console.log('In connected Callback');

               if (this.abRequest.listingAssignedTo != '' && this.abRequest.listingAssignedTo != undefined) {
                   this.selectedUserIdvalue = this.abRequest.listingAssignedTo;
                   this.eventRecordId = this.abRequest.listingAssignedTo;
               } else {
                   this.selectedUserIdvalue = userId;
                   this.eventRecordId = userId;
               }
   
               if (this.abRequest != undefined) {
   
                   this.rtype = this.abRequest.listingRecordType;
                   this.city = this.abRequest.listingCity;
                   this.aptnumname = this.abRequest.listingAppName;
                   this.streetnumname = this.abRequest.listingStreetNumName;
                   this.street = this.abRequest.listingStreet;
                   this.area = this.abRequest.listingArea;
                   this.state = this.abRequest.listingState;
                   this.zipcode = this.abRequest.listingZipcode;
                   this.bedrooms = this.abRequest.listingBedrooms;
                   this.propowner = this.abRequest.contactFirstName + ' ' + this.abRequest.contactLastName;
                   this.proptype = this.abRequest.listingPropertyType;
                   this.appsource = this.abRequest.listingAppSource;
               }
   
               this.a_Record_URL = window.location.origin;
           
               getRecordType({ type: this.rtype })
                   .then(result => {
                       this.rentId = result;
                   })
                   .catch(error => {
                       console.log({ error });
                   })
   
               
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method : Connectedcallback',
                       error: error.message
                   }
               }));
           }
   
       }
   
       get options() {
           return [
               { label: 'Rent', value: 'Rent' },
               { label: 'Sale', value: 'Sale' },
           ];
       }
       @wire(getPicklistValues, {
           recordTypeId: '012000000000000AAA',
           fieldApiName: PROPERTYTYPE_FIELD
       })
       wiredSalPicklist({ error, data }) {
           try {
               if (data) {
                   this.proptypeval = [{ label: '---None---', value: '', selected: true }, ...data.values];
               } else {
                //    console.log('---ERROR---', error);
               }
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: SalPicklist',
                       error: error.message
                   }
               }));
           }
       }
   
       @wire(getPicklistValues, {
           recordTypeId: '012000000000000AAA',
           fieldApiName: APPSOURCE_FIELD
       })
       wiredLeadPicklist({ error, data }) {
           try {
               if (data) {
                   this.appsourceval = [{ label: '---None---', value: '', selected: true }, ...data.values];
               } else {
                //    console.log('---ERROR---', error);
               }
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: AppsourcePicklist',
                       error: error.message
                   }
               }));
           }
       }
   
       @wire(getRecord, {
           recordId: '$eventRecordId',
           fields: [UserName]
       })
       eventRec;
       get currentUserName() {
           try {
               if (this.eventRec.data) {
                   this.crUsrName = this.eventRec.data.fields.Name.value;
                   return this.eventRec.data.fields.Name.value;
               }
               return undefined;
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'EventPage, Method: currentUserName()',
                       error: error.message
                   }
               }));
           }
       }

       hideDropdown() {
           try {
               this.load = true;
               this.userRecord = {};
               this.usrViewBool = false;
               this.searchValue = '';
               setTimeout(() => {
                   var crUsr = this.template.querySelector('.searchInput');
                   crUsr.value = this.crUsrName;
                   this.load = false;
               }, 400);
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'EventPage, Method: HideDropDown()',
                       error: error.message
                   }
               }));
           }
       }
   
       optionsClickHandler(event) {
               try {
                   var idvalueList = event.currentTarget.id.split("-");
                   var idvalue = idvalueList[0];
                   if (idvalue != '' && idvalue != undefined) {
                       for (var i = 0; i < this.userRecord.length; i++) {
                           if (idvalue == this.userRecord[i].Id) {
                               var searchIn = this.template.querySelector('.searchInput');
                               searchIn.value = this.userRecord[i].Name;
                               this.searchValue = this.userRecord[i].Name;
                               this.usrViewBool = false;
                               this.selectedUserIdvalue = idvalue;
                               this.eventRecordId = idvalue;
                               break;
                           }
                       }
                   }
               } catch (error) {
                   this.dispatchEvent(new CustomEvent('error', {
                       detail: {
                           method: 'EventPage, Method: optionClickHandler()',
                           error: error.message
                       }
                   }));
               }
           }
           //Ends
   
       handleAcco(event) {
   
           try {
   
               event.currentTarget.querySelector('.showIconclass').classList.toggle('rotateIcon');
               this.id2 = event.currentTarget.id;
               this.id2 = this.id2.split('-')[0];
               var dId = event.target.id;
               dId = dId.split('-')[0];
               const cols = this.template.querySelectorAll('[data-id="' + this.id2 + '"]');
               
   
               cols.forEach(e => {
                   e.classList.toggle('showH');
               })
   
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: handleAcco()',
                       error: error.message
                   }
               }));
           }
       }

       wordcounter(event){
        // console.log(event.detail.value , 'In the tile onchange event');
        let bodyOfTitle = event.target.value;
        let lengthOfBody = bodyOfTitle.length;
        // console.log('lengthOfBody =>' + lengthOfBody);
        this.wordCount = lengthOfBody;
        this.aptnumname = event.target.value;
       }
   
       handleChange(event) {
           try {
   
               if (event.target.name == 'rtype') {
                   this.rtype = event.target.value;
               } else if (event.target.name == 'proptype') {
                   this.proptype = event.target.value;
               } else if (event.target.name == 'appsource') {
                   this.appsource = event.target.value;
               }
   
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: handleChange()',
                       error: error.message
                   }
               }));
           }
       }
   
       handleKeyup(event) {
   
        //    console.log({event});
           var evrel = event.relatedTarget;
        //    console.log('evrel ==>' , evrel);
           console.log({evrel});
           var clist = undefined;
           var plist = undefined;
           var blist = undefined;
           if(evrel != undefined){
               clist = evrel.classList.contains('cls_input');
               plist = evrel.classList.contains('ptype1');
               blist = evrel.classList.contains('btn-0');
           }
        //    console.log({clist});
           if(evrel == undefined || clist == true || plist == true || blist == true){
           try {
              
               
                   if (event.target.name == 'aptnumname') {
                       this.aptnumname = event.target.value;
                    //    console.log('this.aptnumname>>',this.aptnumname);
                   } else if (event.target.name == 'streetnumname') {
                       this.streetnumname = event.target.value;
                   } else if (event.target.name == 'street') {
                       this.street = event.target.value;
                   } else if (event.target.name == 'area') {
                       this.area = event.target.value;
                   } else if (event.target.name == 'city') {
                       this.city = event.target.value;
                   } else if (event.target.name == 'Address') {
                       this.address = event.target.value;
                   } else if (event.target.name == 'state') {
                       this.state = event.target.value;
                   } else if (event.target.name == 'zipcode') {
                       this.zipcode = event.target.value;
                    //    console.log('this.zipcode>>>',this.zipcode);
                   } else if (event.target.name == 'bedrooms') {
                       this.bedrooms = event.target.value;
                    //    console.log('this.bedrooms>>>',this.bedrooms);
                   }
                   this.mylist = [];
                   this.foundDupli = false;
                   if (this.aptnumname != '' || this.address != '' || this.city!='' || this.bedrooms!='') {
                       this.fetchList();
                   }
               }
            catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: handleKeyup()',
                       error: error.message
                   }
               }));
           }
         }
       }
   
       fetchList() {

        // console.log('In fetch list');
        try {
            let listObj = { 'sobjectType': 'Property_hz__c' };
            listObj.Name = this.aptnumname;
            listObj.City_hz__c = this.city;
            listObj.Address_hz__c = this.address;
            listObj.Bedrooms_hz__c = this.bedrooms;

            // console.log('In the Search Prop');

            fetchListings({ listin: listObj })
                .then(result => {
                    // console.log({result});
                    this.mylist = [];
                    this.foundDupli = true;
                    if (Object.keys(result).length > 0) {
                        this.foundDupli = true;
                        this.isLoading = true;

                        setTimeout(() => {
                            this.isLoading = false;

                            for (let key in result) {

                                this.mylist.push({
                                    value: result[key],
                                    key: key.split('::')[0],
                                    name: key.split('::')[1],
                                    address: key.split('::')[2],
                                    count: result[key].length
                                });
                                
                            }
                        }, 1000);
                        // console.log({mylist});
                    } else {

                        setTimeout(() => {
                            this.isLoaded = false;
                            this.foundDupli = false;
                        }, 1000);
                    }

                })
                .catch(error => {
                    console.log({ error });
                });
        } catch (error) {
            this.dispatchEvent(new CustomEvent('error', {
                detail: {
                    method: 'ListingPage, Method: fetchList()',
                    error: error.message
                }
            }));
        }
    }
   
       linkOpener(event) {
   
           try {
               var listingId = event.target.dataset.record;
               if (listingId != undefined && listingId != '') {
                   if (listingId.indexOf('::') > -1) {
                       var listingSplit = listingId.split('::');
                       window.open(this.a_Record_URL+'/lightning/r/Property_hz__c/' + listingSplit[0] + '/view', '_blank');
                   } else {
                       window.open(this.a_Record_URL+'/lightning/r/Property_hz__c/' + listingId + '/view', '_blank');
                   }
               } else {
                   alert('Error');
               }
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: linkOpener()',
                       error: error.message
                   }
               }));
           }
       }
   
       linkOpenerListing(event) {
   
           try {
               var listingId = event.target.dataset.record;
               if (listingId != undefined && listingId != '') {
                   if (listingId.indexOf('::') > -1) {
                       var listingSplit = listingId.split('::');
                       window.open(this.a_Record_URL+'/lightning/r/Listing_hz__c/' + listingSplit[0] + '/view', '_blank');
                   } else {
                       window.open(this.a_Record_URL+'/lightning/r/Listing_hz__c/' + listingId + '/view', '_blank');
                   }
               } else {
                   alert('Error');
               }
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: linkOpenerListing()',
                       error: error.message
                   }
               }));
           }
       }
   
       getRadio(event) {
   
           try {
               this.radioId = event.target.value;
            //    console.log('Teeeesss:',this.radioId);
               getListings({ lisId: this.radioId })
                   .then(result => {
                       let listing = { 'sobjectType': 'Listing_hz__c' };
                       var recordType = this.rtype;
                       if (this.rtype == 'Rent') {
                           listing.RecordTypeId = this.rentId;
                       } else if (this.rtype == 'Sale') {
                           listing.RecordTypeId = this.saleId;
                       } else {
                           listing.RecordTypeId = '';
                       }

                       this.propId = result[0].Id;
                       this.aptnumname = result[0].Name;

                       if(result[0].Address_hz__c != null){
                           this.address = result[0].Address_hz__c;
                       }

                       if(result[0].City_hz__c != null){
                           this.city = result[0].City_hz__c;
                       }

                       if(result[0].Bedrooms_hz__c != null)
                       {
                           this.bedrooms = result[0].Bedrooms_hz__c;
                       }

                       if(result[0].PropertyType__c != null){
                           this.proptype = result[0].PropertyType__c;
                       }
   
   
                   })
                   .catch(error => {
                       console.log({ error });
                   })
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: getRadio()',
                       error: error.message
                   }
               }));
           }
       }
   
       handleNext(event) {
   
           try {            

                    if(this.aptnumname == '' || this.aptnumname == null){
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message: 'Title Can not be empty',
                            variant: 'error',
                        });
                        this.dispatchEvent(event);
                        return;
                    }

                    if(this.rtype == '' || this.rtype == null ){
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message: 'Record Type Cannot be empty',
                            variant: 'error',
                        });
                        this.dispatchEvent(event);
                        return;
                    }

                    if(this.wordCount > 80){
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message: 'Title cannot greater than 80 words',
                            variant: 'error',
                        });
                        this.dispatchEvent(event);
                        return;
                    }

                   if (this.isInputValid()) {
                    //    this.dispatchEvent(contactData);
                       this.createListingRecord();

                   }
     
           } catch (error) {
               this.dispatchEvent(new CustomEvent('error', {
                   detail: {
                       method: 'ListingPage, Method: handleNext()',
                       error: error.message
                   }
               }));
           }
       }

       @api
       clearAllValues() {
        
        const inputFields = this.template.querySelectorAll('lightning-input');
        inputFields.forEach(field => {
            field.value = 'test@gmail.com';
            field.setCustomValidity('');
            field.reportValidity();
            field.value = '';
        });

        const comboBoxFields = this.template.querySelectorAll('lightning-combobox');
        comboBoxFields.forEach(field => {
            field.value = 'Sale';
            field.setCustomValidity(''); // Clear validation error
            field.reportValidity(); // Clear UI error message
            field.value = null;
        });
        this.rtype = '';
        this.title = '';
        this.address = '';
        this.city = '';
        this.checkvalue = {};
        this.aptnumname = '';
        this.streetnumname = '';
        this.street = '';
        this.area = '';
        this.state = '';
        this.zipcode = '';
        this.proptype = '';
        this.bedrooms = '';
        this.appsource = '';
        this.foundDupli = '';
        this.radioId = '';
        this.mylist = [];
        this.wordCount = 0;
    }

    handleCancel(event){
        this.clearAllValues();
    }

       createListingRecord() {
        
        createListingRecord({
            recordType: this.rtype,
            aptnumname: this.aptnumname,
            address:this.address,
            propId: this.propId,
            bedrooms: this.bedrooms,
            city:this.city,
            proptype: this.proptype,
        })
        .then(result => {
            // console.log(result);
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: result[0].Id,
                    objectApiName: 'Listing_hz__c',
                    actionName: 'view'
                }
            });

            this.clearAllValues();
        })
        .catch(error => {
            // Handle error
            console.error('Error creating listing record: ', error);
            console.log('Error ==> ' + error);
        });
    }
   
       isInputValid() {
           let isValid = true;
           let inputFields = this.template.querySelectorAll('.clsinput');
           inputFields.forEach(inputField => {
   
               if (!inputField.checkValidity()) {
                   inputField.reportValidity();
                   isValid = false;
               }

               if(this.wordCount > 80){
                    isValid = false;

                    this.dispatchEvent(new CustomEvent(
                        'calltoast',
                        {
                            detail: null,
                            bubbles: true,
                            composed: true,
                        }
                    ));

               }
               this.checkvalue[inputField.name] = inputField.value;
           });
           return isValid;
       }
   
       handleFocus() {
           var results = document.querySelectorAll('.ptype1');
           for (let result of results) {
               result.classList.add('focused');
           }
       }
   
       handleClick(event) {
    
           const cols = this.template.querySelectorAll('.down');
           var a = event.target.value;
           
           if (this.bool) {
               cols.forEach(e => {
                   
                   e.classList.remove('slds-is-open');
                   this.bool = false;
               })
           } else {
               cols.forEach(e => {
                   
                   e.classList.add('slds-is-open');
                   this.bool = true;
               })
           }
       }
   }