@isTest
public with sharing class RentBOTest {
  @isTest
    static void testValidateCloseDate() {
        Rent__c rent = new Rent__c(Close_Date__c = System.today());
        insert rent;

        Test.startTest();
        RentBO.validateCloseDate(new List<Rent__c>{ rent });
        Test.stopTest();

        
        System.assert(rent.hasErrors(), 'A data de entrega não pode ser menor ou igual a data de hoje, por obséquio escolha outra data!');
    }

    @isTest
    static void testValidateStatusItem() {

        Inventory__c inventory = new Inventory__c(Name='Teste');
        insert inventory;
      
        
        Inventory_Items__c item = new Inventory_Items__c(Inventory__c = inventory.Id, Status__c = 'Available');
        insert item;

        Rent__c rent = new Rent__c(Inventory_Items__c = item.Id);
        insert rent;

      
        Reservation__c reservation = new Reservation__c();
        insert reservation;

        Test.startTest();
        RentBO.validateStatusItem(new List<Rent__c>{ rent });
        Test.stopTest();

 
        System.assert(rent.hasErrors(), 'Erro esperado não foi adicionado');
    }




    @isTest
    static void testHandleReservation() {
        Inventory__c inventory = new Inventory__c(Name='teste inventory');
        Contact contact = new Contact(FirstName='teste');
        Inventory_Items__c item = new Inventory_Items__c(Inventory__c = inventory.Id);
        
        Rent__c rent = new Rent__c(Contact__c = contact.Id, Inventory_Items__c = item.Id);
        insert rent;

       
        Reservation__c reservation = RentBO.handleReservation(rent);

       
        System.assertNotEquals(null, reservation);
        System.assertEquals('completed', reservation.Status__c);
        System.assertNotEquals('completed', reservation.Status__c);
    }
}