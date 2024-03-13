import { LightningElement,api,wire,track} from 'lwc';
// import apex method from salesforce module 
import fetchLookupData from '@salesforce/apex/SearchPropertyController.fetchLookupData';
import fetchDefaultRecord from '@salesforce/apex/SearchPropertyController.fetchDefaultRecord';
import updateListingsValue from '@salesforce/apex/SearchPropertyController.updateListingsValue';

const DELAY = 300; 

export default class CustomPropertyFinder extends LightningElement {
    @api label = 'Propertyfinder Locationtext';
    @api placeholder = 'search...'; 
    @api iconName = 'standard:account';
    @api sObjectApiName = 'SearchProperties__c';
    @api defaultRecordId = '';
    @api recordId = '';

    lstResult = []; 
    hasRecords = true; 
    searchKey='';   
    isSearchLoading = false; 
    delayTimeout;
    @api selectedRecord = {}; 
    @track disBtn = false;
    @track isLoading = false;

    connectedCallback(){
        console.log('this.recordId--->',this.recordId);
        console.log('window-->',window);
        console.log('window.location.origin>>',window.location.origin);
         if(this.recordId != ''){
            fetchDefaultRecord({recId: this.recordId})
            .then((result) => {
                if(result != null && result != undefined && result != ''){
                    console.log({result});
                    this.selectedRecord = result[0];                    
                    this.handelSelectRecordHelper();
                    this.disBtn = false;                                  
                }
                else{
                    this.selectedRecord = {};                    
                    this.disBtn = true;
                    // this.handelSelectRecordHelper();
                    // this.handelSelectRecordHelperRemovePill();
                }
            })
            .catch((error) => {
                this.error = error;
                this.selectedRecord = {};
            });
         }
    }

    @wire(fetchLookupData, { searchKey: '$searchKey' , sObjectApiName : '$sObjectApiName' })
     searchResult(value) {
        const { data, error } = value;
        this.isSearchLoading = false;
        if (data) {
             this.hasRecords = data.length == 0 ? false : true; 
             this.lstResult = JSON.parse(JSON.stringify(data)); 
         }
        else if (error) {
            console.log('(error---> ' + JSON.stringify(error));
         }
    };
       
    handleKeyChange(event) {
        this.isSearchLoading = true;
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
        this.searchKey = searchKey;
        }, DELAY);
    }

    toggleResult(event){
        const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
        const clsList = lookupInputContainer.classList;
        const whichEvent = event.target.getAttribute('data-source');
        switch(whichEvent) {
            case 'searchInputField':
                clsList.add('slds-is-open');
               break;
            case 'lookupContainer':
                clsList.remove('slds-is-open');    
            break;                    
           }
    }

   handleRemove(){
    this.searchKey = '';    
    this.disBtn = true;
    this.selectedRecord = {};
    console.log('this.selectedRecord>>',this.selectedRecord);
    this.lookupUpdatehandler(this.selectedRecord);
    
    const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
     searchBoxWrapper.classList.remove('slds-hide');
     searchBoxWrapper.classList.add('slds-show');

     const pillDiv = this.template.querySelector('.pillDiv');
     pillDiv.classList.remove('slds-show');
     pillDiv.classList.add('slds-hide');
  }

handelSelectedRecord(event){   
    try{
     this.disBtn = false;
     var objId = event.target.getAttribute('data-recid');
     console.log('objId>>',objId);
     this.selectedRecord = this.lstResult.find(data => data.Id === objId); 
     console.log('this.selectedRecord select>>',this.selectedRecord);
     this.lookupUpdatehandler(this.selectedRecord);
     this.handelSelectRecordHelper(); 
    }catch(error){
        console.log('error>',error);
    }
}


handelSelectRecordHelper(){
    this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');

     const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
     searchBoxWrapper.classList.remove('slds-show');
     searchBoxWrapper.classList.add('slds-hide');

     const pillDiv = this.template.querySelector('.pillDiv');
     pillDiv.classList.remove('slds-hide');
     pillDiv.classList.add('slds-show');     
}

handelSelectRecordHelperRemovePill(){
    this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');

     const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
     searchBoxWrapper.classList.remove('slds-show');
     searchBoxWrapper.classList.add('slds-hide');

     const pillDiv = this.template.querySelector('.pillDiv');
     pillDiv.classList.remove('slds-show');
     pillDiv.classList.add('slds-hide');     
}

lookupUpdatehandler(value){    
    try{
        console.log('value>>',value);
    const oEvent = new CustomEvent('lookupupdate',
    {
        'detail': {selectedRecord: value}
    }
);
this.dispatchEvent(oEvent);
    }catch(error){
        console.log('erorr in cp>>',error);
    }
}

updateValue(event){
    try{
        
        this.isLoading = true;
        let listObj = { 'sobjectType': 'Listing_hz__c' };
        listObj.Sub_Community_Propertyfinder__c = this.selectedRecord.SubcommunityName__c;
        listObj.City_Propertyfinder__c = this.selectedRecord.CityName__c;
        listObj.Community_Propertyfinder__c = this.selectedRecord.CommunityName__c;
        listObj.Property_Propertyfinder__c	= this.selectedRecord.PropertyName__c;
        listObj.Propertyfinder_Region__c = this.selectedRecord.SearchPropertiesFormula__c;        
        listObj.SearchPropertyId__c  = this.selectedRecord.Id;          

        updateListingsValue({recId:this.recordId,listin: listObj })
        .then(result => {
            console.log({result});          
            this.isLoading = false;  
            this.dispatchEvent(new CustomEvent(
                'callvf',
                {
                    detail: null,
                    bubbles: true,
                    composed: true,                            
                }
            ));
        })
        .catch(error =>{
            console.log('error ==> ',error);
            this.isLoading = false;  
        })
    }
    catch(error){
        console.log('error>>',error);
        this.isLoading = false;
    }
}

}