import { LightningElement, track, api } from "lwc";
// import portalSyndicationData from "./portalSyndicationData";
import fetchPortals from "@salesforce/apex/PortalSyndicationController.fetchPortals";
import createPortalListingRecord from "@salesforce/apex/PortalSyndicationController.createPortalListingRecord";
import { loadStyle } from "lightning/platformResourceLoader";
import overrideCSS from "@salesforce/resourceUrl/overrideCSS";

const columns = [
  { label: "Portal Name", fieldName: "name", hideDefaultActions: true },
  {
    label: "Portal Status",
    type: "customName",
    typeAttributes: {
      status: { fieldName: "status" },
      class: { fieldName: "badgeColor" }
    },
    hideDefaultActions: true
  },
  {
    type: "button",
    typeAttributes: {
      label: { fieldName: "buttonLabel" },
      name: "publish",
      variant: { fieldName: "buttonColor" }
    }
  }
];

export default class PortalSyndicationCmp extends LightningElement {
  hasLoadedStyle = false;
  @api recordId;
  @track portalId;
  data = [];
  showSpinner = true;
  columns = columns;

  async connectedCallback() {
    try {
        const data = await fetchPortals({ listingId: this.recordId });
        this.data = data;
        this.showSpinner = this.data.length > 0 ? false : true;
    } catch (error) {
        console.error('Error fetching data:', error);
    }
  }

  renderedCallback() {
    if (!this.hasLoadedStyle) {
      this.hasLoadedStyle = true;
      Promise.all([loadStyle(this, overrideCSS)]).then(() => {
        console.log("Styles loaded");
      });
    }
  }

  handleRowAction(event) {
    try {
      let rowId = event.detail.row.Id;
      let actionType = event.detail.row.buttonLabel;
      if (event.detail.action.name === "publish") {
        this.handleButtonClick(this.data, rowId, actionType);
      }
    } catch (error) {
      console.error('Error handling row action:', error);
    }
  }

  async handleButtonClick(data, rowId, actionType) {
    this.showSpinner = true;
    data.forEach((element) => {
      if (rowId === element.Id) {
        if (element.flag === true) {
          console.log('if block');
          element.flag = false;
          element.buttonColor = "brand";
          element.buttonLabel = "Publish";
          element.status = "inactive";
          element.badgeColor = "slds-badge";
        } else {
          console.log('else block');
          element.flag = true;
          element.buttonColor = "destructive";
          element.buttonLabel = "Unpublish";
          element.status = "active";
          element.badgeColor = "slds-badge slds-theme_success";
        }
      }
    });

    console.log("rowId", rowId);
    let response = await createPortalListingRecord({ portalId: rowId, listingId: this.recordId, actionType: actionType });
    console.log("response", response);
    let newList = [...data];
    console.log('newList', newList);
    this.data = newList;
    this.showSpinner = false;
  }
}