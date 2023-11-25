@isTest
public with sharing class InventoryItemBOTest {

    @isTest
    public static void testWatcherAvailability() {
      List<Inventory_Items__c> testInventories = new List<Inventory_Items__c>();
      Inventory_Items__c testItem = new Inventory_Items__c();
      testItem.Status__c = 'Available';
      testInventories.add(testItem);

      Test.startTest();
      InventoryItemBO.watcherAvailability(testInventories);
      Test.stopTest();
    }

    @isTest
    public static void testHandleDisponibilityItem() {
      Inventory_Items__c testItem = new Inventory_Items__c();
      testItem.Status__c = 'Available';

      Test.startTest();
      Reservation__c result = InventoryItemBO.handleDisponibilityItem(testItem);
      Test.stopTest();
    }
}
