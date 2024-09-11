public  class AccountTriggerHandler {
    
    public void afterupdate(List<Account> newlist, Map<Id,Account> oldMap){
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc: newlist){
            if(acc.Status__c <> oldMap.get(acc.Id).Status__c){
                accMap.put(acc.Id, acc);
            }
        }
        List<Contact> contacts=[SELECT Id,Status__c,AccountId FROM Contact WHERE AccountId IN :accMap.keySet()];
        List<Contact> contactstoupdate = new List<Contact>();
        for(Contact c: contacts){
            if(accMap.containsKey(c.AccountId)){
                Account a=accMap.get(c.AccountId);
                c.Status__c=a.Status__c;
                contactstoupdate.add(c);
            }
            if(!contactstoupdate.isEmpty()){
                System.debug(' updating contacts,' + contactstoupdate);
                update contactstoupdate;

            }
        }
    }

    public void beforeinsert(List<Contact> newlist){
        set<Id> accId=new set<Id>();
        for(Contact con: newList){
            
            if(con.AccountId <>null){
                
                accId.add(con.AccountId);
            }
        }
        List<Account> accList=[SELECT Id,Status__c from Account WHERE Id IN :accId and Status__c =True];
        for(Contact c: newList){
            for(Account acc: accList){
                if(c.AccountId==acc.Id){
                    c.Status__c=acc.Status__c;
                }
            }
        }
    
    }

    //for before update

    public void beforeupdate(List<Contact> newlist, Map<Id,Contact> oldMap){

        Set<Id> accIds = new Set<Id>();

        for(Contact con: newlist){
            if(con.Status__c <> oldMap.get(con.Id).Status__c && con.AccountId <> null) {
                accIds.add(con.AccountId);
            }
        }

        List<Account> accList=[SELECT Id,Status__c From Account WHERE Id IN :accIds];
        Map<Id,Account> accMap= new Map<Id,Account>(accList);
        system.debug('>>>' + accMap);
        for(Contact c : newList){
            if(accMap.containskey(c.AccountId)){
            Account a=accMap.get(c.AccountId);
            c.Status__c=a.Status__c;
            system.debug(c.Status__c);
            }
            
    
        }
        

    }
}