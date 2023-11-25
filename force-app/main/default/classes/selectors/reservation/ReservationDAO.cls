public with sharing class ReservationDAO {
  public static List<Reservation__c> getByInventoryId(Id inventoryId) {
    return [
      SELECT
        Id,
        Contact__c,
        Inventory__c,
        Inventory_Items__c,
        Status__c,
        Initial_Reserva__c
      FROM Reservation__c
      WHERE Inventory__c = :inventoryId
      AND Status__c = 'await item'
    ];
  }

  public static List<Reservation__c> getByContactAndItem(Id contactId, Id itemId) {
    return [
      SELECT
        Id,
        Contact__c,
        Inventory_Items__c,
        Status__c
      FROM Reservation__c
      WHERE Contact__c = :contactId
      AND Inventory_Items__c = :itemId
      AND Status__c = 'await rent'
    ];
  }

}
