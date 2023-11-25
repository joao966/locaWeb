public with sharing class InventoryDAO {
  public static List<Inventory__c> getByIds(Set<Id> ids) {
    return [SELECT Id, inventory_status__c, Name FROM Inventory__c WHERE Id = : ids];
  }
}
