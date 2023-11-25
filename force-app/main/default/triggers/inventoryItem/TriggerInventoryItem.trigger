trigger TriggerInventoryItem on Inventory_Items__c (before insert, before update, before delete, after insert, after update, after delete) {
  new InventoryItemHandler().run();
}
