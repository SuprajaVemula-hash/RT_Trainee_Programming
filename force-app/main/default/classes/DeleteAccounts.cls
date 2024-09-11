/*public with sharing class DeleteAccounts implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,Name,CreatedDate FROM Account ORDER BY CreatedDate ASC');
    }
    public void execute(Database.BatchableContext bc,List<Account> scope){
        Map<String, List<Account>> accMap = new Map<String, List<Account>>();
        List<Account> deleteAccounts = new List<Account>();

        for (Account acc : scope) {
            if (!accMap.containsKey(acc.Name)) {
                accMap.put(acc.Name, new List<Account>());
            }
            accMap.get(acc.Name).add(acc);
        } 
          
        
        for (String accountName : accMap.keySet()) {
            List<Account> duplicateAccounts = accMap.get(accountName);
        
            
            if (duplicateAccounts.size() > 1) {
    
                Account oldestAccount = duplicateAccounts[0]; 
        
                for (Account acc : duplicateAccounts) {
                    if (acc.CreatedDate < oldestAccount.CreatedDate) {
                        oldestAccount = acc; 
                    }
                }
        
                
                for (Account acc : duplicateAccounts) {
                    if (acc.Id != oldestAccount.Id) {
                        deleteAccounts.add(acc); 
                    }
                }
            }
        }
        

            
                
                

        
        /*
        for (Account acc: scope){
            if(!accMap.containsKey(acc.Name)){
                accMap.put(acc.Name, new List<Account>() );
                
            }
            accMap.get(acc.Name).add(acc);


        }
        List<Account> DeleteAccounts = new List<Account>();
        for (String accountName: accMap.keySet()){
            List<Account> dupliaccounts=accMap.get(accountname);
            if(dupliaccounts.size()>1){
                Account latest=dupliaccounts[0];
                DeleteAccounts.add(latest);
            }
        }
       // 
        
        if (!DeleteAccounts.isEmpty()){
            
            delete DeleteAccounts;
        }

    


        
    }
    public void finish(Database.BatchableContext bc ){
        system.debug('Accounts which are more than one are deleted!!');
    }
}






public with sharing class DeleteAccounts implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name, CreatedDate FROM Account ORDER BY CreatedDate ASC');
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Map<String, List<Account>> accMap = new Map<String, List<Account>>();
        List<Account> deleteAccounts = new List<Account>();

        
        for (Account acc : scope) {
            if (!accMap.containsKey(acc.Name)) {
                accMap.put(acc.Name, new List<Account>());
            }
            accMap.get(acc.Name).add(acc);
        }

        
        for (String accountName : accMap.keySet()) {
            List<Account> duplicateAccounts = accMap.get(accountName);

            
            if (duplicateAccounts.size() > 1) {
                
                Account oldestAccount = duplicateAccounts[0]; 

                for (Account acc : duplicateAccounts) {
                    if (acc.CreatedDate < oldestAccount.CreatedDate) {
                        oldestAccount = acc; 
                    }
                }

                
                for (Account acc : duplicateAccounts) {
                    if (acc.Id != oldestAccount.Id) {
                        deleteAccounts.add(acc); 
                    }
                }
            }
        }

        
        if (!deleteAccounts.isEmpty()) {
            delete deleteAccounts;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Duplicate accounts have been deleted, retaining only the oldest.');
    }
}



//
public with sharing class DeleteAccounts implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name, CreatedDate FROM Account ORDER BY CreatedDate ASC');
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Map<String, List<Account>> accMap = new Map<String, List<Account>>();
        List<Account> deleteAccounts = new List<Account>();

        for (Account acc : scope) {
            if (!accMap.containsKey(acc.Name)) {
                accMap.put(acc.Name, new List<Account>());
            }
            accMap.get(acc.Name).add(acc);
        }

      
        for (String accountName : accMap.keySet()) {
            List<Account> duplicateAccounts = accMap.get(accountName);

            
            if (duplicateAccounts.size() > 1) {
                Account oldestAccount = null;

                
                for (Account acc : duplicateAccounts) {
                    if (oldestAccount == null || acc.CreatedDate < oldestAccount.CreatedDate) {
                        oldestAccount = acc; 
                    }
                }

               
                for (Account acc : duplicateAccounts) {
                    if (acc.Id != oldestAccount.Id) {
                        deleteAccounts.add(acc); 
                    }
                }
            }
        }

      
        if (!deleteAccounts.isEmpty()) {
            delete deleteAccounts;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Duplicate accounts have been deleted, retaining only the oldest.');
    }
}


//
public without sharing class DeleteAccounts implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
      return Database.getQueryLocator(
        'Select Id,Name from Account Order by CreatedDate'
      );
    }
    public void execute(Database.BatchableContext bc, List<Account> scope) {
      List<Account> accounts = new List<Account>();
      Map<String, List<Account>> accMap = new Map<String, List<Account>>();
      for (Account account : scope) {
        if (!accMap.containsKey(account.Name)) {
            accMap.put(account.Name, new List<Account>{});
        }else if(accMap.containsKey(account.Name)){
        accMap.get(account.Name).add(account);
      }
      for (List<Account> accList : accMap.values()) {
        accounts.addAll(accList);
      }
      delete accounts;
    }
   
  }
  public void finish (Database.BatchableContext bc) {
    System.debug(1);
  
}




//
public without sharing class DeleteAccounts implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name FROM Account ORDER BY CreatedDate'
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<String> uniqueNames = new Set<String>();
        List<Account> accountsToDelete = new List<Account>();

        for (Account account : scope) {
            // Check if the account name is already processed
            if (uniqueNames.contains(account.Name)) {
                // If it's a duplicate, add it to the deletion list
                accountsToDelete.add(account);
            } else {
                // If not, add the name to the set
                uniqueNames.add(account.Name);
            }
        }

        // Delete all duplicate accounts
        if (!accountsToDelete.isEmpty()) {
            delete accountsToDelete;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch process completed successfully.');
    }
}





//
public without sharing class DeleteAccounts implements Database.Batchable<sObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, CreatedDate FROM Account ORDER BY Name, CreatedDate ASC'
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<String> processedNames = new Set<String>();
        List<Account> accountsToDelete = new List<Account>();

        try {
            for (Account account : scope) {
                
                if (processedNames.contains(account.Name)) {
                    
                    accountsToDelete.add(account);
                } else {
                    
                    processedNames.add(account.Name);
                }
            }

            
            if (!accountsToDelete.isEmpty()) {
                delete accountsToDelete;
            }
        } catch (DmlException dmlex) {
            System.debug('DML Exception: ' + dmlex.getMessage());
        } catch (Exception ex) {
            System.debug('General Exception: ' + ex.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc) {
        try {
            System.debug('Batch process completed successfully.');
        } catch (Exception ex) {
            System.debug('Exception in finish method: ' + ex.getMessage());
        }
    }
}
*/
public without sharing class DeleteAccounts implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, CreatedDate FROM Account ORDER BY Name, CreatedDate ASC'
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<String> processedNames = new Set<String>();
        List<Account> accountsToDelete = new List<Account>();

        try {
            for (Account account : scope) {
                // Check if the account name has already been processed
                if (processedNames.contains(account.Name)) {
                    // If it's a duplicate, add it to the deletion list
                    accountsToDelete.add(account);
                } else {
                    // If it's the first time seeing this name, add it to the set
                    processedNames.add(account.Name);
                }
            }

            // Delete all duplicate accounts (newer records)
            if (!accountsToDelete.isEmpty()) {
                Database.DeleteResult[] results = Database.delete(accountsToDelete, false);
                
                for (Database.DeleteResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            // Log the error details to a custom EventLog__c object
                            Event_Log__c log = new Event_Log__c(
                                Batch_Id__c = result.getId(),
                                ErrorMessage__c = error.getMessage(),
                                Status__c   = 'Failed',
                                BusinessDescription__c = 'Failed to delete duplicate Account with Id: ' + 
                                                          result.getId() + 
                                                          '. Error: ' + error.getMessage()
                            );
                            insert log;
                        }
                    }
                }
            }
        } catch (Exception ex) {
            // Log the exception to a custom EventLog__c object
            for (Account acc : accountsToDelete) {
                Event_Log__c log = new Event_Log__c(
                    Batch_Id__c = acc.Id,
                    ErrorMessage__c = ex.getMessage(),
                    Status__c = 'Failed',
                    BusinessDescription__c = 'Exception occurred while processing Account with Id: ' + 
                                             acc.Id + 
                                             '. Error: ' + ex.getMessage()
                );
                insert log;
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        try {
            System.debug('Batch process completed.');
        } catch (Exception ex) {
            System.debug('Exception in finish method: ' + ex.getMessage());
            // Log the exception in the finish method
            Event_Log__c log = new Event_Log__c(
                Batch_Id__c = null,
                ErrorMessage__c = ex.getMessage(),
                Status__c = 'Failed in Finish',
                BusinessDescription__c = 'Exception occurred in finish method. Error: ' + ex.getMessage()
            );
            insert log;
        }
    }
}









/*


public static void schedulableJob(){
    DeleteAccounts job = new DeleteAccounts();
    String cronExp = '0 0 23 * * ?';
    String jobId = System.schedule('Delete duplicate Accounts', cronExp, job);

String cronExp = '0 0 23 * * ?';
System.schedule('Daily Apex Batch', cronExp, new DeleteAccounts());
}


String cronExp ='0 20 0 * * ? *';
String jonName = 'QueryAccountsLog';
system.schedule(jobName,cronExp,new QueryAccounts());

*/






































































































































































































































































































































































































































      
















































































































































































































































































