public  class UtilityClass {
     
@AuraEnabled(cacheable=true)
public static list<Account> getAccounts(String strName){
    String strNameLike = '%' +strName +'%';
    return [SELECT Name, AccountNumber FROM Account WHERE Name LIKE :strNameLike LIMIT 5];
}  

@AuraEnabled(cacheable=true)
public static list<Contact> getContacts(String strName){
    String strNameLike = '%' +strName +'%';
    return [SELECT Name, Phone FROM Contact WHERE Name LIKE :strNameLike LIMIT 5];
}   

@AuraEnabled(cacheable=true)
public static List<Opportunity> getOpportunity(String SearchKey){
    String searchText = '%' + SearchKey + '%';
    return [SELECT Id,Name,StageName FROM Opportunity WHERE Name LIKE : searchText];
}

    // Aura Component  <c:GetAccountDetails/> ------- Start Here
    @AuraEnabled
    Public Static List<Account> getAccountDeatails(){
        return [SELECT Id,Name,Phone,Site FROM Account WHERE Type !=null AND Phone !=null LIMIT 10];
    }
    
    @AuraEnabled
    Public Static Boolean insertAccount(String accName, string accPhone,String accsite){
        Account acc = new Account();
        acc.Name= accName;
        acc.Phone = accPhone;
        acc.Site = accsite;
        insert acc;
        return true;
    }
    
    @AuraEnabled
    Public Static Account getAccountByAccId(String Id){
        return [SELECt Id,Name,Phone,Site FROM Account WHERE Id =: Id ];
    }
    
    @AuraEnabled
    public Static Boolean updateAccountRecords(String accName, String accPhone, String accSite, String accID1){

            Account acc = new Account();
acc.Name = accName;
acc.Phone = accPhone;
acc.Site = accSite;
acc.Id = accID1;
update acc;        
        return true;
    }

    
    // End Here
    /*
    @AuraEnabled
    Public Static List<Contact> getContactDetails(){
        return [SELECT Id,FirstName,LastName,Name,Email,Phone FROM Contact LIMIT 10];
    }
*/
    
    @AuraEnabled
    Public Static List<Opportunity> getOppDetails(){
        return [SELECT Id,Name,StageName,CloseDate FROM Opportunity LIMIT 10];
    }
    
    Public Static void TotalCountPrice(List<Contact> conList){
        Set<Id> accId = new Set<Id>();
        for(Contact con : conList){
            accId.add(con.AccountId);
        }
        
        List<Contact> conListToQuery = [SELECT AccountId,Con_Price__c FROM Contact WHERE AccountId IN : accId];
        Map<Id, Decimal> accPriceMap = new Map<Id,Decimal>();
        for(Contact con : conListToQuery){
            if(accPriceMap.containsKey(con.AccountId)){
                Decimal totalPrice = accPriceMap.get(con.AccountId) + con.Con_Price__c;
                accPriceMap.put(con.AccountId, totalPrice);
            }else{
                accPriceMap.put(con.AccountId, con.Con_Price__c);
            }
        }
        List<Account> accLIst = new List<Account>();
        for(Id acId : accPriceMap.keySet()){
            Account acc = new Account();
            acc.Total_Con_Price__c = accPriceMap.get(acId);
            acc.Id = acId;
            accList.add(acc);
        }
        update accList;
    }
    
    // Lightning Data table 
    @AuraEnabled
    public static List<Contact> fetchContactRecords() {
      
        return [SELECT Id, Name,LastName, Phone, Email FROM Contact LIMIT 10];
    }
    
    //============================================================================================================================================================================

    // Rollup Summary for Account on Contact object

    // After Insert
    public void AfterInsert(Map<Id,Contact> newMap){
    System.debug('AfterInsert Method ::newMap:: '+newMap);
    Set<id> accIds = new Set<Id>();
    for(Contact con : newMap.values()){
        if(con.AccountId !=null){
            accIds.add(con.AccountId);
            System.debug('AfterInsert Method ::accIds:: '+accIds);
        }
    }
    if(accIds.size()>0){
    this.AfterUpdate(accIds);
    }
    }


    // After Delete
    public void AfterDelete(Map<id,Contact> oldMap){
        System.debug('AfterDelete Method ::oldMap:: '+oldMap);
        Set<Id> accIds = new Set<Id>();
        for(Contact con : oldMap.values()){
            if(con.AccountId !=null){
                accIds.add(con.AccountId);
                System.debug('AfterDelete Method ::accIds:: '+accIds);
            }
        }
        if(accIds.size()>0){
            this.AfterUpdate(accIds);
        }
    }

    // After Undelete
    public void AfterUnDelete(Map<Id,Contact> newMap){
        System.debug('AfterUnDelete Method ::newMap:: '+newMap);
        Set<Id> accIds = new Set<Id>();
        for(Contact con : newMap.values()){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
                System.debug('AfterUnDelete Method ::accIds:: '+accIds);
            }
        }
        if(accIds.size()>0){
            this.AfterUpdate(accIds);
        }
    }

    // After Update
    public void AfterUpdate(Set<Id> accountIds){
        System.debug('AfterUpdate Method ::accountIds:: '+accountIds);
        List<Account> accList = [SELECT Id,No_of_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE Id IN:accountIds];
        for(Account acc : accList){
            acc.No_of_Contacts__c = acc.Contacts.size();
        }
        if(accList.size()>0){
            update accList;
            System.debug('AfterUnDelete Method ::accList:: '+accList);
        }
    }
   
}