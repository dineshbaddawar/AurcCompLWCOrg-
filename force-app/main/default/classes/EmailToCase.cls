public class EmailToCase {

    public Static void EmailToCase(){
      List<Account> accList = [SELECT Id,Name FROM Account WHERE Name !=null];
        Map<Id, String> accMap = new Map<Id,String>();
        List<Case> caseList = new List<Case>();
        for(Case ca : caseList){
            if(accMap.containsKey(ca.AccountId)){
                
            }
        }
    }
}