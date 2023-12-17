/**
 * @name EH_AccountTable_Controller
 * @desc UI controller for lwc ehAccountTable
 * 
 * @author Andrew Frederick and Unknown
 */
public class EH_AccountTable_Controller {

/**
 * INNER CLASSES
 */

    /**
     * @name Row
     * @desc class to format data for lwc datatable
     */
    private class Row {

        @AuraEnabled
        public String accountId {get; set;}

        @AuraEnabled
        public String accountName {get; set;}

        @AuraEnabled
        public String tickerSym {get; set;}

        @AuraEnabled
        public String sla {get; set;}

        @AuraEnabled
        public Date slaDate {get; set;}

        @AuraEnabled
        public String rating {get; set;}

        @AuraEnabled
        public Integer numberOfContacts {get; set;}

        @AuraEnabled
        public String accountUrl {get; set;}

        Row( Account account ) {
            this.accountId = String.valueOf(account.Id);
            this.accountName = account.Name;
            this.tickerSym = account.TickerSymbol;
            this.sla = account.SLA__c;
            this.slaDate = account.SLAExpirationDate__c;
            this.rating = account.Rating;
            this.numberOfContacts = account.Contacts.size();
            this.accountUrl = '/' + this.accountId;
        }
    }
    
/**
 * LWC METHODS
 */

    /**
     * @name getWarmAccounts
     * @desc returns accounts with a rating of 'warm' to lwc
     * 
     * @return formatted data rows for data table
     */
    @AuraEnabled(cacheable=true)
    public static List<Row> getWarmAccounts(){

        List<Row> rows = new List<Row>();

        try {
    
            for (Account a : getAccounts()) {
                rows.add(new Row(a));
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return rows;
    }

/**
 * QUERY METHODS
 */

    private static List<Account> getAccounts() {
        return [
            SELECT 
                Id, 
                Name, 
                TickerSymbol, 
                SLA__c, 
                SLAExpirationDate__c, 
                Rating,
                (SELECT Id FROM Contacts)
            FROM Account 
            WHERE Rating = 'Warm'
            ORDER BY Name asc];
    }
}