public with sharing class RentHandler extends TriggerHandler {
  public override void beforeInsert(){
    RentBO.validateCloseDate(Trigger.new);
    RentBO.validateStatusItem(Trigger.new);
    RentBO.validateStatusContact(Trigger.new);
    RentBO.setCurrentDateOnlocation(Trigger.new);
  }

  public override void afterInsert(){
    RentBO.updateItemToRented(Trigger.new);
  }

  public override void afterUpdate(){ 
    RentBO.updateStatusItem(Trigger.new);
    RentBO.updateStatusContact(Trigger.old);
  }
}
