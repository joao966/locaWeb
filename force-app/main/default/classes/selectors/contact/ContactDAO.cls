public with sharing class ContactDAO {
  public static List<Contact> getByIds(Set<Id> ids) {
    System.debug('ids contacts: '+ ids);
    return [SELECT Id, contact_status__c, Email, Name FROM Contact WHERE Id = : ids];
  }
}