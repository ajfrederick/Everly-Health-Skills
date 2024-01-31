/**
 * @name Controller_AccountStockData
 * @desc UI controller for accountStockData.js
 */
public with sharing class Controller_AccountStockData {

/**
 * PROPS
 */

    private static final String API_VERSION = 'v1';
    private static final String API_METHOD = 'open-close';

    private static String API_PATH {
        get {
            return '/' + API_VERSION + '/' + API_METHOD + '/' + account.TickerSymbol + '/' + marketDate;
        }
    }

    public static Id accountId {get; set;}

    private static Account account {
        get {
            if( account == null ){
                account = getAccount();
            }
            return account;
        } 
        set;
    }

    public static String marketDate {
        get {
            if( marketDate == null ){
                marketDate = JSON.serialize( Date.today() ).replace('"','');
            }
            return marketDate;
        } 
        set;
    }

/**
 * CLASSES
 */

    public class StockData {
        @AuraEnabled
        public Decimal open {get; set;}

        @AuraEnabled
        public Decimal high {get; set;}

        @AuraEnabled
        public Decimal low  {get; set;}

        @AuraEnabled
        public Decimal close {get; set;}
    }

/**
 * LWC METHODS
 */

    @AuraEnabled(cacheable=true)
    public static StockData getStockData( Id accId, String mDate ){

        accountId = accId;
        marketDate = mDate;

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:Polygon_Stock_API' + API_PATH );

        Http http = new Http();

        StockData stockData;

        try {

            HTTPResponse res = http.send(req);

            stockData = (StockData) JSON.deserialize( res.getBody(), StockData.class );
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return stockData;
    }

/**
 * QUERY METHODS
 */

    private static Account getAccount(){
        return [
            SELECT
                Id,
                TickerSymbol
            FROM
                Account
            WHERE Id = :accountId
        ];
    }
}