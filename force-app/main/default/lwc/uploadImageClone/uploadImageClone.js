import { LightningElement, track, api,wire } from "lwc";
import getS3ConfigData from "@salesforce/apex/S3Service.getS3ConfigSettings";
import { loadScript } from "lightning/platformResourceLoader";
import AWS_SDK from "@salesforce/resourceUrl/AWSSDK";
import fetchdata from "@salesforce/apex/uploadController.fetchdata";
import createmedia from "@salesforce/apex/uploadController.createmedia";
import deletemedia from "@salesforce/apex/uploadController.deletemedia";
import update_media_name from "@salesforce/apex/uploadController.update_media_name";
import { publish,MessageContext} from 'lightning/messageService';
import Refresh_msg from '@salesforce/messageChannel/refreshMessageChannel__c';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from 'lightning/refresh';
import {refreshApex} from '@salesforce/apex';



export default class UploadImageClone extends LightningElement {
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
  @track cancel_changes = true;
  @track isdeleteAll = false;
  @track rec_id_to_delete;
  @track undelete = false;
  @track disabled_cancel = true;
  @track imageUrl_to_upload;
  @track isdelete = false;
  @track rec_id_to_delete;
  @track objKey_to_delete;
  @track rec_id_to_update;
  @track undelete = false;
  @track disabled_save = true;
  @track img_old_name;
  @track img_name;
  @track imageUrl_to_upload;
  @track imageTitle_to_upload;
  @track selected_url_type = 'Image';
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
              this.fetchingdata()
              this.imageUrl_to_upload = null;
              this.imageTitle_to_upload = null;
              this.isnull = true;
            console.log(result);
          })
          .catch(error => {
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
                this.fetchingdata()
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
          this.fetchingdata()
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
    async edit_image_name(){
      console.log('old_img_name:',this.img_old_name);
      let oldKey = this.img_old_name.replace(/\s+/g, "_").toLowerCase();
      console.log('objkey:',oldKey);
      await this.updateFileNameInS3(oldKey, this.img_name).then(() => {
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
        this.data = result;
        this.fetchingdata()
        this.img_name = null;
        this.isnull = true;
      console.log(result);
    });
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
      this.edit_image_name();
      this.disabled_save = true;
      this.disabled_cancel=true;

    }
    cancel_changes(){
      this.disabled_save = true;
      this.disabled_cancel = true;
      this.img_name = this.img_old_name;
    }

// To delete media    
  async handleDelete() {
      try {
          this.showSpinner = true;
          // this.initializeAwsSdk(this.confData);
          // let bucketName = this.confData.S3_Bucket_Name__c;
          // await this.s3.deleteObject({
          //   Bucket: bucketName,
          //   Key: this.objKey_to_delete ,
          // }).promise();
          await deletemedia({ id: this.rec_id_to_delete }).then(() => {
            this.fetchingdata();
            this.isdelete = false;
          });
          
      } catch (error) {
          console.error('Error deleting media:', error);
      } finally {
          this.showSpinner = false;
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

  @track  columns = [
        { label: 'Thumbnail', fieldName: 'FilenameUrlEncoded__c', type: 'customImage'},
        { label: 'Title', fieldName: 'Name'},
        { label: 'Size (kb)', fieldName: 'Size__c', type: 'formattedSize' },
        {
          type: 'button-icon',
          typeAttributes: {
              iconName: 'utility:preview',
              label: '',
              name: 'view',
              title: 'View',
              disabled: false,
          }
        },
        {
          type: 'button-icon',
            typeAttributes: {
            iconName: 'utility:download',
            label: '',
            name: 'download',
            title: 'download',
            disabled: false,
            value: 'test',
          }
        },
        {
          type: 'button-icon',
            typeAttributes: {
            iconName: 'utility:edit',
            label: '',
            name: 'edit',
            title: 'edit',
            disabled: false,
            value: 'test',
          }
        },
        {
          type: 'button-icon',
          typeAttributes: {
              iconName: 'utility:delete',
              label: '',
              name: 'delete',
              title: 'Delete',
              disabled: false,
              class:{fieldName: 'ModeClass'}         }
        },        
    ];


  get formattedData() {
      // Add 'kb' to the size field and return the modified data
      return this.data.map(item => ({
          ...item,
          Size__c: `${item.Size__c}kb`
      }));
  }



handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;
    switch (action.name) {
        case 'view':
          if(row.ExternalLink__c){
            window.open(row.ExternalLink__c, '_blank');
          }else{
			      this.showImageInModal(row.FilenameUrlEncoded__c);
          }
          break;
        case 'delete':
          row.ModeClass = 'slds-hidden';
          this.objKey_to_delete = row.Name;
            this.rec_id_to_delete = row.Id;
            this.isdelete = true;

            // this.handleDelete(row.Id);// Call the delete method with the record Id
            this.dispatchEvent(new RefreshEvent());  
          break;
        case 'download':
            this.handleDownload(row.FilenameUrlEncoded__c,row.Name);// Call the delete method with the record Id
            this.dispatchEvent(new RefreshEvent());  
          break;
        case 'edit':
            this.rec_id_to_update = row.Id;
            this.img_old_name = row.Name;
            this.isedit = true;
            this.dispatchEvent(new RefreshEvent());  
          break;  
        // Add more actions as needed
    }
}

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
                    console.log('data from apex:',result);
                    this.data.forEach(row =>row.Size__c = row.Size__c ? row.Size__c + ' ' + 'kb' : 'External');
                    this.isdata = result && result.length > 0;
                    
                    console.log('result:',this.data);
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
    console.log('here=======>');
    if (event.target.files.length > 0) {

      for(let file = 0 ; file < event.target.files.length ; file++) {
        console.log('here in files=======>');
        this.selectedFilesToUpload.push(event.target.files[file]);
        console.log('here in files=======>',this.selectedFilesToUpload);
        this.isnull = false;
        this.fileName.push(event.target.files[file].name);
        this.fileSize.push(Math.floor((event.target.files[file].size)/1024));
        console.log('here in files=======>',this.fileName);
        console.log('here in files=======>',this.fileSize);


      }
      this.dispatchEvent(new RefreshEvent());  

      console.log("fileName ====> " + this.fileName);
      console.log("fileSize ====> " + this.fileSize);

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
          console.log('result',result);
            this.data = result;
            this.fetchingdata();
            console.log('data',this.data);
            this.selectedFilesToUpload = [];
            this.fileName = [];
            this.isnull = true;
            this.isdata = true;
            this.dispatchEvent(new RefreshEvent());  
            refreshApex(this.data);
          //   const message = {
          //     refresh: true
          // };
          // publish(this.messageContext, Refresh_msg, message);
          console.log(result);
        })
        .catch(error => {
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

  showToast() {
    const event = new ShowToastEvent({
        title: 'Error',
        message:
            'File type Incorrect',
        variant: 'Error',
    });
    this.dispatchEvent(event);
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
}