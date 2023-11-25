public with sharing class ReservationBO {

  public static void validateStatusInventory(List<Reservation__c> reservations) {
    Set<Id> inventoryIds = new Set <Id>();

    for(Reservation__c reservation: reservations) {
      inventoryIds.add(reservation.Inventory__c);
    }

    Map<Id, Inventory__c> itemsIds = new Map<Id, Inventory__c>(InventoryDAO.getByIds(inventoryIds));

    for(Reservation__c reservation: reservations) {
      if(itemsIds.get(reservation.Inventory__c).inventory_status__c == 'Available') {
        reservation.addError('Há item deste inventory dispovivel, alugue-o!');
      }
    }
  }


  public static void validateStatusContact(List<Reservation__c> reservations) {
    Map<Id, Id> itemsIds = new Map<Id, Id>();

    for(Reservation__c reservation: reservations) {
      itemsIds.put(reservation.Contact__c, reservation.Contact__c);
    }

    List<Contact> contacts = ContactDAO.getByIds(new Set<Id>(itemsIds.values()));

    for(Reservation__c reservation : reservations)  {
      for(Contact contact: contacts) {
        if(reservation.Contact__c == contact.Id && contact.contact_status__c == 'Defaulting') {
          reservation.addError('Este contato não reservar este inventario pois está inadimplente!');
          return;
        }
      }
    }
  }

  public static void sendEmail(List<Reservation__c> reservations) {
    Map<Id, Id> contactIds = new Map<Id, Id>();
    Map<Id, Id> inventoryIds = new Map<Id, Id>();

    for(Reservation__c reservation: reservations) {
      contactIds.put(reservation.Contact__c, reservation.Contact__c);
      inventoryIds.put(reservation.Inventory__c, reservation.Inventory__c);
    }

    List<Contact> contacts = ContactDAO.getByIds(new Set<Id>(contactIds.values()));
    List<Inventory__c> inventorys = InventoryDAO.getByIds(new Set<Id>(inventoryIds.values()));

    Map<Id, Contact> toMapContact = new Map<Id, Contact>();
    Map<Id, Inventory__c> toMapInventory = new Map<Id, Inventory__c>();


    for(Contact contact: contacts) {
      toMapContact.put(contact.Id, contact);
    }

    for(Inventory__c inventory: inventorys) {
      toMapInventory.put(inventory.Id, inventory);
    }

    for(Reservation__c reservation : reservations)  {
      Contact contact = toMapContact.get(reservation.Contact__c);
      Inventory__c inventory = toMapInventory.get(reservation.Inventory__c);

      Email email =  new Email();
      email.goReservation(contact.Name, contact.Email, inventory.Name);
      reservation.Status__c = 'await item';
      reservation.Initial_Reserva__c = System.today();
    }
  }
}
