public class EH_AccountTable_Controller {

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
        WHERE Rating = 'Warm'];
    }
}