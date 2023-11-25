public with sharing class ReservationHandler extends TriggerHandler {

  public override void beforeInsert(){
    ReservationBO.validateStatusInventory(Trigger.new);
    ReservationBO.validateStatusContact(Trigger.new);
    ReservationBO.sendEmail(Trigger.new);
  }
}
  