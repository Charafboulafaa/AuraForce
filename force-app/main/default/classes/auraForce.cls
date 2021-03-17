public with sharing class auraForce {
    
    public static List<Country__c> countriesList = new List<Country__c>();

    @AuraEnabled
    public static string SummaryData(){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.covid19api.com/summary');
            req.setMethod('GET');
            HttpResponse res = http.send(req);
        
            if(res.getStatusCode() == 200){
                Object deserializedResponse = JSON.deserializeUntyped(res.getBody());
                
                Map<String, Object> respMap = (Map<String, Object>) deserializedResponse;
				List<Object> Countries = (List<Object>) respMap.get('Countries');                
				
                for(Integer i = 0; i < Countries.size(); i++){
                    Map<String, Object> resMap = (Map<String, Object>) Countries[i];
                    
                    Country__c c = new Country__c(
                    	Name = (String)resMap.get('Country'),
						CountryCode__c = (String)resMap.get('CountryCode'),
                        TotalConfirmed__c = (Integer)resMap.get('TotalConfirmed'),
                        TotalDeaths__c = (Integer)resMap.get('TotalDeaths'),
                        TotalRecovered__c = (Integer)resMap.get('TotalRecovered')
                    );
                    
                    countriesList.add(c);
                    
                }
                system.debug(countriesList);
                try {
                    if(!countriesList.isEmpty()){
                        insert countriesList;
                    }          
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
                
            }

            return null;
    }

    @AuraEnabled
    public static List<Country__c> retrieveDataUS(){
        List<Country__c> c = [SELECT ID, Name, TotalConfirmed__c, TotalDeaths__c, TotalRecovered__c FROM Country__c Where CountryCode__c = 'US' LIMIT 1];
    	return c;
    }

    @AuraEnabled
    public static List<Country__c> checkCountryData(String CountryCode){
        List<Country__c> c = [SELECT ID, Name, TotalConfirmed__c, TotalDeaths__c, TotalRecovered__c FROM Country__c Where CountryCode__c = :CountryCode LIMIT 1];
    	return c;
    } 


}