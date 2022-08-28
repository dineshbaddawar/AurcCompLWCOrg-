public class MetadatEx {

    public Static void InsertMetaData(){
        Custom_Setting__c var = new Custom_Setting__c();
      var.Name1__c='dinesh';
        insert var;
        System.debug('var-----------'+var);
    }
}