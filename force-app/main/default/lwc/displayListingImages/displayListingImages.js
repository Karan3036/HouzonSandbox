import { LightningElement, track, api, wire } from 'lwc';
import fetchdata from "@salesforce/apex/uploadController.fetchdataforlisting";
import { MessageContext,subscribe,unsubscribe} from 'lightning/messageService';
import Refresh_cmp from '@salesforce/messageChannel/refreshMessageChannel__c';
import {refreshApex} from '@salesforce/apex';




    export default class DisplayListingImages extends LightningElement {
        @api recordId;
        @track reloadComponentVar = false;
        @track data = [];
        @track taglist = [];
        @track showSpinner = false;
        @track isdata = false;
        @track currentIndex = 0;
        subscription = null;
        @wire(MessageContext)
        messageContext;

        connectedCallback(){
            // this.showSpinner = true;
            this.subscription = subscribe(this.messageContext, Refresh_cmp, (message) => {
                if(message.refresh === true){
                    this.fetchingdata();
                    message.refresh = false;
                }
                });
            this.data = this.fetchingdata();
            refreshApex(this.data);
            // this.showSpinner = false;
        }

        unsubscribe(){
            unsubscribe(this.subscription);
            this.subscription = null;
            
        }
        disconnectedCallback(){
            this.unsubscribe();
        }
  
        fetchingdata(){
        this.showSpinner = true;
        fetchdata({ recordId: this.recordId })
                .then(result => {
                    this.data = result;
                    this.isdata = result && result.length > 0;
                    this.showSpinner = false;
                })
                .catch(error => {
                    console.error('Error fetching data:', error);
                });
    }

    get currentImageUrl() {
        return this.data && this.data.length > 0 ? this.data[this.currentIndex].FilenameUrlEncoded__c : '';
    }

    get currentImageName() {
        return this.data && this.data.length > 0 ? this.data[this.currentIndex].Name : '';
    }

    get currentImageTag() {
        var tags = this.data && this.data.length > 0 ? this.data[this.currentIndex].Tags__c : '';
    if (tags !== '' && tags != undefined) {
        tags = tags.split(';').map(tag => tag.trim()); // Trim whitespace from tags
    } else {
        tags = []; // If tags is empty, return an empty array
    }
    return tags;
    }

        showPreviousImage() {
            this.showSpinner = true;
            if (this.currentIndex > 0) {
                this.currentIndex--;
                this.showSpinner = false;
            }
            else {
                this.currentIndex = this.data.length - 1;
                this.showSpinner = false;
            }
        }

        showNextImage() {
            this.showSpinner = true;
            if (this.currentIndex < this.data.length - 1) {
                this.currentIndex++;
                this.showSpinner = false;
            }
            else {
                this.currentIndex = 0;
                this.showSpinner = false;
            }
        }

        reloadComponent() {
            this.showSpinner = true;
            this.fetchingdata();
            this.currentIndex = 0;
            this.showSpinner = false;
        }

        openImagePreview() {
            this.showSpinner = true;
            const imageUrl = this.currentImageUrl;
            if (imageUrl) {
                window.open(imageUrl, '_blank');
                this.showSpinner = false
            } else {
                console.error('No image URL available.');
            }
    }

    }