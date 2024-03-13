//myCustomTypeDatatable.js
import LightningDatatable from "lightning/datatable";
import customNameTemplate from "./customName.html";

export default class MyCustomTypeDatatable extends LightningDatatable {
  static customTypes = {
    customName: {
      template: customNameTemplate,
      standardCellLayout: true,
      typeAttributes: ["status", "class"]
    }
  };
}