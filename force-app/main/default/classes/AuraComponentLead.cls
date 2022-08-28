global with sharing class AuraComponentLead {
   
    // Controller for Contact , Opportunity Based on Lead Emai OR Phone
    
    @AuraEnabled
    Public Static Lead fetchLeadData(String recId){
        System.debug('recordId--->'+recId);
        List<Lead> leadList = [SELECT Id,Email,Name,Phone FROM Lead WHERE (Email !=null OR Phone !=null)  AND Id =: recId];
        return leadList[0];
    }
    
    @AuraEnabled
    public Static List<Contact> getContactsByEmailData(String emailId, String conPhone){
        System.debug('emailId---:'+emailId+' conPhone-----> '+conPhone);
         List<Contact> conList =   [SELECT Id,Email,Name,Phone FROM Contact WHERE (email =:emailId OR Phone =:conPhone) LIMIT 10];
         System.debug('conList--->'+conList[0].Email);
         System.debug('conList--->'+conList);
        return conList;
    }
    
    @AuraEnabled
    Public Static List<Opportunity> getOpportunityBEmailData(String emailId, String oppPhone){
        List<opportunity>  oppList = [SELECT Id,Email__c,Name,Phone__c FROM Opportunity WHERE (Email__c =:emailId OR Phone__c =:oppPhone) LIMIT 10];
         System.debug('oppList--->'+oppList);
        return oppList;
    }
    
    @AuraEnabled 
    Public Static List<Account> getAccountByEmailData(String emailId, String accPhone){
        List<Account> accList = [SELECT Id,Email__c,Name,Phone FROM Account WHERE (Email__c =:emailId OR Phone =:accPhone) LIMIT 10];
        System.debug('accList- Method-->'+accList);
        return accList;
    }
    
    // Controller for Finding Contact Record based on Lead Email OR Phone on Lead Record Detail Page, alos find Contact Related Account & Fidn Opportunity based on
    // Account Record on the Lead Record Detail Page.
    
    @AuraEnabled
    public Static Contact getContactData(String contactId){
        return [SELECT Id,Name,Email,Phone FROM Contact WHERE (Email !=null OR Phone !=null) AND ID =:contactId];
    }
    
    @AuraEnabled
    public Static List<Opportunity> getOppDetails(String conEmail, String conPhone){
        List<Opportunity> oppList = [SELECT Id,Email__c,Phone__c,Name,AccountId,Account.Name FROM Opportunity WHERE (Email__c =:conEmail OR Phone__c =:conPhone)];
        return oppList;
    }
    
    @AuraEnabled
    public Static List<Account> getAccountDetails(String oppAccountId){
        List<Account> accList = [SELECT Id,Name,Phone FROM Account Where Id =:oppAccountId];
        System.debug('accList:::'+accList);
        return accList;

    }
}