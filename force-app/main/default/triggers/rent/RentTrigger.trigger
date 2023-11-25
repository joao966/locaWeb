trigger RentTrigger on Rent__c (before insert, before update, before delete, after insert, after update, after delete) {
  new RentHandler().run();
}
