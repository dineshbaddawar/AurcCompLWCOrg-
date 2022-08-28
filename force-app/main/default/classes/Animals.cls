public class Animals {
    
    @AuraEnabled
    public static String fetchAnimals(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // Provide the Named Credentials
        request.setEndpoint('callout:AnimalCreds');
        request.setMethod('GET');        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            return response.getBody();
        }
	return null;
    }
}