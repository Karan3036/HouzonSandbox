import { LightningElement, track, api,wire } from "lwc";
import getS3ConfigData from "@salesforce/apex/S3Service.getS3ConfigSettings";
import { loadScript } from "lightning/platformResourceLoader";
import AWS_SDK from "@salesforce/resourceUrl/AWSSDK";
import fetchdata from "@salesforce/apex/uploadController.fetchdataforlisting";
import createmedia from "@salesforce/apex/uploadController.createmediaforlisting";
import deletemedia from "@salesforce/apex/uploadController.deletelistingmedia";
import update_media_name from "@salesforce/apex/uploadController.update_media_name";
import updateOrderState from '@salesforce/apex/uploadController.updateOrderState';
import updateOrderState_toFalse from '@salesforce/apex/uploadController.updateOrderState_toFalse';
import { publish,MessageContext} from 'lightning/messageService';
import Refresh_msg from '@salesforce/messageChannel/refreshMessageChannel__c';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from 'lightning/refresh';
import {refreshApex} from '@salesforce/apex';
import updateSortOrder from '@salesforce/apex/uploadController.updateSortOrder';



export default class UploadImage extends LightningElement {
  @api recordId;
  /*========= Start - variable declaration =========*/
  s3; //store AWS S3 object
  isAwsSdkInitialized = false; //flag to check if AWS SDK initialized
  @track selectedFilesToUpload = []; //store selected file
  @track showSpinner = false; //used for when to show spinner
  @track fileName = []; //to display the selected file name
  @track uploadProgress = 0;
  @track fileSize = [];
  @track isfileuploading = false;
  @track data = [];
  @track isModalOpen = false;
  @track modalImageUrl;
  @track isnull = true;
  @track isdata = false;
  @track ispopup = false;
  @track isedit = false;
  @track isdeleteAll = false;
  @track rec_id_to_delete;
  @track undelete = false;
  @track disabled_cancel = true;
  @track imageUrl_to_upload;
  @track isdelete = false;
  @track rec_id_to_delete;
  @track rec_id_to_update;
  @track undelete = false;
  @track disabled_save = true;
  @track img_old_name;
  @track img_name;
  @track imageUrl_to_upload;
  @track imageTitle_to_upload;
  @track selected_url_type = 'Image';
  @track Expose = [];
  @track Website = [];
  @track Portal = [];
  @track sortOn = [];
  @track expose_records_to_update = [];
  @track portal_records_to_update = [];
  @track website_records_to_update = [];
  @track expose_records_to_update_false = [];
  @track portal_records_to_update_false = [];
  @track website_records_to_update_false = [];
  @track leaveTimeout;
  @track disabled_upload = true;
  @track items = [];
  get options() {
    return [
        { label: 'Image', value: 'Image' },
        { label: 'Video', value: 'Video' }
    ];
}
  @wire(MessageContext)
  messageContext;

    modalpopup(){
      this.ispopup = true;
    }

// To upload image using url    
    store_url(event){
      if(event.target.label === 'Title'){
        this.imageTitle_to_upload = event.target.value;
        console.log('imageTitle',this.imageTitle_to_upload);
      }
      if(event.target.label === 'External Link (URL)'){
        this.imageUrl_to_upload = event.target.value;
        if(this.imageUrl_to_upload && this.imageTitle_to_upload){
          this.disabled_upload = false;
        }else{
          this.disabled_upload = true;
        }
        console.log('imageURL',this.imageUrl_to_upload);
      }
    }
    handleLinkType(event){
      this.selected_url_type = event.target.value;
    }
    upload_image(){
      if(this.imageTitle_to_upload && this.imageUrl_to_upload){
        const videoId = this.createThumb(this.imageUrl_to_upload);
        if(this.selected_url_type === 'Image'){
          createmedia({
            recordId: this.recordId,
            Url:this.imageUrl_to_upload,
            Name: this.imageTitle_to_upload,
            // Size: this.fileSize
          }).then(result => {
            this.ispopup = false;
              this.data = result;
              this.fetchingdata();
              this.isedit = false;
              this.imageUrl_to_upload = null;
              this.imageTitle_to_upload = null;
              this.isnull = true;
            console.log(result);
          })
          .catch(error => {
            this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Error creating record',
                  message: 'Property not added.',
                  variant: 'error',
              }),
          );
              console.error('Error:', error);
                    
          });
        }
        if(this.selected_url_type === 'Video'){
            createmedia({
              recordId: this.recordId,
              Url: `https://img.youtube.com/vi/${videoId}/mqdefault.jpg`,
              Name: this.imageTitle_to_upload,
              external_link : this.imageUrl_to_upload
              // Size: this.fileSize
            }).then(result => {
              this.ispopup = false;
                this.data = result;
                this.fetchingdata();
                this.isedit = false;
                this.imageUrl_to_upload = null;
                this.imageTitle_to_upload = null;
                this.isnull = true;
              console.log(result);
            })  
            .catch(error => {
                console.error('Error:', error);
            });
        }
    if(this.selected_url_type === 'Document'){
      createmedia({
        recordId: this.recordId,
        Url:'https://www.iconpacks.net/icons/1/free-document-icon-901-thumb.png',
        Name: this.imageTitle_to_upload,
        external_link : this.imageUrl_to_upload
        // Size: this.fileSize
      }).then(result => {
        this.ispopup = false;
          this.data = result;
          this.fetchingdata();
          this.isedit = false;
          this.imageUrl_to_upload = null;
          this.imageTitle_to_upload = null;
          this.isnull = true;

        console.log(result);
      })
      .catch(error => {
          console.error('Error:', error);
      });
    }
      }else {
        console.error('Image URL and file name are required.');
      }
    }


    createThumb(videoUrl) {
      const regex = /(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
      const match = videoUrl.match(regex);
      return match ? match[1] : null;
    }


    
// update image name
    store_img_name(event){
      this.img_name = event.target.value;
      console.log('img_name',this.img_name);
    }
    edit_image_name(){
      console.log('old_img_name:',this.img_old_name);
      if(this.img_old_name != undefined && this.img_old_name != null && this.img_old_name != '' && this.img_name != undefined && this.img_name != null && this.img_name != ''){
        let oldKey = this.img_old_name.replace(/\s+/g, "_").toLowerCase();
        console.log('objkey:',oldKey);
      this.updateFileNameInS3(oldKey, this.img_name).then(() => {
          console.log('rec_id:',this.rec_id_to_update);
          console.log('rec_id:',this.img_name);
          this.isedit = false;
          return update_media_name({
            id: this.rec_id_to_update,
            fileName : this.img_name,
            url: `https://${this.confData.S3_Bucket_Name__c}.s3.amazonaws.com/${this.img_name}`
          });
      })
      .then(result => {
          // this.data = result;
          this.fetchingdata();
          this.img_name = null;
          this.isnull = true;
        console.log(result);
      });
      }
    }
    async updateFileNameInS3(oldKey, newKey) {
      try {
        this.initializeAwsSdk(this.confData);
        let bucketName = this.confData.S3_Bucket_Name__c;
        console.log('keyyyy:',oldKey);
        await this.s3.copyObject({
          CopySource: `/${bucketName}/${oldKey}`,
          Key: newKey,
          ACL: 'public-read',
        }).promise();
        await this.s3.deleteObject({
          Bucket: bucketName,
          Key: oldKey,
        }).promise();
    
        console.log('File name updated in S3');
      } catch (error) {
        console.error('Error updating file name in S3:', error);
      }
    } 

// To close popup window  
    closepopup(){
      this.ispopup = false;
      this.isdelete = false;
      this.isedit = false;
      this.disabled_cancel = true;
      this.disabled_save = true;
      this.isdeleteAll = false;
    }

    showImageInModal(imageUrl) {
        this.modalImageUrl = imageUrl;
        this.isModalOpen = true;
    }

    confirm_edit(){
      this.disabled_save=false;
      this.disabled_cancel=false;
      this.isedit = false;
    }
    save_changes(){
      console.log('save_called')
      if(this.expose_records_to_update || this.website_records_to_update || this.portal_records_to_update){
        console.log('save_here');
      updateOrderState({expose_ids:this.expose_records_to_update,
                            website_ids:this.website_records_to_update,
                            portal_ids:this.portal_records_to_update}).then(result => {
                                this.ispopup = false;
                                this.expose_records_to_update = [];
                                this.website_records_to_update = [];
                                this.portal_records_to_update = [];
                                this.fetchingdata();
                            });
      }

      if(this.expose_records_to_update_false || this.website_records_to_update_false || this.portal_records_to_update_false){
        console.log('save_here');
        updateOrderState_toFalse({expose_ids:this.expose_records_to_update_false,
                            website_ids:this.website_records_to_update_false,
                            portal_ids:this.portal_records_to_update_false}).then(result => {
                                this.ispopup = false;
                                this.expose_records_to_update_false = [];
                                this.website_records_to_update_false = [];
                                this.portal_records_to_update_false = [];
                                this.fetchingdata();
                            });
      }
      if(this.img_old_name && this.img_name){
        console.log('in img name change');
        this.edit_image_name();
      }
      this.save_order();
      // debugger;
      this.disabled_save = true;
      this.disabled_cancel=true;

    }
    cancel_changes(){
      console.log('inside cancel');
      this.disabled_save = true;
      this.disabled_cancel = true;
      this.img_name = this.img_old_name;
      this.website_records_to_update = [];
      this.expose_records_to_update = [];
      this.portal_records_to_update = [];
      this.fetchingdata();
      this.Expose = this.data;
      this.Portal = this.data;
      this.Website = this.data;
    }

    //to save the sorting order
    save_order(){
      console.log('inside save order');
      console.log(JSON.stringify(this.sortOn));
      //check if sortOn has Expose update the Expose list
      if(this.sortOn.includes('Expose')){
        console.log('inside expose');
        this.save_order_in_apex('Expose',this.Expose);
      }
      //check if sortOn has Website update the Website list
      if(this.sortOn.includes('Website')){
        console.log('inside website');
        this.save_order_in_apex('Website',this.Website);
      }
      //check if sortOn has Portal update the Portal list
      if(this.sortOn.includes('Portal')){
        console.log('inside portal');
        this.save_order_in_apex('Portal',this.Portal);
      }
      this.sortOn = [];      
    }

    //to save the sorting order in apex
    save_order_in_apex(type,mediaList){
      console.log('inside save order in apex');
      let mediaIds = mediaList.map(media => media.Id);
      console.log('mediaIds:',mediaIds);
      let mediaListToSave = mediaList.map((media,index) => {
        let mediaObject = {
          Id: media.Id,
        };
        return mediaObject;
      });
      if(type === 'Expose'){
        
        for(let i=0;i<mediaListToSave.length;i++){
          mediaListToSave[i].SortOnExpose__c = i;
        } 
      }
      if(type === 'Website'){
       
        for(let i=0;i<mediaListToSave.length;i++){
          mediaListToSave[i].SortOnWebsite__c = i;
        }
      }
      if(type === 'Portal'){
       
        for(let i=0;i<mediaListToSave.length;i++){
          mediaListToSave[i].SortOnPortalFeed__c = i;
        }
      }  
      console.log('mediaListToSave:',mediaListToSave);
      //pass the mediaListToSave to apex method named updateSortOrder and takes parameter list of PropertyMedia__c as mediaList to update the sort order
      updateSortOrder({ mediaList: mediaListToSave })
      .then(result => {
          if (result) {
              console.log('result:',result);
              debugger;
          }
      })
      .catch(error => {
          console.error('Error updating sort order:', error);
      });
    }

// To delete media    
  handleDelete() {
      try {
          this.isdelete = false;
          // this.showSpinner = true;
          deletemedia({ id: this.rec_id_to_delete }).then(() => {
            this.fetchingdata();
          });
          
      } catch (error) {
          console.error('Error deleting media:', error);
      } finally {
        console.log('true');
          // this.showSpinner = false;
      }
  }
// To delete all media  
  to_deleteAllMedia(){
    this.isdeleteAll = true;
  }

 deleteAllMedia(){
    try {
      this.showSpinner = true;
      this.isdeleteAll = false;
      deletemedia({ property_id: this.recordId }).then(() => {
        this.fetchingdata();
      })
  } catch (error) {
      console.error('Error deleting media:', error);
  } finally {
      this.showSpinner = false;
  }
  }
    removefile(){
      this.selectedFilesToUpload = null;
      this.fileName = null;
      this.fileSize = null;
      this.isnull = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
    

  // @track  columns = [
  //       { label: 'Thumbnail', fieldName: 'FilenameUrlEncoded__c', type: 'customImage'},
  //       { label: 'Title', fieldName: 'Name'},
  //       { label: 'Size (kb)', fieldName: 'Size__c', type: 'formattedSize' },

  //       {label: "ON Expose", fieldName: "IsOnExpose__c", type: "Boolean" }, 
      
  //     {
  //         type: 'button-icon',
  //         typeAttributes: {
  //             iconName: 'utility:preview',
  //             label: '',
  //             name: 'view',
  //             title: 'View',
  //             disabled: false,
  //         }
  //       },
  //       {
  //         type: 'button-icon',
  //           typeAttributes: {
  //           iconName: 'utility:download',
  //           label: '',
  //           name: 'download',
  //           title: 'download',
  //           disabled: false,
  //           value: 'test',
  //         }
  //       },
  //       {
  //         type: 'button-icon',
  //           typeAttributes: {
  //           iconName: 'utility:edit',
  //           label: '',
  //           name: 'edit',
  //           title: 'edit',
  //           disabled: false,
  //           value: 'test',
  //         }
  //       },
  //       {
  //         type: 'button-icon',
  //         typeAttributes: {
  //             iconName: 'utility:delete',
  //             label: '',
  //             name: 'delete',
  //             title: 'Delete',
  //             disabled: false,
  //             class:{fieldName: 'ModeClass'}         }
  //       },        
  //   ];


  get formattedData() {
      // Add 'kb' to the size field and return the modified data
      return this.data.map(item => ({
          ...item,
          Size__c: `${item.Size__c}kb`
      }));
  }
  storeCheckedValue(event){
    console.log('here');
    if(event.target.name==='expose' ){
      console.log('hello',event.target.checked);
      if(event.target.checked ===true){
        this.expose_records_to_update.push(event.currentTarget.dataset.key);
        this.website_records_to_update.push(event.currentTarget.dataset.key);
        this.portal_records_to_update.push(event.currentTarget.dataset.key);
        console.log('hello here');
        console.log(this.expose_records_to_update);
        console.log('this is target',event.target);
        var itemID = event.target.dataset.key;

    // Update all checkboxes based on the checkbox clicked
        webitem = this.template.querySelectorAll('[data-key="' + itemID + '"]');
        webitem.IsOnPortalFeed__c = true;
        webitem.IsOnWebsite__c = true;
        this.disabled_save=false;
        this.disabled_cancel=false;
      }else{
        this.expose_records_to_update_false.push(event.currentTarget.dataset.key);
        this.website_records_to_update_false.push(event.currentTarget.dataset.key);
        this.portal_records_to_update_false.push(event.currentTarget.dataset.key);

        this.disabled_save=false;
      this.disabled_cancel=false;
        // this.expose_records_to_update.splice(indexOf(event.currentTarget.dataset.key),1);
      }
    }
    if(event.target.name==='website'){
      if(event.target.checked ===true){
      this.website_records_to_update.push(event.currentTarget.dataset.key);
      console.log('hello here web');
      console.log(this.website_records_to_update);
      this.disabled_save=false;
      this.disabled_cancel=false;
      }else{
        this.website_records_to_update_false.push(event.currentTarget.dataset.key);
        this.disabled_save=false;
        this.disabled_cancel=false;

        // this.website_records_to_update.splice(indexOf(event.currentTarget.dataset.key),1);
      }
    }
    if(event.target.name==='portal'){
      if(event.target.checked ===true){
      this.portal_records_to_update.push(event.currentTarget.dataset.key);
      console.log('hello here portal');
      console.log(this.portal_records_to_update);
      this.disabled_save=false;
      this.disabled_cancel=false;
      }else{
        this.portal_records_to_update_false.push(event.currentTarget.dataset.key);
        this.disabled_save=false;
      this.disabled_cancel=false;

        // this.portal_records_to_update.splice(indexOf(event.currentTarget.dataset.key),1);
      }
    }
  }

  handle_preview(event){
    console.log('inside handle_preview');
    console.log(event.currentTarget.dataset.key);
    if(event.currentTarget.dataset.exturl){
      window.open(event.currentTarget.dataset.url, '_blank');
    }else{
      this.showImageInModal(event.currentTarget.dataset.url);
    }
  }
  delete_row(event){
    this.rec_id_to_delete = event.currentTarget.dataset.key;
    this.isdelete = true;
  }
  download_row_image(event){
    this.handleDownload(event.currentTarget.dataset.url,event.currentTarget.dataset.name);
  }
  edit_image_name_to_store(event){
    this.rec_id_to_update = event.currentTarget.dataset.key
    this.img_old_name = event.currentTarget.dataset.name;
    console.log('old_name: ' + this.img_old_name);
    this.isedit = true;
  }

// handleRowAction(event) {
//     const action = event.detail.action;
//     const row = event.detail.row;
//     switch (action.name) {
//         case 'view':
//           if(row.ExternalLink__c){
//             window.open(row.ExternalLink__c, '_blank');
//           }else{
// 			      this.showImageInModal(row.FilenameUrlEncoded__c);
//           }
//           break;
//         // case 'checkbox':
//         //   if(this.checkIcon === 'utility:check') {
//         //     row.IsOnExpose__c = false;
//         //     this.checkIcon = 'utility:close'
//         //   }
//         //   else if(this.checkIcon === 'utility:close'){
//         //     row.IsOnExpose__c = true;
//         //     this.checkIcon = 'utility:check'
//         //   }
//         //   break;
//         case 'delete':
//           row.ModeClass = 'slds-hidden';
//             this.rec_id_to_delete = row.Id;
//             this.isdelete = true;
//             // this.handleDelete(row.Id);// Call the delete method with the record Id
//             this.dispatchEvent(new RefreshEvent());  
//           break;
//         case 'download':
//             this.handleDownload(row.FilenameUrlEncoded__c,row.Name);// Call the delete method with the record Id
//             this.dispatchEvent(new RefreshEvent());  
//           break;
//         case 'edit':
//             this.rec_id_to_update = row.Id;
//             this.img_old_name = row.Name;
//             this.isedit = true;
//             this.dispatchEvent(new RefreshEvent());  
//           break;  
//         // Add more actions as needed
//     }
// }

// To download image
handleDownload(url,Name){
  console.log('dwnld:',url);
  console.log('dwnld:',Name);

  const downloadContainer = this.template.querySelector('.download-container');
  const a = document.createElement("a");
        
  a.href = url;
  console.log('dwnld:',a.href);
  a.download = Name;
  a.target = '_blank';
  console.log('dwnld_name:',a);
  if (downloadContainer) {
  downloadContainer.appendChild(a);
  }
  a.click();
  downloadContainer.removeChild(a);
}



  confData;
  @track fileURL = [];

  fetchingdata(){
    console.log('called');
    this.showSpinner = true;
      setTimeout(() => {
        fetchdata({ recordId: this.recordId })
                .then(result => {
                  this.data = result;
                  if(result.length===0){
                    this.dispatchEvent(
                      new ShowToastEvent({
                          title: 'Error creating record',
                          message: 'Property not added in this record.',
                          variant: 'error',
                      }),
                    )
                  }
                  console.log('data from apex:',result);
                    //iterate over the data and sort according to the SortOnExpose__c 
                    this.Expose = this.data.filter(media => media.SortOnExpose__c !== null && media.IsOnExpose__c!==false).sort((a, b) => a.SortOnExpose__c - b.SortOnExpose__c);
                    this.Website = this.data.filter(media => media.SortOnWebsite__c !== null && media.IsOnWebsite__c!==false).sort((a, b) => a.SortOnWebsite__c - b.SortOnWebsite__c);
                    this.Portal = this.data.filter(media => media.SortOnPortalFeed__c !== null && media.IsOnPortalFeed__c!==false).sort((a, b) => a.SortOnPortalFeed__c - b.SortOnPortalFeed__c);
                    this.data.forEach(row =>row.Size__c = row.Size__c ? row.Size__c + ' ' + 'kb' : 'External');
                    this.isdata = result && result.length > 0;
                    console.log('isdata:',JSON.stringify(this.isdata));
                    this.showSpinner = false;
                    const message = {
                      refresh: true
                  };
                  publish(this.messageContext, Refresh_msg, message);
                    refreshApex(this.data);
                })
                .catch(error => {
                    console.error('Error fetching data:', error);
                });
      }, 2000);  

  }

  connectedCallback() {
    console.log('In the connected callback');
    this.showSpinner = true;
    this.getS3ConfigDataAsync();
    this.fetchingdata();
    this.showSpinner = false;
  }

  async getS3ConfigDataAsync() {
    try {
      this.confData = await getS3ConfigData();
      console.log("check data ", this.confData);
    } catch (error) {
      console.log("error in async ", error);
    }
  }

  renderedCallback() {
    if (this.isAwsSdkInitialized) {
      return;
    }
    Promise.all([loadScript(this, AWS_SDK)])
      .then(() => {
        //For demo, hard coded the Record Id. It can dynamically be passed the record id based upon use cases
        console.log("sdk Loaded");
      })
      .catch((error) => {
        console.error("error -> ", error);
      });
  }

  //Initializing AWS SDK
  initializeAwsSdk(confData) {
    try {
      let AWS = window.AWS;
      console.log("inside confData", confData);
      console.log("inside initializeAwsSdk", AWS);

      AWS.config.update({
        accessKeyId: confData.AWS_Access_Key__c, //Assigning access key id
        secretAccessKey: confData.AWS_Secret_Access_Key__c //Assigning secret access key
      });

      AWS.config.region = confData.S3_Region_Name__c; //Assigning region of S3 bucket

      this.s3 = new AWS.S3({
        apiVersion: "2006-03-01",
        params: {
          Bucket: confData.S3_Bucket_Name__c //Assigning S3 bucket name
        }
      });

      this.isAwsSdkInitialized = true;
    } catch (error) {
      console.log("error initializeAwsSdk ", error);
    }
  }

  //get the file name from user's selection
  handleSelectedFiles(event) {
    if (event.target.files.length > 0) {
      for(let file = 0 ; file < event.target.files.length ; file++) {
        this.selectedFilesToUpload.push(event.target.files[file]);
        this.isnull = false;
        this.fileName.push(event.target.files[file].name);
        this.fileSize.push(Math.floor((event.target.files[file].size)/1024));
        this.items.push({label:event.target.files[file].name});
      }
      console.log("fileName ====> " + this.fileName);
      console.log("fileSize ====> " + this.fileSize);

    }
  }
  handleRemove(event){
    this.selectedFilesToUpload.splice(event.target.key, 1);
    this.isnull = false;
    this.fileName.splice(event.target.key, 1);
    this.fileSize.splice(event.target.key, 1);
    this.items.splice(event.target.key, 1);
    
    console.log("Selectedfile ====> " + this.selectedFilesToUpload);
    console.log("fileName ====> " + this.fileName);
    console.log("fileSize ====> " + this.fileSize);
    if(this.fileName.length === 0){
      this.isnull = true;
    }
  }

  handleclick(event){
      this.uploadToAWS()
        .then(() => {
          var contents = [];
            for(let file=0; file<this.selectedFilesToUpload.length; file++){
            contents.push(createmedia({
                recordId: this.recordId,
                Url: this.fileURL[file],
                Name: this.selectedFilesToUpload[file].name,
                Size: this.fileSize[file],
            }));
          }
          console.log('contents',contents);
          return contents;
        }).then(result => {
          if(result){
          console.log('result',result);
            this.data = result;
            this.fetchingdata();
            console.log('data',this.data);
            this.selectedFilesToUpload = [];
            this.fileName = [];
            this.isnull = true;
            this.isdata = true;
          }
          else{
              this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Property not added.',
                    variant: 'error',
                }),
              )
            }
            refreshApex(this.data);
          //   const message = {
          //     refresh: true
          // };
          // publish(this.messageContext, Refresh_msg, message);
          console.log(result);
        })
        .catch(error => {
          alert(error.message);
          this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating record',
                message: 'Property not added.',
                variant: 'error',
            }),
        );
            console.error('Error:', error);
        });
}

 
async uploadToAWS() {
  try {
    for(let f=0; f<this.selectedFilesToUpload.length; f++) {
    this.initializeAwsSdk(this.confData);

    let file = this.selectedFilesToUpload[f];
    console.log("file ", file);

    if (this.selectedFilesToUpload[f]) {
      // for(let selected_file=0; selected_file < this.selectedFilesToUpload.length; selected_file++){
      let objKey = this.selectedFilesToUpload[f].name
        .replace(/\s+/g, "_")
        .toLowerCase();
      
      let params = {
        Key: objKey,
        ContentType: this.selectedFilesToUpload[f].type,
        Body: this.selectedFilesToUpload[f],
        ACL: "public-read"
      };

      // Use S3 upload method for progress tracking (no need for ManagedUpload constructor)
    let upload = this.s3.upload(params);
	  this.isfileuploading = true;
      upload.on('httpUploadProgress', (progress) => {
        // Calculate and update the upload progress
        this.uploadProgress = Math.round((progress.loaded / progress.total) * 100);
        console.log("Upload progress: ", this.uploadProgress);
      });

      console.log("Starting upload...");

      await upload.promise(); // Wait for the upload to complete

      console.log("Upload completed successfully!");

      let bucketName = this.confData.S3_Bucket_Name__c;
      this.fileURL.push(`https://${bucketName}.s3.amazonaws.com/${objKey}`);
      console.log("Success");
		this.isfileuploading = false;
		this.uploadProgress = 0;
      this.listS3Objects();
    }
    }
  } catch (error) {
    console.error("Error in uploadToAWS: ", error);
  }
}

  //listing all stored documents from S3 bucket
  listS3Objects() {
    try {
      this.s3.listObjects((err, data) => {
        if (err) {
          console.log("Error", err);
        } else {
          console.log("fileURL", this.fileURL);
          console.log("Success", data.Contents);
        }
      });
    } catch (error) {
      console.log("error ", error);
    }
  }
  allowDrop(event) {
  event.preventDefault();
  // console.log("allowDrop triggered");
  }

  handleDrop(event) {
    event.preventDefault();
    console.log("handleDrop triggered");
    const files = event.dataTransfer.files;
    console.log(files);
    console.log(files[0].type);
    if(files[0].type == 'image/png' || files[0].type == 'image/jpg' || files[0].type == 'image/jpeg'){
      this.fileSize = Math.floor((files[0].size)/1024);
      this.selectedFilesToUpload = files[0];
      this.isnull = false;
      this.fileName = files[0].name;
    }
    else{
      this.showToast();
    }
  }

  showToast() {
    const event = new ShowToastEvent({
        title: 'Error',
        message:
            'File type Incorrect',
        variant: 'Error',
    });
    this.dispatchEvent(event);
  }

  

  handleDragOver(event) {
    event.preventDefault();
  }

  handleDragStart(event) {
    const index = event.target.dataset.index;
    event.dataTransfer.setData('index', index);
    // this.data[index].displayStyle = "display: hidden";
    console.log(index);
}
findParentWithDataIndex(element) {
  let parent = element.parentElement;
  while (parent) {
      const index = parent.getAttribute('data-index');
      if (index !== null) {
          return index;
      }
      parent = parent.parentElement;
  }
  return null;
}

handleDragEnter(event) {
  event.preventDefault();
  event.target.closest(".dropableimage").classList.add("highlight");
  clearTimeout(leaveTimeout);
}

handleDragLeave(event) {
  event.preventDefault();
  const dropableImage = event.currentTarget.closest(".dropableimage");
  if (!dropableImage.contains(event.relatedTarget)) {
    leaveTimeout = setTimeout(() => {
      dropableImage.classList.remove("highlight");
    }, 200);
  }
}

handledDrop(event) {
  
    event.preventDefault();
    event.target.closest(".dropableimage").classList.remove("highlight");
    var tempdata = [];
    const draggedIndex = event.dataTransfer.getData('index');
    const droppedIndex = this.findParentWithDataIndex(event.target);
    console.log(draggedIndex);
    console.log(droppedIndex);
    const dataType = event.currentTarget.dataset.type;
    console.log(dataType);
    if (!this.sortOn.includes(dataType)) {
        this.sortOn.push(dataType);
    }
    switch (dataType) {
      case 'Expose':
        tempdata = this.Expose;
          break;
      case 'Website':
        tempdata = this.Website;
          break;
      case 'Portal':
        tempdata = this.Portal;
          break;
      default:
          // Default case
          break;
  }


    if (draggedIndex === droppedIndex) {
        return;
    }

    const draggedMediaId = tempdata[draggedIndex].Id;
    const droppedMediaId = tempdata[droppedIndex].Id;
    console.log(draggedMediaId);
    console.log(droppedMediaId);

    
    // Rearrange the media IDs based on the new order
    var reorderedMediaIds = this.reorderMediaIds(draggedMediaId, droppedMediaId, draggedIndex, droppedIndex, tempdata);
    console.log(reorderedMediaIds);

    tempdata = reorderedMediaIds.map(mediaId => {
      return tempdata.find(item => item.Id === mediaId);
  });

  switch (dataType) {
    case 'Expose':
      this.Expose = reorderedMediaIds.map(mediaId => {
        return this.Expose.find(item => item.Id === mediaId);
    });
    this.disabled_cancel = false;
    this.disabled_save = false;
        break;
    case 'Website':
      this.Website = reorderedMediaIds.map(mediaId => {
        return this.Website.find(item => item.Id === mediaId);
    });
    this.disabled_cancel = false;
    this.disabled_save = false;
        break;
    case 'Portal':
      this.Portal = reorderedMediaIds.map(mediaId => {
        return this.Portal.find(item => item.Id === mediaId);
    });
    this.disabled_cancel = false;
    this.disabled_save = false;
        break;
    default:
        // Default case
        break;
}

    // Call the Apex method to update the sort order
    // updateSortOrder({ mediaIds: reorderedMediaIds })
    //     .then(result => {
    //         if (result) {
    //             this.Expose = this.result;
    //             return refreshApex(this.data);
    //         }
    //     })
    //     .catch(error => {
    //         console.error('Error updating sort order:', error);
    //     });
}

reorderMediaIds(draggedMediaId, droppedMediaId, draggedIndex, droppedIndex, tempdata) {
  var reorderedMediaIds = [...tempdata.map(media => media.Id)];
  console.log(reorderedMediaIds);
  console.log(draggedIndex);
  console.log(droppedIndex);

  if (draggedIndex < droppedIndex) {
    console.log('inside 1');
      // Dragged image is moved downwards
      for (let i = parseInt(draggedIndex); i < parseInt(droppedIndex); i++) {
          console.log('index manipulated', i);
          console.log(reorderedMediaIds[i]);
          console.log(tempdata[i + 1].Id);
          reorderedMediaIds[i] = tempdata[i + 1].Id;
          console.log(reorderedMediaIds[i]);

          
      }
  } else {
    console.log('inside 2');
      // Dragged image is moved upwards
      for (let i = parseInt(draggedIndex); i > parseInt(droppedIndex); i--) {
          reorderedMediaIds[i] = tempdata[i - 1].Id;
          console.log(reorderedMediaIds[i]);
          console.log(tempdata[i - 1].Id);
          console.log('index manipulated', i);
          console.log(reorderedMediaIds[i]);

      }
  }

  reorderedMediaIds[parseInt(droppedIndex)] = draggedMediaId;
  console.log(reorderedMediaIds);

  return reorderedMediaIds;
}

getwebsite(){
  this.Website = this.data;
  this.data.forEach(item => {
    item.IsOnWebsite__c = true; // Assuming 'IsOnExpose__c' is the field representing whether it's exposed
    this.website_records_to_update.push(item.Id);
});
  this.disabled_save=false;
  this.disabled_cancel=false;
}

clearwebsite(){
  this.Website = null;
  this.data.forEach(item => {
    item.IsOnWebsite__c = false; // Assuming 'IsOnExpose__c' is the field representing whether it's exposed
    this.website_records_to_update_false.push(item.Id);
});
  this.disabled_save=false;
  this.disabled_cancel=false;
}

getexpose(){
  this.Expose = this.data;
    this.data.forEach(item => {
      item.IsOnExpose__c = true; // Assuming 'IsOnExpose__c' is the field representing whether it's exposed
      this.expose_records_to_update.push(item.Id);
  });
  this.getportal();
  this.getwebsite();
  this.disabled_save=false;
  this.disabled_cancel=false;
}

clearexpose(){
  this.Expose = null;
  this.data.forEach(item => {
    item.IsOnExpose__c = false; // Assuming 'IsOnExpose__c' is the field representing whether it's exposed
    this.expose_records_to_update_false.push(item.Id);
});
  this.clearportal();
  this.clearwebsite();
  this.disabled_save=false;
  this.disabled_cancel=false;
}

getportal(){
  this.Portal = this.data;
    this.data.forEach(item => {
      item.IsOnPortalFeed__c = true; // Assuming 'IsOnExpose__c' is the field representing whether it's exposed
      this.portal_records_to_update.push(item.Id);
  });
  this.disabled_save=false;
  this.disabled_cancel=false;
}

clearportal(){
  this.Portal = null;
  this.data.forEach(item => {
    item.IsOnPortalFeed__c = false; // Assuming 'IsOnExpose__c' is the field representing whether it's exposed
    this.portal_records_to_update_false.push(item.Id);
});
  this.disabled_save=false;
  this.disabled_cancel=false;
}




}