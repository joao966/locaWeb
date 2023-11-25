public with sharing class Email {
  public void goReservation(String contactName, String contactEmail, String inventoryName) {
    String emailBody = 'Olá, ' + contactName + '\n\n' +
                      'O ' + inventoryName + ' foi reservado com sucesso!\n\n' +
                      'Muito em breve o filme estará disponivel. Não se preocupe pois avisaremos você!';

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

    email.setToAddresses(new List<String>{contactEmail});
    email.setSubject('Reserva - ' + inventoryName);
    email.setPlainTextBody(emailBody);

    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
  }

  public void updateReservation(String contactName, String contactEmail, String inventoryName) {
    String emailBody = 'Olá, ' + contactName + '\n\n' +
                      'Seu filme ' + inventoryName + ' chegou! Você tem 24 horas para retirá-lo. \n\n' +
                      'Caso você não possa retirar o filme dentro de 24 horas, a reserva será cancelada automaticamente.';

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

    email.setToAddresses(new String[]{contactEmail});
    email.setSubject('Reserva - ' + ' - ' + inventoryName);
    email.setPlainTextBody(emailBody);

    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
  }
}