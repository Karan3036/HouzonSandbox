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
import { loadScript } from 'lightning/platformResourceLoader';
import HTML2CANVAS from '@salesforce/resourceUrl/html2css1';

export default class PropertyMap extends LightningElement {

    // const vfPageUrl = `/apex/${this.PageName}?id=${this.recordId}`;

    // @api recordId;
    // @track mapMarkers = [];
    // @track imgsrc = '';
    // @track PageName = 'DisplayMap';
    // @track vfPageUrl = `/apex/${this.PageName}?id=${this.recordId}`;

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

    // selectedMarkerValue = 'SF2';

    // handleMarkerSelect(event) {
    //     this.selectedMarkerValue = event.target.selectedMarkerValue;
    // }


    // connectedCallback() {
 
    //     loadScript(this, HTML2CANVAS).then(() => {
    //         console.log('html2canvas loaded');
    //         this.printDiv();
    //         console.log('After call method');
    //     });
    // }



    // printDiv() {
    //     this.imgsrc = '';
    //     html2canvas(this.template.querySelector('.print-preview-div'),{ 
    //         scale: "5",
    //         onrendered: (canvas)=> {
    //             //show image
    //             var myCanvas = this.template.querySelector('.my_canvas_id');
    //             var ctx = myCanvas.getContext('2d');
    //             ctx.webkitImageSmoothingEnabled = false;
    //             ctx.mozImageSmoothingEnabled = false;
    //             ctx.imageSmoothingEnabled = false;
    //             console.log('ctx >> ', ctx);
    //             var img = new Image;
    //             img.onload = function(){
    //                 ctx.drawImage(img,0,0,270,350); // Or at whatever offset you like
    //             };
    //             console.log('img >> ', canvas.toDataURL());
    //             img.src = canvas.toDataURL();
    //             this.imgsrc = img.src;
    //         }
    //     });
    // }
}