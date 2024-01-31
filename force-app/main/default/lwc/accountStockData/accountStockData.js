import { LightningElement, api, wire } from 'lwc';

import getStockData from '@salesforce/apex/Controller_AccountStockData.getStockData';

export default class AccountStockData extends LightningElement {

    @api recordId;

    marketDate = new Date().toISOString().split('T')[0];

    stockData;

    noData = false;

    @wire( getStockData, { accId : '$recordId', mDate : '$marketDate' } )
    wiredStockDate({data, error}){

        if( data ){

            if( !Object.keys(data).length ){
                this.stockData = this.getDefaulStockData();
                this.noData = true;
            } else {
                this.stockData = data;
                this.noData = false;
            }

        } else
        if( error ){
            console.error(error);
        }
    }

    connectedCallback(){
        this.stockData = this.getDefaulStockData();
    }
    
    handleDateChange( event ){
        this.marketDate = event.currentTarget.value;
    }

    getDefaulStockData(){
        return {
            open : '',
            high : '',
            low : '',
            close : '',
        };
    }
}