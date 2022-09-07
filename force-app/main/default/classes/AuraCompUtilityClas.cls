public class AuraCompUtilityClas {
    
    
    // Dependent PickList Controller
    
    @AuraEnabled
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName){
        String controllingField = contrfieldApiName.toLowerCase();
        System.debug('controllingField Value--------:'+controllingField);
        String dependentField = depfieldApiName.toLowerCase();
        System.debug('dependentField Value--------:'+dependentField);
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    // ================================================================================================================================
    
    //  add Sorting in Lightning Data Table
    @AuraEnabled
    public static list<Account> getAccountList(){
        List<Account> accList= [Select Id, Name, Phone, CreatedDate From Account Order By CreatedDate LIMIT 10];
        if(accList != null && accList.size()>0){
            return accList;
        }
        return null;
    }
    
    
    // ================================================================================================================================
    
    // DataTable with Row Add & Delete Action in Salesforce Lightning
    @AuraEnabled
    Public Static void getAccountRecords(List<Account> accList){
        insert accList;
    }
    
    // ================================================================================================================================
    
    
    // Display Radio Buttons Group In Horizontal View in Lightning Component
    @AuraEnabled
    public Static Map<String, String> getAccRatings(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Account.Rating.getDescribe();
        System.debug('fieldResult------->'+fieldResult);
        List<Schema.PicklistEntry> listPicklistValues = fieldResult.getPicklistValues();
        System.debug('listPicklistValues------->'+listPicklistValues);
        for(Schema.PicklistEntry iterator : listPicklistValues){
            options.put(iterator.getValue(), iterator.getLabel());
        }
        return options;
    }
    
    // ================================================================================================================================
    
    
    // Inline Editing Controller 
    // Calss 1
    @AuraEnabled
    Public Static List<Opportunity> getOpportunity(){
        return [SELECT Id,Name,StageName,Amount, CloseDate FROM Opportunity LIMIT 10];
    }
    
    // Class 2
    @AuraEnabled
    public Static Boolean updateOpportunity(List<Opportunity> oppList){
        try{
            update oppList;
            return true;
        }catch(Exception e){
            System.debug('The Error--->'+e.getMessage());
            return false;
        }
    }
    
    // ================================================================================================================================
    
    
    // Lightning Accordion
    @AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> accList = new List<Account>();
        for(Account acc : [SELECT Id,Name,AccountNumber, AnnualRevenue, Description, Phone, Website FROM Account LIMIT 10]){
            accList.add(acc);
        }
        return accList;
    }
    
    // ================================================================================================================================
    
    // Multi Select Picklist Controller
    
    @AuraEnabled
    Public Static List<String> getPickListValues(){
        List<String> plValues = new List<String>();
        
        //Getting the object Type from object Name
        Schema.SObjectType objType = schema.getGlobalDescribe().get('Lead');
        System.debug('the objType--->'+objType);
        
        // Describing the object using its Object Type
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        System.debug('the objDescribe--->'+objDescribe);
        
        // Getting the Specific field information from field name. here we are using custom field Lead_Type__c
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Lead_Type__c').getDescribe();
        System.debug('the objFieldInfo--->'+objFieldInfo);
        
        // Get the picklist Field Values
        List<Schema.PicklistEntry> pickListValues = objFieldInfo.getPicklistValues();
        System.debug('the pickListValues--->'+pickListValues);
        
        // Adding picklist Value to the List
        for(Schema.PicklistEntry plv : pickListValues){
            plValues.add(plv.getValue());
            System.debug('the plValues Before Sort--->'+plValues);
        }
        plValues.sort();
        System.debug('the plValues After Sort--->'+plValues);
        return plValues;
    }
    
    // ================================================================================================================================
    
    // Controller Class for Add Delete Row Dynamically 
    
    @AuraEnabled
    Public Static void saveAccountList(List<Account> accList){
        insert accList;
    }
    
    // ================================================================================================================================
    
    // Add Multiple Child Records to Parent Object Controller
    
    @AuraEnabled 
    public static List<Contact> getContacts(){
        try{
            List<Contact> totalList = new List<Contact>();
            for(Contact con : [SELECT Id,Name,Email FROM Contact WHERE Email !=null LIMIT 10]){
                totalList.add(con);
            }
            return totalList;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() +' Erron Line '+e.getLineNumber());
        }
        return null;
    }
    
    @AuraEnabled 
    public Static void addParentAccount(String parentId, List<String> listofContactsId){
        try{
            List<Contact> listContacts = new List<Contact>();
            for(String sContactId : listofContactsId){
                Contact con = new Contact();
                con.Id = sContactId;
                con.AccountId = parentId;
                listContacts.add(con);
            }
            update listContacts;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() +' Erron Line '+e.getLineNumber());
        }
        
    }
    
    // ================================================================================================================================
    
    //  Delete Multiple Records Using Checkbox Controller
    
    @AuraEnabled
    Public Static List<Contact> fetchContact(){
        List<Contact> conList = new List<Contact>();
        List<Contact> conListToShow = [SELECT Id,FirstName,LastName,MobilePhone,Email, DepartMent FROM Contact LIMIT 10];
        for(Contact con : conListToShow){
            conList.add(con);
        }
        return conList;
    }
    
    @AuraEnabled
    public Static List<String> deleteRecords(List<String> lstRecordId){
        List<String> ErrorMsg = new List<String>();
        List<Contact> conListToDelete = [SELECT Id FROM Contact WHERE Id IN : lstRecordId];
        Database.DeleteResult[] delRes = Database.delete(conListToDelete, false);
        for(Database.DeleteResult dr : delRes){
            if(dr.isSuccess()){
                System.debug('Record Delete Successfully');
            }else{
                // Operation failed, so get all errors 
                ErrorMsg.add('');
                for(Database.Error err : dr.getErrors()){
                    ErrorMsg.add('Status code: '+err.getStatusCode()+ ' Error Message '+err.getMessage());
                }
            }
        }
        return ErrorMsg;
    }
    
    // ==================================================================================================================================
    
    @AuraEnabled(cacheable=true)
    Public Static Lead fetchLead(String recId){
        System.debug('recordId--->'+recId);
        List<String> leaEmailList =new List<String>();
        List<Lead> leadList = [SELECT Id,Email,Name,Phone FROM Lead WHERE (Email !=null OR Phone !=null)  AND Id =: recId];
        for(Lead led : leadList){
            leaEmailList.add(led.Email);
        }
        System.debug('leadList--->'+leadList);
        return leadList[0];
    }
    
    @AuraEnabled
    public Static List<Contact> getContactsByEmail(String emailId, String conPhone){
        System.debug('emailId---:'+emailId+' conPhone-----> '+conPhone);
        List<Contact> conList =   [SELECT Id,Email,Name,Phone FROM Contact WHERE (email =:emailId OR Phone =:conPhone)];
        System.debug('conList--->'+conList[0].Email);
        System.debug('conList--->'+conList);
        return conList;
    }
    
    @AuraEnabled
    Public Static List<Opportunity> getOpportunityBEmail(String emailId, String oppPhone){
        List<opportunity>  oppList = [SELECT Id,Email__c,Name,Phone__c FROM Opportunity WHERE (Email__c =:emailId OR Phone__c =:oppPhone)];
        System.debug('oppList--->'+oppList);
        return oppList;
    }
    
    @AuraEnabled 
    Public Static List<Account> getAccountByEmail(String emailId, String accPhone){
        List<Account> accList = [SELECT Id,Email__c,Name,Phone FROM Account WHERE (Email__c =:emailId OR Phone =:accPhone)];
        System.debug('accList- Method-->'+accList);
        return accList;
    }
    
    // ==================================================================================================================================
    
    // Account & their related Contacts using Aura Component
    
    @AuraEnabled
    public Static Account AccountwithRelatedContacts(String accountId){
        try{
            List<Account> accList = [SELECT Id,Name,Email__c,Phone FROM Account WHERE Id =:accountId LIMIT 1] ;
            return accList[0];
        }catch(Exception e){
            System.debug('the Error ::'+e.getMessage()+' AND the Error Line ::'+e.getLineNumber());
            return null;
        }
        
        
    }
    
    @AuraEnabled
    Public Static List<Contact> contactWithAccountId(String AccountId){
        List<Contact> conList = [SELECT Id,Email,AccountId,Phone,Name FROM Contact WHERE AccountId =: AccountId];
        return conList;
    }
    
    /* Try Catch Code
try{

}catch(Exception e){
System.debug('the Error ::'+e.getMessage()+' AND the Error Line ::'+e.getLineNumber());
}

*/
    
    // ==================================================================================================================================
    
    // Delete Multiple Records Using Checkbox Controller
    
    
    @AuraEnabled
    public static List<Lead> featchLeadData() {
        //Returning list of leads.
        return [SELECT Id, Name,Company,Status,Phone,Email FROM Lead LIMIT 10];
    }
    
    @AuraEnabled
    public static void DeleteRecord(List<Lead> DeleteIds) {
        List<Lead> delacccon = new List<Lead>();
        for(Lead con : [SELECT Id, Name,Company,Status,Phone,Email FROM Lead WHERE Id IN : DeleteIds]){
            delacccon.add(con);
        }
        
        if(delacccon.size() > 0){
            Delete  delacccon;
        }
        
    }
    
    // =================================================================================================================
    
    // Controller Class For Custom File Upload Using Aura Components
    
    @AuraEnabled
    public static Id SaveFile(Id parentId, String fileName, String base64Data, String contentType) {
        System.debug('parentId ::'+parentId);
        System.debug('fileName ::'+fileName);
        System.debug('base64Data ::'+base64Data);
        System.debug('ContentType ::'+fileName);
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment attach = new Attachment();
            attach.parentId = parentId;
            attach.Body = EncodingUtil.base64Decode(base64Data);
            attach.Name = fileName;
            attach.ContentType = contentType;
            Insert attach;
            System.debug('the Attach In LWC File ::'+attach);
            return attach.Id;
        }catch(Exception e){
            System.debug('the Error ::'+e.getMessage()+' AND the Error Line ::'+e.getLineNumber());
            return null;
        }
    }
    
     // =================================================================================================================
    
    // Iterate map values in Salesforce Lightning component
    @AuraEnabled
    public static Map<String, String> FetchMapValues(){
        Map<String, String> Map1 = new Map<String, String>();
        Map1.put('IND','Virat Kohali');
        Map1.put('END','Ben Stokes');
        Map1.put('NZ','Kane Williamson');
        Map1.put('AUS','Aaron Finch');
        Map1.put('SA','Dean Elagar');
        return Map1;
    }
    
}