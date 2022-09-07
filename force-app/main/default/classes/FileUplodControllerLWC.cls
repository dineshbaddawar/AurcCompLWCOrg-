public class FileUplodControllerLWC {
    
    @AuraEnabled(cacheable=true)
    public Static List<ContentDocumentLink> fetchFiles(String recordId){
        List<ContentDocumentLink> contDoc = [SELECT LinkedEntityId, ContentDocument.CreatedDate, ContentDocument.Title, ContentDocument.ContentSize, ContentDocument.FileType 
                                             FROM ContentDocumentLink WHERE LinkedEntityId  =:recordId]; 
        return contDoc;
    }
}