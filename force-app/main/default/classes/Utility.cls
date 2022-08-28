public class Utility {
    
    Public Static void SendEmailWithTemplate(){
        List<Contact> conList = new List<Contact>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> recipients = new List<String>();
        
        EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name = 'Reset Password Link	'];
        recipients.add(conList[0].Email);
         mail.setToAddresses(recipients);
         mail.setSenderDisplayName('Ondonte');
    }
}