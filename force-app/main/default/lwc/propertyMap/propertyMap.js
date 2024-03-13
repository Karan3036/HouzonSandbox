// import { LightningElement, api,track } from 'lwc';

// import propertyMapController from '@salesforce/apex/propertyMapController.propertyMapController';

// export default class PropertyMap extends LightningElement {
//     @api recordId;
//     @track mapMarkers = []
    
//     connectedCallback(){
//         console.log(this.recordId);
//         this.getDataFromApex()
//     }

//     getDataFromApex(){
//         propertyMapController({ sObjectApiName: 'Listing_hz__c',  rid : this.recordId})
//         .then( result => {
//                     console.log(result);
//             // Create a new list of objects with the specified key-value pairs
//             this.mapMarkers = result.map(inputObject => ({
//                 location: {
//                     Latitude: inputObject.Latitude_hz__c,
//                     Longitude: inputObject.Longitude_hz__c
//                 },
//                 value: inputObject.Id,
//                 title: inputObject.Name,
//                 description: inputObject.Address_hz__c
//             }));

//             console.log('log:--> ',this.mapMarkers);
//         }).catch( error => {

//         })
//     }
//     selectedMarkerValue = 'SF2';

//     handleMarkerSelect(event) {
//         this.selectedMarkerValue = event.target.selectedMarkerValue;
//     }
// }

import { LightningElement, api, wire, track } from 'lwc';
import propertyMapController from '@salesforce/apex/propertyMapController.propertyMapController';

export default class PropertyMap extends LightningElement {
    @api recordId;
    @track mapMarkers = [];

    // Wire method to call the Apex method imperatively
    @wire(propertyMapController, { sObjectApiName: 'Listing_hz__c', rid: '$recordId' })
    wiredData({ error, data }) {
        if (data) {
            this.mapMarkers = data.map(inputObject => ({
                location: {
                    Latitude: inputObject.Latitude_hz__c,
                    Longitude: inputObject.Longitude_hz__c
                },
                value: inputObject.Id,
                title: inputObject.Name,
                description: inputObject.Address_hz__c
            }));
            console.log('log:--> ', this.mapMarkers);
        } else if (error) {
            // Handle the error if needed
            console.error(error);
        }
    }

    selectedMarkerValue = 'SF2';

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
    }
}