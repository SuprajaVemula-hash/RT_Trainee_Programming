/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OpportunityTriggerHandlerTest {

    

  @isTest
  static void deleteOpportunityWithAccount() {
    Account acc = new Account(Name = 'Test',AllOpportunityAmount__c=0);
    insert acc;
    Opportunity opp1 = new Opportunity(
      Name = 'Test1',
      Amount = 2000,
      StageName = 'Closed Won',
      CloseDate = Date.today(),
      AccountId = acc.Id
    );
    Opportunity opp2 = new Opportunity(
      Name = 'Test2',
      Amount = 3000,
      StageName = 'Closed Won',
      CloseDate = Date.today(),
      AccountId = acc.Id
    );
    insert new List<Opportunity>{ opp1, opp2 };
    acc.AllOpportunityAmount__c=5000;
    update acc;
    Test.StartTest();
    /*Account newacc = [
      SELECT Id, AllOpportunityAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      5000,
      newacc.AllOpportunityAmount__c,
      'opportunities amount should be added in account'
    );*/
    //After deleting one Opportunity
    delete opp2;
    Account newacc = [

      SELECT Id, AllOpportunityAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      2000,
      newacc.AllOpportunityAmount__c,
      'opportunities amount should be deleted in account'
    );
    undelete opp2;
    newacc = [
      SELECT Id, AllOpportunityAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      5000,
      newacc.AllOpportunityAmount__c,
      'opportunities should be readded in to the account'
    );
    Test.StopTest();
  }

  @isTest
  static void deleteOppoAccount() {
    Account acc = new Account(Name = 'Test',AllOpportunityAmount__c=0);
    insert acc;
    Opportunity opp1 = new Opportunity(
      Name = 'Test1',
      Amount = 0,
      StageName = 'Closed Won',
      CloseDate = Date.today(),
      AccountId = acc.Id
    );
    Opportunity opp2 = new Opportunity(
      Name = 'Test2',
      Amount = 3000,
      StageName = 'Closed Won',
      CloseDate = Date.today(),
      AccountId = acc.Id
    );
    insert new List<Opportunity>{ opp1, opp2 };
    acc.AllOpportunityAmount__c=3000;
    update acc;
    Test.StartTest();
    /*Account newacc = [
      SELECT Id, AllOpportunityAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      5000,
      newacc.AllOpportunityAmount__c,
      'opportunities amount should be added in account'
    );*/
    //After deleting one Opportunity
    delete opp1;
     Account newacc = [
      SELECT Id, AllOpportunityAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      3000,
      newacc.AllOpportunityAmount__c,
      'opportunities amount should be deleted in account'
    );
    undelete opp1;
    newacc = [
      SELECT Id, AllOpportunityAmount__c
      FROM Account
      WHERE Id = :acc.Id
    ];
    System.assertEquals(
      3000,
      newacc.AllOpportunityAmount__c,
      'opportunities should be readded in to the account'
    );
    Test.StopTest();
  }
}
