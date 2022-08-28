global with sharing class AuraComponentLead {
   
    @AuraEnabled
    Public Static Lead fetchLeadData(String recId){
        System.debug('recordId--->'+recId);
        // List<String> leaEmailList =new List<String>();
        List<Lead> leadList = [SELECT Id,Email,Name,Phone FROM Lead WHERE (Email !=null OR Phone !=null)  AND Id =: recId];
        // for(Lead led : leadList){
        //     leaEmailList.add(led.Email);
        // }
        // System.debug('leadList--->'+leadList);
        return leadList[0];
    }
    
    @AuraEnabled
    public Static List<Contact> getContactsByEmailData(String emailId, String conPhone){
        System.debug('emailId---:'+emailId+' conPhone-----> '+conPhone);
         List<Contact> conList =   [SELECT Id,Email,Name,Phone FROM Contact WHERE (email =:emailId OR Phone =:conPhone)];
         System.debug('conList--->'+conList[0].Email);
         System.debug('conList--->'+conList);
        return conList;
    }
    
    @AuraEnabled
    Public Static List<Opportunity> getOpportunityBEmailData(String emailId, String oppPhone){
        List<opportunity>  oppList = [SELECT Id,Email__c,Name,Phone__c FROM Opportunity WHERE (Email__c =:emailId OR Phone__c =:oppPhone)];
         System.debug('oppList--->'+oppList);
        return oppList;
    }
    
    @AuraEnabled 
    Public Static List<Account> getAccountByEmailData(String emailId, String accPhone){
        List<Account> accList = [SELECT Id,Email__c,Name,Phone FROM Account WHERE (Email__c =:emailId OR Phone =:accPhone)];
        System.debug('accList- Method-->'+accList);
        return accList;
    }
}