public class TagAccountToCaseBeforeInsertHelper {
//  Tagining Account on the Basis of CaseType before inserting Case Record.
    public Static void tagAccountToCase(List<Case> caseToInsert){
        List<Account> accList = [SELECT Id,Name FROM Account];
        Map<String, Account> accMap = new Map<String,Account>();
        for(Account acc : accList){
            accMap.put(acc.Name, acc);
        }
        if(!caseToInsert.isEmpty()){
            for(Case cas : caseToInsert){
                cas.AccountId = accMap.get(cas.Type).Id;
            }
        }
    }
    
    // Tagining Entitlement Process to Case on the Base of Account Record.
    public Static void TagEntitlementProcessToCaseBeforeInsert(List<Case> caseToInsert){
        List<Id> accIds = new List<Id>();
        for(Case caseNew : caseToInsert){
            if(caseNew.AccountId !=null){
                  accIds.add(caseNew.AccountId);
            }
        }
        
        List<Entitlement> EntList = [SELECT e.Id, e.AccountId, e.AssetId FROM Entitlement e WHERE e.AccountId IN : accIds];
        if(!EntList.isEmpty()){
            for(Case cas : caseToInsert){
                if(cas.EntitlementId == null && cas.AccountId !=null){
                    for(Entitlement  Ent : EntList){
                        if(Ent.AccountId  == cas.AccountId){
                        cas.EntitlementId = Ent.Id;
                        }
                    }
                }
            }
        }
        
    }
}