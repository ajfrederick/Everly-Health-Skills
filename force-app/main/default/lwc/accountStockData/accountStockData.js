import { LightningElement, api, wire } from 'lwc';

import getStockData from '@salesforce/apex/Controller_AccountStockData.getStockData';

export default class AccountStockData extends LightningElement {

    @api recordId;

    marketDate = new Date().toISOString().split('T')[0];

    stockData = {
        open : '',
        high : '',
        low : '',
        close : '',
    };

    @wire( getStockData, { accId : '$recordId', mDate : '$marketDate' } )
    wiredStockDate({data, error}){

        if( data ){
            this.stockData = data;
        } else
        if( error ){
            console.error(error);
        }
    }

    handleDateChange( event ){
        this.marketDate = event.currentTarget.value;
    }
}