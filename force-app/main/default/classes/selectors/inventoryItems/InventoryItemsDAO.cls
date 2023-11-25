public with sharing class InventoryItemsDAO {
  public static List<Inventory_Items__c> getByIds(Set<Id> ids) {
    System.debug('ids: '+ ids);
    return [SELECT Id, Status__c FROM Inventory_Items__c WHERE Id = : ids];
  }
}
