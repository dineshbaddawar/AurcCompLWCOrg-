public class WrapperClassEx {
    
    public static List<AccountContactWrapper> getDataFromWrapper(){
        List<AccountContactWrapper> wrapList = new List<AccountContactWrapper>();
        List<Account> accList = [SELECT Id,Name,(SELECT Id,Name,Email FROM Contacts) FROM Account];
        for(Account acc : accList){
            AccountContactWrapper obj = new AccountContactWrapper();
            obj.accName= acc.Name;
            obj.conList = acc.Contacts;
            obj.contactCount = acc.Contacts.size();
            wrapList.add(obj);
            System.debug('wrapList ::'+wrapList);
        }
        return wrapList;
    }

    public class AccountContactWrapper{
        public String accName {get;set;}
        public List<Contact> conList {get;set;}
        public Integer contactCount {get;set;}
    }
}