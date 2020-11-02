/* Designer Johnson Phan
 * Created for the purpose of calling external API GET functions from pokeapi
 */
public with sharing class PokemonGoCallout {
    // Callouts
    @AuraEnabled
    public static List<Pokemon__c> getPokemons(Integer page, Integer limiter) {
        System.debug('Getting Pokemons');
        // Initialize variables
        List<Pokemon__c> nameList = new List<Pokemon__c>();
        
        // API function
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        
        // Attempt to grab the list of Pokemon data
        for(Integer i = ((page - 1) * limiter) + 1; i <= (page * limiter); i++) {
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + i);
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200) {
                Pokemon__c newResult = new Pokemon__c();
                Map<String, Object> respMap2 = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                newResult.Name = (String) respMap2.get('name');
                Map<String, Object> sprites = (Map<String, Object>) respMap2.get('sprites');
                Map<String, Object> other = (Map<String, Object>) sprites.get('other');
                Map<String, Object> artwork = (Map<String, Object>) other.get('official-artwork');
                Map<String, Object> species = (Map<String, Object>) respMap2.get('species');
                newResult.Species__c = (String) species.get('name');
                newResult.SpriteURL__c = (String) artwork.get('front_default');
                if(newResult.SpriteURL__c == null) {
                    newResult.SpriteURL__c = (String) sprites.get('front_default');
                }
                nameList.add(newResult);
            }
        }
        
        // Return result
        return nameList;
    }
    
    @AuraEnabled
    public static Pokemon__c searchPokemon(String pokeName) {
        System.debug('Getting Searched Pokemons');
        // Initalize variables
        Pokemon__c newResult = new Pokemon__c();
        if(pokeName == null || String.isEmpty(pokeName)) {
            return newResult;
        }
        
        // API function
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokeName);
        request.setMethod('GET');
        HttpResponse response = Http.send(request);
        
        // Grab Name, Height, Weight, Sprite, and Exp based on response information
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            newResult.Base_Experience__c = (Decimal) respMap.get('base_experience');
            newResult.Height__c = (Decimal) respMap.get('height');
            newResult.Name = (String) respMap.get('name');
            Map<String, Object> sprites = (Map<String, Object>) respMap.get('sprites');
            Map<String, Object> other = (Map<String, Object>) sprites.get('other');
            Map<String, Object> artwork = (Map<String, Object>) other.get('official-artwork');
            Map<String, Object> species = (Map<String, Object>) respMap.get('species');
            newResult.Species__c = (String) species.get('name');
            newResult.SpriteURL__c = (String) artwork.get('front_default');
            if(newResult.SpriteURL__c == null) {
                newResult.SpriteURL__c = (String) sprites.get('front_default');
            }
            newResult.Weight__c = (Decimal) respMap.get('weight');
        }
        return newResult;
    }
    
    @AuraEnabled
    public static List<String> getPokemonMoves(String pokeName) {
        // Initalize variables
        List<String> moveList = new List<String>();
        if(pokeName == null || String.isEmpty(pokeName)) {
            return moveList;
        }
        
        // API function
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokeName);
        request.setMethod('GET');
        HttpResponse response = Http.send(request);
        
        // Retrieve the moves
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> moves = (List<Object>) respMap.get('moves');
            Integer i = 0;
            while(i < moves.size()) {
                Map<String, Object> index = (Map<String, Object>) moves[i];
                Map<String, Object> move = (Map<String, Object>) index.get('move');
                moveList.add((String) move.get('name'));
                i++;
            }
        }
        return moveList;
    }
    
    @AuraEnabled
    public static List<String> getPokemonAbilities(String PokeName) {
        // Initialize variables
        List<String> abiList = new List<String>();
        if(pokeName == null || String.isEmpty(pokeName)) {
            return abiList;
        }
        
        //API function
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokeName);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Retrieve the abilities
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> abilities = (List<Object>) respMap.get('abilities');
            Integer i = 0;
            while(i < abilities.size()) {
                Map<String, Object> index = (Map<String, Object>) abilities[i];
                Map<String, Object> ability = (Map<String, Object>) index.get('ability');
                abiList.add((String) ability.get('name'));
                i++;
            }
        }
        return abiList;
    }
    
    @AuraEnabled
    public static List<String> getMoveDetail(String move) {
        List<String> detail = new List<String>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/move/' + move);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());            
            String setD = String.valueOf(respMap.get('accuracy'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            Map<String, Object> tmp = (Map<String, Object>) respMap.get('damage_class');
            setD = String.valueOf(tmp.get('name'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            setD = String.valueOf(respMap.get('effect_chance'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            List<Object> tmp3 = (List<Object>) respMap.get('effect_entries');
            Map<String, Object> tmp2 = (Map<String, Object>) tmp3[0];
            String rep = (String.valueOf(tmp2.get('effect'))).replace('\n',' ');
            setD = rep.replace('  ', ' ');
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            tmp = (Map<String, Object>) respMap.get('meta');
            tmp2 = (Map<String, Object>) tmp.get('ailment');
            setD = String.valueOf(tmp2.get('name'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            tmp2 = (Map<String, Object>) tmp.get('category');
            setD = String.valueOf(tmp2.get('name'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            setD = String.valueOf(respMap.get('power'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            setD = String.valueOf(respMap.get('pp'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
            tmp = (Map<String, Object>) respMap.get('target');
            setD = String.valueOf(tmp.get('name'));
            if(setD == null) {detail.add('null');} else {detail.add(setD);}
        }
        return detail;
    }
    
    @AuraEnabled
    public Static String getAbilityDetail(String ability) {        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/ability/' + ability);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> tmp = (List<Object>) respMap.get('effect_entries');
            for(Integer i = 0; i < tmp.size(); i++) {
                Map<String, Object> tmp2 = (Map<String, Object>) tmp[i];
                Map<String, Object> tmp3 = (Map<String, Object>) tmp2.get('language');
                if(String.valueOf(tmp3.get('name')).contains('en')) {
                    String rep = (String.valueOf(tmp2.get('effect'))).replace('\n',' ');
                    return rep.replace('  ', ' ');
                }
            }
        }
        
        return 'null';
    }
    
    @AuraEnabled
    public static List<String> getSpecies(Integer page) {
        // Initialize variables
        Integer pageLimit = 20;
        List<String> specList = new List<String>();
        // You cannot have Page 0 or greater than 1050/pagelimit.
        if(page < 1 && 52 < (1050/pageLimit)) {
            return specList;
        }
        
        //API function
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon-species?offset=' + ((page - 1) * pageLimit) + '&limit=' + pageLimit);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Retrieve list of species
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> resultMap = (List<Object>) respMap.get('results');
            for(Object a : resultMap) {
                Map<String, Object> naming = (Map<String, Object>) a;
                specList.add((String) naming.get('name'));
            }
        }
        return specList;
    }
    
    @AuraEnabled
    public static List<Pokemon__c> searchSpecies(String species) {
        // Initialize variables
        List<Pokemon__c> pokeList = new List<Pokemon__c>();
        if(species == null || String.isEmpty(species)) {
            return pokeList;
        }
        
        //API function
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon-species/' + species);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        //Retrieve list of pokemons as this species
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> varieties = (List<Object>) respMap.get('varieties');
            Integer i = 0;
            while(i < varieties.size()) {
                Map<String, Object> variety = (Map<String, Object>) varieties[i];
                Map<String, Object> pokemon = (Map<String, Object>) variety.get('pokemon');                
                String pokeName = (String) pokemon.get('name');
                
                request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokeName);
                response = http.send(request);
                if(response.getStatusCode() == 200) {
                    Pokemon__c newResult = new Pokemon__c();
                    Map<String, Object> respMap2 = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    newResult.Name = pokeName;
                    Map<String, Object> sprites = (Map<String, Object>) respMap2.get('sprites');
                    Map<String, Object> other = (Map<String, Object>) sprites.get('other');
                    Map<String, Object> artwork = (Map<String, Object>) other.get('official-artwork');
                    Map<String, Object> spec = (Map<String, Object>) respMap2.get('species');
                    newResult.Species__c = (String) spec.get('name');
                    newResult.SpriteURL__c = (String) artwork.get('front_default');
                    if(newResult.SpriteURL__c == null) {
                        newResult.SpriteURL__c = (String) sprites.get('front_default');
                    }
                    pokeList.add(newResult);
                }
                i++;
            }
        }
        
        return pokeList;
    }
    
    @AuraEnabled
    public static Integer getTotalPokemonsPages(Integer limiter) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> respMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Integer totalCount = (Integer) respMap.get('count');
            return (Integer) totalCount/limiter;
        }
        
        return -1;
    }
    
    // User Data
    @AuraEnabled
    public static User getUser() {
        return [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
    }
    @AuraEnabled
    public static List<Pokemon__c> getFavorites() {
        return [SELECT Id, Name FROM Pokemon__c WHERE ownerId=:userInfo.getUserId()];
    }
    @AuraEnabled
    public static Pokemon__c getSelFavorite(String pokeName) {
        return [SELECT Id, Name, Base_Experience__c, Height__c, Species__c, SpriteURL__c, Weight__c FROM Pokemon__c WHERE ownerId=:userInfo.getUserId() AND Name=:pokeName];
    }
    @AuraEnabled
    public static Pokemon__c addFavorite(Pokemon__c poke) {
        Database.upsert(poke);
        return poke;
    }
    @AuraEnabled
    public static Pokemon__c deleteFavorite(Pokemon__c poke) {
        Pokemon__c pokemon = [SELECT Id FROM Pokemon__c WHERE Name=:poke.Name LIMIT 1];
        Database.delete(pokemon.Id);
        return poke;
    }
}