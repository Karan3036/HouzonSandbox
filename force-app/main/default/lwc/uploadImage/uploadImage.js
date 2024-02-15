import { LightningElement, track } from "lwc";
import getS3ConfigData from "@salesforce/apex/S3Service.getS3ConfigSettings";
import { loadScript } from "lightning/platformResourceLoader";
import AWS_SDK from "@salesforce/resourceUrl/AWSSDK";

export default class UploadImage extends LightningElement {
  /*========= Start - variable declaration =========*/
  s3; //store AWS S3 object
  isAwsSdkInitialized = false; //flag to check if AWS SDK initialized
  selectedFilesToUpload; //store selected file
  @track showSpinner = false; //used for when to show spinner
  @track fileName; //to display the selected file name
  confData;
  fileURL = "";

  connectedCallback() {
    this.getS3ConfigDataAsync();
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
      this.selectedFilesToUpload = event.target.files[0];
      this.fileName = event.target.files[0].name;
      console.log("fileName ====> " + this.fileName);
    }
  }

  //file upload to AWS S3 bucket
  uploadToAWS() {
    try {
      this.initializeAwsSdk(this.confData);
      let file = this.selectedFilesToUpload;
      console.log("file ", file);
      if (this.selectedFilesToUpload) {
        this.showSpinner = true;
        let objKey = this.selectedFilesToUpload.name
          .replace(/\s+/g, "_") //each space character is being replaced with _
          .toLowerCase();

        this.s3.putObject(
          {
            Key: objKey,
            ContentType: this.selectedFilesToUpload.type,
            Body: this.selectedFilesToUpload,
            ACL: "public-read"
          },
          (err) => {
            if (err) {
              let e = err.Name;
              this.showSpinner = false;
              console.error("check your error --> ", { e });
            } else {
              let bucketName = this.confData.S3_Bucket_Name__c;
              this.fileURL = `https://${bucketName}.s3.amazonaws.com/${objKey}`;
              this.showSpinner = false;
              console.log("Success");
              this.listS3Objects();
            }
          }
        );
      }
    } catch (error) {
      console.log("error uploadToAWS ", error);
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
}