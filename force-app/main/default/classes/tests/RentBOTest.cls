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
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://example.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id, Status__c='Available');
        insert item;
        
        Rent__c rent = new Rent__c(Inventory_Items__c=item.Id);
        insert rent;

        Test.startTest();
        RentBO.validateStatusItem(new List<Rent__c>{ rent });
        Test.stopTest();

        System.assert(rent.hasErrors(), 'Erro esperado não foi adicionado');
        
    }
    
    @isTest
    static void testHandleReservation2() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://example.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id, Status__c='Rented');
        insert item;
        
        Contact contato = new Contact(LastName='Teste', contact_status__c='Defaulting');
        insert contato;
       
        Rent__c rent = new Rent__c(Contact__c=contato.Id, Inventory_Items__c=item.Id);
        insert rent;

        Test.startTest();
        Reservation__c reservation = RentBO.handleReservation(rent);
        Test.stopTest();
    }
    
    @isTest
    static void testHandleReservation3() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://example.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id, Status__c='Reserved');
        insert item;
        
        Contact contato = new Contact(LastName='Teste', contact_status__c='Normal');
        insert contato;
       
        Rent__c rent = new Rent__c(Contact__c=contato.Id, Inventory_Items__c=item.Id);
        insert rent;

        Test.startTest();
        Reservation__c reservation = RentBO.handleReservation(rent);
        Test.stopTest();
    }
    
    
    @isTest
    static void testHandleReservation4() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://site.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id, Status__c='Available');
        insert item;
        
        Contact contato = new Contact(LastName='Teste', contact_status__c='Normal');
        insert contato;
           
        Reservation__c reserva = new Reservation__c(Contact__c=contato.Id, Inventory__c=inventory.Id);
        insert reserva;      
        
        Rent__c rent = new Rent__c(Contact__c=contato.Id, Inventory_Items__c=item.Id);
        insert rent;

        Test.startTest();
        Reservation__c reservation = RentBO.handleReservation(rent);
        Test.stopTest();
    }
    
    
    @isTest
    static void testHandleReservation5() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://site.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id);
        insert item; 
        
        Rent__c rent = new Rent__c( Inventory_Items__c=item.Id);

        item.Status__c = 'Rented';
        update item;

        Test.startTest();
        RentBO.updateItemToRented(new List<Rent__c>{ rent });
        Test.stopTest();
    }
    
    
    
    @isTest
    static void testHandleReservation6() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://site.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id);
        insert item; 
        
        Rent__c rent = new Rent__c( Inventory_Items__c=item.Id, Location_Finished__c=true);     
       
        item.Status__c = 'Available';
       	update item;
        
        Test.startTest();
        RentBO.updateStatusItem(new List<Rent__c>{ rent });
        Test.stopTest();
    }
    
    
    @isTest
    static void testHandleReservation7() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://site.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id);
        insert item;
        
        Contact contato = new Contact(LastName='Teste', contact_status__c='Normal');
        
        insert contato;
        
        Rent__c rent = new Rent__c(Contact__c=contato.Id, Inventory_Items__c=item.Id, Location_Finished__c=true);                     
        
        Test.startTest();
        RentBO.updateStatusContact(new List<Rent__c>{ rent });
        Test.stopTest();
    }
    
    
    @isTest
    static void testHandleReservation8() {
        Inventory__c inventory = new Inventory__c(Name='Teste', Synopse__c='sinopse teste', Image_URL__c='https://site.com/image.jpg');
        insert inventory;

        Inventory_Items__c item = new Inventory_Items__c(Inventory__c=inventory.Id);
        insert item;
        
        Contact contato = new Contact(LastName='Teste');      
        insert contato;
        
        Rent__c rent = new Rent__c(Contact__c=contato.Id, Inventory_Items__c=item.Id, Location_Finished__c=true);
        //rent.Location_Status__c = 'Late';
        
        contato.contact_status__c='Defaulting';
        update contato;
        
        Test.startTest();
        RentBO.updateStatusContact(new List<Rent__c>{ rent });
        Test.stopTest();
    }
    
    
   
     
    
}