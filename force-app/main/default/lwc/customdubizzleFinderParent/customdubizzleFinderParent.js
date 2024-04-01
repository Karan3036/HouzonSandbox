import { LightningElement, track, wire, api } from 'lwc';
import fetchDubizzleLocationtext from '@salesforce/apex/DubizzlePropertyFinder.fetchDubizzleLocationtext';
import updateRecordData from '@salesforce/apex/DubizzlePropertyFinder.updateRecordData';
import {loadStyle} from 'lightning/platformResourceLoader';
import customCss from '@salesforce/resourceUrl/PropertyfinderCss';
export default class CustomdubizzleFinderParent extends LightningElement {
    @api recordId;
    @track dubizzleLocationtext;
    @track selectedRecordId;
    @track selectedRecordName;
    @track disBtn = false;

    connectedCallback(){
        const currentUrl = window.location.href;
        console.log('curr url>>',currentUrl);

        console.log('recordId>>',this.recordId);
    }

    connectedCallback() {
        console.log('recordId ==>', this.recordId);
        console.log(this.dubizzleLocationtext);
    }

    setdubizzletext(event){
        this.dubizzleLocationtext = event.detail.selectedRecord.Dubizzle_Building_name__c;
        console.log('this.dubizzleLocationtext ==>' , this.dubizzleLocationtext);
    }

    lookupRecord(event) {
        console.log('Selected Record Value on Parent Component is ' + JSON.stringify(event.detail.selectedRecord));
    
        if (event.detail.selectedRecord) {
            this.selectedRecordId = event.detail.selectedRecord.Id;
            this.selectedRecordName = event.detail.selectedRecord.Dubizzle_Building_name__c;
            console.log('selectedRecordId ==>', this.selectedRecordId);
    
            if (this.selectedRecordId) {
                this.fetchDubizzleLocationtext(this.selectedRecordId);
                this.disBtn = false;
            } else {
                console.log('In the else here....');
                this.disBtn = true;
            }
        } else {
            console.log('No record selected here');
        }
    }
    
    updateValue() {
        console.log('Clicked on update button');      

        updateRecordData({
            recordId: this.recordId,
            dubizzleLocationtext: this.dubizzleLocationtext,
            selectedRecordName: this.selectedRecordName,
            SearchPropertyId: this.selectedRecordId
        }).then(result => {
            console.log({result});          
            // this.isLoading = false;  
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
            // this.isLoading = false;  
        });
    }

    fetchDubizzleLocationtext(selectedRecordId) {
        fetchDubizzleLocationtext({ PropertyId: selectedRecordId })
            .then(result => {
                this.dubizzleLocationtext = result;
            })
            .catch(error => {
                console.error('Error fetching Dubizzle Locationtext', error);
            });
    }

}