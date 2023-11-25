public with sharing class RentBO {
  public static void validateCloseDate(List<Rent__c> rents) {

    for(Rent__C rent: rents) {
      if(rent.Close_Date__c <= System.today()) {
        rent.addError('A data de entrega não pode ser menor ou igual a data de hoje, por obséquio escolha outra data!');
      }
    }
  }

  public static void validateStatusItem(List<Rent__c> rents) {
    Set<Id> itemsIds = new Set<Id>();

    List<Reservation__c> updateReservations = new List<Reservation__c>();

    for(Rent__c rent: rents) {
      itemsIds.add(rent.Inventory_Items__c);
      
      Reservation__c reservation = handleReservation(rent);

      if (reservation != null) {
        updateReservations.add(reservation);
      }
    }

    if(updateReservations.size() > 0) {
      update updateReservations;

      updateItemToRented(rents);
      return;
    }

    Map<Id, Inventory_Items__c> mapInventoryItem = new Map<Id, Inventory_Items__c>(InventoryItemsDAO.getByIds(itemsIds));

    for(Rent__C rent: rents) {
      if(mapInventoryItem.get(rent.Inventory_Items__c).Status__c == 'Rented') {
        rent.addError('Este item está alugado, escolha outro ou faça uma reserva!');
      } else if(mapInventoryItem.get(rent.Inventory_Items__c).Status__c == 'Reserved') {
        rent.addError('Este item está reservado! Aguarde ou escolha outro!');
      }
    }
  }

  public static Reservation__c handleReservation(Rent__c rent) {
    Reservation__c reservationToUpdate;

    List<Reservation__c> reservations = ReservationDAO.getByContactAndItem(rent.Contact__c, rent.Inventory_Items__c);

    if(reservations.size() > 0) {
      reservationToUpdate = reservations.get(0);

      reservationToUpdate.Status__c = 'completed';
    }


    return reservationToUpdate;
  }

  public static void validateStatusContact(List<Rent__c> rents) {
    Set<Id> itemsIds = new Set<Id>();

    for(Rent__c rent: rents) {
      itemsIds.add(rent.Contact__c);
    }

    Map<Id, Contact> contactsMap = new Map<Id, Contact>(ContactDAO.getByIds(itemsIds));

    for(Rent__c rent : rents)  {
      if(contactsMap.get(rent.Contact__c).contact_status__c == 'Defaulting') {
        rent.addError('Este contato não alugar este item pois está inadimplente!');
      }
    }
  }

  public static void setCurrentDateOnlocation(List<Rent__c> rents){
    for(Rent__c rent:rents){
      rent.Location_Date__c = System.today();
    }
  }

  public static void updateItemToRented(List<Rent__c> rents){
    Set<Id> itemIds = new Set<Id>();

    for(Rent__c cur: rents) {
      itemIds.add(cur.Inventory_Items__c);
    }

    List<Inventory_Items__c> inventories = InventoryItemsDAO.getByIds(itemIds);
    Map<Id, Inventory_Items__c> inventoryItemMap = new Map<Id, Inventory_Items__c>(inventories);

    for(Rent__c rent: rents) {
      inventoryItemMap.get(rent.Inventory_Items__c).Status__c = 'Rented';
    }

    update inventories;
  }

  public static void updateStatusItem(List<Rent__c> rents){
    Set<Id> itemIds = new Set<Id>();

    for(Rent__c rent: rents) {
      itemIds.add(rent.Inventory_Items__c);
    }

    List<Inventory_Items__c> inventories = InventoryItemsDAO.getByIds(itemIds);

    Map<Id, Inventory_Items__c> inventoryItemMap = new Map<Id, Inventory_Items__c>(inventories);

    for(Rent__c rent : rents) {
      if(rent.Location_Finished__c) {
        inventoryItemMap.get(rent.Inventory_Items__c).Status__c = 'Available';
      }
    }

    update inventories;
  }

  public static void updateStatusContact(List<Rent__c> rents){
    Set<Id> itemIds = new Set<Id>();

    for(Rent__c rent: rents) {
      itemIds.add(rent.Contact__c);
    }

    List<Contact> contacts = ContactDAO.getByIds(itemIds);

    Map<Id, Contact> contactsMap = new Map<Id, Contact>(contacts);

    for(Rent__c rent : rents) {
      
      if(rent.Location_Status__c == 'Late') {
        contactsMap.get(rent.Contact__c).contact_status__c = 'Defaulting';
      } else if(rent.Location_Status__c == 'In Progress') {
        contactsMap.get(rent.Contact__c).contact_status__c = 'Normal';
      }
    }

    update contacts;
  }

  
}