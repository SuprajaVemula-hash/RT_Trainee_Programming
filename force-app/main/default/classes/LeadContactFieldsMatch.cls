public with sharing class LeadContactFieldsMatch implements Database.Batchable<sObject> {

    public Map<Id, Contact> leadToContactMap = new Map<Id, Contact>();
    public Map<Id, Lead> leadsMap = new Map<Id, Lead>(); // Declare leadsMap here

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, FirstName, LastName, Email, Phone 
            FROM Lead
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> leadList) {
        // Maps to store potential match values for quick lookups
        Map<String, List<Id>> firstNameMap = new Map<String, List<Id>>();
        Map<String, List<Id>> lastNameMap = new Map<String, List<Id>>();
        Map<String, List<Id>> emailMap = new Map<String, List<Id>>();
        Map<String, List<Id>> phoneMap = new Map<String, List<Id>>();
        Map<Id, Integer> leadMatchCountMap = new Map<Id, Integer>();

        // Populate the maps with lead data
        for (Lead lead : leadList) {
            leadsMap.put(lead.Id, lead); // Populate leadsMap with lead data

            if (lead.FirstName != null) {
                if (!firstNameMap.containsKey(lead.FirstName)) {
                    firstNameMap.put(lead.FirstName, new List<Id>());
                }
                firstNameMap.get(lead.FirstName).add(lead.Id);
            }
            if (lead.LastName != null) {
                if (!lastNameMap.containsKey(lead.LastName)) {
                    lastNameMap.put(lead.LastName, new List<Id>());
                }
                lastNameMap.get(lead.LastName).add(lead.Id);
            }
            if (lead.Email != null) {
                if (!emailMap.containsKey(lead.Email)) {
                    emailMap.put(lead.Email, new List<Id>());
                }
                emailMap.get(lead.Email).add(lead.Id);
            }
            if (lead.Phone != null) {
                if (!phoneMap.containsKey(lead.Phone)) {
                    phoneMap.put(lead.Phone, new List<Id>());
                }
                phoneMap.get(lead.Phone).add(lead.Id);
            }

            // Initialize the match count to 0 for each lead
            leadMatchCountMap.put(lead.Id, 0);
        }

        // Query contacts matching any lead data
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE FirstName IN :firstNameMap.keySet()
            OR LastName IN :lastNameMap.keySet()
            OR Email IN :emailMap.keySet()
            OR Phone IN :phoneMap.keySet()
        ];

        // Update match counts for each contact based on criteria
        for (Contact contact : contacts) {
            // Use sets to keep track of which leads have been matched
            Set<Id> matchedLeads = new Set<Id>();

            if (contact.FirstName != null && firstNameMap.containsKey(contact.FirstName)) {
                matchedLeads.addAll(firstNameMap.get(contact.FirstName));
            }
            if (contact.LastName != null && lastNameMap.containsKey(contact.LastName)) {
                matchedLeads.addAll(lastNameMap.get(contact.LastName));
            }
            if (contact.Email != null && emailMap.containsKey(contact.Email)) {
                matchedLeads.addAll(emailMap.get(contact.Email));
            }
            if (contact.Phone != null && phoneMap.containsKey(contact.Phone)) {
                matchedLeads.addAll(phoneMap.get(contact.Phone));
            }

            // Update match count for each lead that was matched
            for (Id leadId : matchedLeads) {
                Integer matchCount = leadMatchCountMap.get(leadId);

                if (contact.FirstName == leadsMap.get(leadId).FirstName && 
                    contact.LastName == leadsMap.get(leadId).LastName) {
                    matchCount++;
                }
                if (contact.Email == leadsMap.get(leadId).Email) {
                    matchCount++;
                }
                if (contact.Phone == leadsMap.get(leadId).Phone) {
                    matchCount++;
                }

                // Only store the contact if there are at least 2 matches
                if (matchCount >= 2) {
                    leadMatchCountMap.put(leadId, matchCount);

                    // Store the contact if it has more matches than any previous contact
                    if (!leadToContactMap.containsKey(leadId) || 
                        matchCount > leadMatchCountMap.get(leadId)) {
                        leadToContactMap.put(leadId, contact);
                    }
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Lead to Contact Matches: ' + leadToContactMap);
    }

    public Map<Id, Contact> getLeadToContactMap() {
        return leadToContactMap;
    }
}
/*
public class LeadContactFieldsMatch implements Database.Batchable<sObject> {
    public Map<Id, List<Contact>> leadToContactsMap = new Map<Id, List<Contact>>();
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, Email, Phone FROM Lead]);
    }
    public void execute(Database.BatchableContext bc, List<Lead> leadList) {
        Map<String, List<Contact>> nameToContactsMap = new Map<String, List<Contact>>();
        Set<String> matchedFields = new Set<String>();
        for (Lead lead : leadList) {
        if (lead.Email != null && lead.Name!=null && lead.Phone!=null) {
                    matchedFields.add(lead.Email);
                    matchedFields.add(lead.Name);
                    matchedFields.add(lead.Phone);
                }
            }
        List<Contact> contacts = [
            SELECT Id, Name, Email, Phone
            FROM Contact
            WHERE Id in :matchedFields
        ];
        for (Contact contact : contacts) {
            if (!nameToContactsMap.containsKey(contact.Name)&&
            (!nameToContactsMap.containsKey(contact.Phone))
            &&(!nameToContactsMap.containsKey(contact.Email))) {
                nameToContactsMap.put(contact.Name, new List<Contact>());
                nameToContactsMap.put(contact.Email, new List<Contact>());
                nameToContactsMap.put(contact.Phone, new List<Contact>());
            }
            nameToContactsMap.get(contact.Name).add(contact);
            nameToContactsMap.get(contact.Email).add(contact);
            nameToContactsMap.get(contact.Phone).add(contact);
        }
      for (Lead lead : leadList) {
            List<Contact> matchedContacts = new List<Contact>();
            Integer matchCount = 0;
            if (nameToContactsMap.containsKey(lead.Email)&&nameToContactsMap.containsKey(lead.name)
            &&nameToContactsMap.containsKey(lead.Phone)) {
                matchCount++;
                matchedContacts.addAll(nameToContactsMap.get(lead.Email));
                matchedContacts.addAll(nameToContactsMap.get(lead.Phone));
                matchedContacts.addAll(nameToContactsMap.get(lead.Name));
            }
           if (matchCount >= 2) {
                leadToContactsMap.put(lead.Id, matchedContacts);
            }
        }
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('Lead to Contacts Map: ' + leadToContactsMap);
    }
    public Map<Id, List<Contact>> getLeadToContactsMap() {
        return leadToContactsMap;
    }
}
    */