import LightningDatatable from "lightning/datatable";
import accountName from "./accountName.html";

export default class AccountsDataTable extends LightningDatatable {
    
    static customTypes = {
        accountName: {
            template: accountName,
            typeAttributes: ["accountName", "accountUrl", "title"],
            standardCellLayout: true,
        }
    };
}