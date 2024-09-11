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
private class LeadContactFieldsMatchTest {

    @testSetup
    static void setupData() {
        // Create test Leads
        Lead lead1 = new Lead(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', Phone = '1234567890', Company = 'Test Company');
        Lead lead2 = new Lead(FirstName = 'Jane', LastName = 'Doe', Email = 'jane.doe@example.com', Phone = '0987654321', Company = 'Test Company');
        Lead lead3 = new Lead(FirstName = 'Alice', LastName = 'Smith', Email = 'alice.smith@example.com', Phone = '1111111111', Company = 'Test Company');
        insert new List<Lead>{lead1, lead2, lead3};

        // Create test Contacts
        Contact contact1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', Phone = '1234567890');
        Contact contact2 = new Contact(FirstName = 'Jane', LastName = 'Doe', Email = 'jane.doe@example.com', Phone = '0987654321');
        Contact contact3 = new Contact(FirstName = 'Alice', LastName = 'Smith', Email = 'alice.smith@example.com', Phone = '1111111111');
        Contact contact4 = new Contact(FirstName = 'John', LastName = 'Smith', Email = 'john.smith@example.com', Phone = '2222222222');
        insert new List<Contact>{contact1, contact2, contact3, contact4};
    }

    @isTest
    static void testTwoMatches_FirstNameLastNameAndEmail() {
        Test.startTest();
        // Execute the batch
        LeadContactFieldsMatch batch = new LeadContactFieldsMatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that lead1 is matched with contact1 (FirstName + LastName equals AND Email equals)
        Map<Id, Contact> resultMap = batch.getLeadToContactMap();
        System.assertEquals(1, resultMap.size(), 'Expected one match');
        System.assertEquals('john.doe@example.com', resultMap.get([SELECT Id FROM Lead WHERE FirstName = 'John' AND LastName = 'Doe' LIMIT 1].Id).Email, 'Expected contact1 to be matched with lead1');
    }

    @isTest
    static void testTwoMatches_FirstNameLastNameAndPhone() {
        Test.startTest();
        // Execute the batch
        LeadContactFieldsMatch batch = new LeadContactFieldsMatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that lead2 is matched with contact2 (FirstName + LastName equals AND Phone equals)
        Map<Id, Contact> resultMap = batch.getLeadToContactMap();
        System.assertEquals(1, resultMap.size(), 'Expected one match');
        System.assertEquals('jane.doe@example.com', resultMap.get([SELECT Id FROM Lead WHERE FirstName = 'Jane' AND LastName = 'Doe' LIMIT 1].Id).Email, 'Expected contact2 to be matched with lead2');
    }

    @isTest
    static void testThreeMatches_AllFieldsMatch() {
        Test.startTest();
        // Execute the batch
        LeadContactFieldsMatch batch = new LeadContactFieldsMatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that lead3 is matched with contact3 (All fields match)
        Map<Id, Contact> resultMap = batch.getLeadToContactMap();
        System.assertEquals(1, resultMap.size(), 'Expected one match');
        System.assertEquals('alice.smith@example.com', resultMap.get([SELECT Id FROM Lead WHERE FirstName = 'Alice' AND LastName = 'Smith' LIMIT 1].Id).Email, 'Expected contact3 to be matched with lead3');
    }

    @isTest
    static void testNoMatches() {
        Test.startTest();
        // Execute the batch
        LeadContactFieldsMatch batch = new LeadContactFieldsMatchh();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that lead4 does not match any contacts (no matching criteria)
        Map<Id, Contact> resultMap = batch.getLeadToContactMap();
        System.assertEquals(0, resultMap.size(), 'Expected no matches');
    }

    @isTest
    static void testOneMatch_Ignored() {
        Test.startTest();
        // Create a lead that has only one matching field with a contact
        Lead lead4 = new Lead(FirstName = 'John', LastName = 'Smith', Email = 'unmatched@example.com', Phone = '3333333333', Company = 'Test Company');
        insert lead4;

        // Execute the batch
        LeadContactFieldsMatch batch = new LeadContactFieldsMatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that the lead with only one match is ignored
        Map<Id, Contact> resultMap = batch.getLeadToContactMap();
        System.assertEquals(0, resultMap.size(), 'Expected no matches since only one field matches');
    }
}