import { LightningElement,api,track,wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateListingsValue from '@salesforce/apex/SearchPropertyController.updateListingsValue';

import {loadStyle} from 'lightning/platformResourceLoader';
import customCss from '@salesforce/resourceUrl/PropertyfinderCss';

export default class CustomPropertyFinderParent extends LightningElement {
    @track addressName;
    @api selectedRecord = {}; 

    @api recordId;
    @track isLoading = false;
    @track disBtn = false;
    

    connectedCallback(){
        const currentUrl = window.location.href;

        console.log('curr url>>',currentUrl);

        console.log('recordId>>',this.recordId);
    }


    renderedCallback() {
        Promise.all([
                loadStyle(this, customCss)
            ]).then(() => {})
            .catch(() => {
                this.message = 'Something Went Wrong In New Form Detail Page';
                this.showerror();
            });
    }
    lookupRecord(event){
        try{
        console.log('Event');
        console.log(this.addressName);


        const selectedRecord = event.detail.selectedRecord;
        console.log({selectedRecord});
        this.selectedRecord = selectedRecord;
        if(this.selectedRecord != null && this.selectedRecord != undefined && this.selectedRecord != ''){
        const selectedAddress = this.selectedRecord.SearchPropertiesFormula__c; 
        console.log('selectedAddress ==> ' , selectedAddress);
        this.addressName = selectedAddress;
        
        }
        else{
            this.selectedRecord = {};
            this.disBtn = true;
        }
        console.log('Selected Address:', this.addressName);
        }
        catch(error){
            console.log('error>>',error);
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
                window.top.location.reload();
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