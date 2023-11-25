public with sharing class InventoryItemBO {

  public static void watcherAvailability(List<Inventory_Items__c> inventories) {
    List<Reservation__c> updateReservations = new List<Reservation__c>();

    for(Inventory_Items__c item: inventories) {
      Reservation__c reservation = handleDisponibilityItem(item);
      if (reservation != null) {
        updateReservations.add(reservation);
      }
    }

    update updateReservations;
  }

  public static Reservation__c handleDisponibilityItem(Inventory_Items__c item) {
    Reservation__c reservationToUpdate;

    if(item.Status__c == 'Available') {

      List<Reservation__c> reservations = ReservationDAO.getByInventoryId(item.Inventory__c);

      if(reservations.size() > 0) {
        reservationToUpdate = reservations.get(0);

        reservationToUpdate.Inventory_Items__c = item.Id;
        reservationToUpdate.Status__c = 'await rent';
        reservationToUpdate.Initial_Reserva__c = System.today();

        Contact contact = ContactDAO.getByIds(new Set<Id>{reservationToUpdate.Contact__c})[0];

        Inventory__c inventory = InventoryDAO.getByIds(new Set<Id>{reservationToUpdate.Inventory__c})[0];

        Email email =  new Email();
        email.updateReservation(contact.Name, contact.Email, inventory.Name);

        item.Status__c = 'Reserved';
      }
    }

    return reservationToUpdate;
  }
}
