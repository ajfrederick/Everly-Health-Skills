import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getWarmAccounts from '@salesforce/apex/EH_AccountTable_Controller.getWarmAccounts';

const COLUMNS = [
    {
        label: 'Name', 
        fieldName: 'accountName',
        type : 'accountName',
        typeAttributes : { 
            accountName : { fieldName: 'accountName' },
            accountUrl : { fieldName: 'accountUrl' },
            title : { fieldName: 'tickerSym' },
        }, 
        hideDefaultActions: true,
    },
    {label: 'SLA', fieldName: 'sla', hideDefaultActions: true},
    {label: 'SLA Experation Date', fieldName: 'slaDate',  type: 'date-local', hideDefaultActions: true},
    {label: 'Rating', fieldName: 'rating', hideDefaultActions: true},
    {label: 'Number of Contacts', fieldName: 'numberOfContacts', hideDefaultActions: true},
]

export default class EhAccountTable extends LightningElement {

    columns = COLUMNS;

    data;

    get isLoading() {
        return this.data === undefined;
    }

    @wire(getWarmAccounts,{})
    wiredResults({data, error}) {
        
        if (data) {
            this.data = data;
        } else 
        if (error) {
            this.showError( error.body );
        }
    }

    showError({message}) {

        this.dispatchEvent(new ShowToastEvent({
            title: "Sorry!",
            message: message,
            variant: "error"
        }));
    }
}