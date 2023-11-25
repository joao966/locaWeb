public with sharing class InventoryItemHandler extends TriggerHandler  {
  public override void beforeUpdate(){
    InventoryItemBO.watcherAvailability(Trigger.new);
  }
}
