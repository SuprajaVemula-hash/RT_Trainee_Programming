public class OpportunityTriggerHandler {
    public void afterDeleteOpportunity(List<Opportunity> opList) {
    afterdeleteandUndeleteOpportunity(opList,true);
       /* // Creating a map to accumulate total opportunity amounts for each account
        Map<Id, Decimal> accIdToTotalOppAmountMap = new Map<Id, Decimal>();
    
        
        //iterating over the opportunitys for mapping rthe account totals
        for (Opportunity opp : opList) {
            if (opp.AccountId != null && opp.Amount != null) {
                if (!accIdToTotalOppAmountMap.containsKey(opp.AccountId)) {
                    accIdToTotalOppAmountMap.put(opp.AccountId, 0);
                }
                accIdToTotalOppAmountMap.put(
                    opp.AccountId, 
                    accIdToTotalOppAmountMap.get(opp.AccountId) + opp.Amount
                );
            }
        }
    
        
        // querying the accounts and updating thier AllOpportunitymount__c fields
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accIdToTotalOppAmountMap.keySet()) {
            Account acc = [SELECT Id, AllOpportunityAmount__c FROM Account WHERE Id = :accId];
            acc.AllOpportunityAmount__c -= accIdToTotalOppAmountMap.get(accId);
            accountsToUpdate.add(acc);
        }
    
        // bulk updates for the accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }*/
    }
    public void afterUndeleteOpportunity(List<Opportunity> opList) {
    afterdeleteandUndeleteOpportunity(opList,false);
       /* // Creating a map to accumulate total opportunity amounts for each account
        Map<Id, Decimal> accIdToTotalOppAmountMap = new Map<Id, Decimal>();
    
        // Iterating over the opportunities to map the account totals
        for (Opportunity opp : opList) {
            if (opp.AccountId != null && opp.Amount != null) {
                if (!accIdToTotalOppAmountMap.containsKey(opp.AccountId)) {
                    accIdToTotalOppAmountMap.put(opp.AccountId, 0);
                }
                accIdToTotalOppAmountMap.put(
                    opp.AccountId, 
                    accIdToTotalOppAmountMap.get(opp.AccountId) + opp.Amount
                );
            }
        }
    
        // Querying the relevant accounts and updating their AllOpportunityAmount__c fields
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accIdToTotalOppAmountMap.keySet()) {
            Account acc = [SELECT Id, AllOpportunityAmount__c FROM Account WHERE Id = :accId];

            acc.AllOpportunityAmount__c += accIdToTotalOppAmountMap.get(accId);
            accountsToUpdate.add(acc);
        }
    
        // bulk update of the accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }*/
    }
    
//generic method

    public void afterdeleteandUndeleteOpportunity(List<Opportunity> opList , Boolean isDelete) {
    // Creating a map to accumulate total opportunity amounts for each account
    Map<Id, Decimal> accIdToTotalOppAmountMap = new Map<Id, Decimal>();

    // Iterating over the opportunities to map the account totals
    for (Opportunity opp : opList) {
        if (opp.AccountId != null && opp.Amount != null) {
            if (!accIdToTotalOppAmountMap.containsKey(opp.AccountId)) {
                accIdToTotalOppAmountMap.put(opp.AccountId, 0);
            }
            accIdToTotalOppAmountMap.put(
                opp.AccountId, 
                accIdToTotalOppAmountMap.get(opp.AccountId) + opp.Amount
            );
        }
    }

    // Querying the relevant accounts and updating their AllOpportunityAmount__c fields
    List<Account> accountsToUpdate = new List<Account>();
    for (Id accId : accIdToTotalOppAmountMap.keySet()) {
        Account acc = [SELECT Id, AllOpportunityAmount__c FROM Account WHERE Id = :accId];
        if(isDelete){
            
            acc.AllOpportunityAmount__c -= accIdToTotalOppAmountMap.get(accId);

        }else{
            acc.AllOpportunityAmount__c += accIdToTotalOppAmountMap.get(accId);
        }
    
        

        
        accountsToUpdate.add(acc);
    }

    // Performing a bulk update of the accounts
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
  }
    
}






