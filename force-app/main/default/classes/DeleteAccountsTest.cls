@isTest
private class DeleteAccountsTest {
    @TestSetup
    static void DeleteAccountNames(){
        
        Account acc1 = new Account(Name = ' Name1');
        Account acc2 = new Account(Name = 'Name2');    
        insert new List<Account>{acc1, acc2};
        Account acc3 = new Account(Name = 'Name3');
        Account acc4 = new Account(Name = 'Name3');
        insert new List<Account>{acc3, acc4};
        Account acc5 = new Account(Name = 'Name4');
        Account acc6 = new Account(Name = 'Name4');
        Account acc7 = new Account(Name = 'Name4');
        insert new List<Account>{acc5,acc6,acc7};
        Account acc8 = new Account(Name = 'Name5');
        Account acc9 = new Account(Name = 'Name5');
        Account acc10 = new Account(Name = 'Name5');
        Account acc11 = new Account(Name ='Name5');
        Account acc12 = new Account(Name = 'Name5');
        insert new List<Account>{acc8,acc9,acc10,acc11,acc12};
        
    }


    @IsTest
    static void TestBatchForDuplicates(){
        Test.startTest();
        DeleteAccounts batchs = new DeleteAccounts();
        Database.executeBatch(batchs, 200);
        Test.stopTest();

        
        Integer uniqueCount = [SELECT COUNT() FROM Account WHERE Name = 'Name1' OR Name = 'Name2'];
        System.assertEquals(2, uniqueCount);

        Integer multipleDuplicateCount = [SELECT COUNT() FROM Account WHERE Name = 'Name4'];
        System.assertEquals(1, multipleDuplicateCount);


    }

    
}