({
    getTotalPokemons : function(component) {
        let action = component.get("c.getTotalPokemonsPages");
        action.setParams({"limiter" : component.get("v.limiter")});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                component.set("v.TotalPage", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
	getPokemons : function(component, event) {
        if(component.get("v.pokeView")) {
            component.set("v.isLoading", false);
            let page = component.get("v.page");
            let limiter = component.get("v.limiter");
            let action = component.get("c.getPokemons");
            action.setParams({
                "page" : page, "limiter" : limiter
            });
            action.setCallback(this, function(response) {
                if(response.getState() == "SUCCESS") {
                    component.set("v.isLoading", true);
                    component.set("v.pokemons", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
            component.set("v.isSearch", false);
        }
	},
    getFav : function(component) {
        let action = component.get("c.getFavorites");
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                let result = [];
                let favArr = response.getReturnValue();
                let arr = component.get("v.pokemons");
                for(let i = 0; i < arr.length; i++) {
                    for(let j = 0; j < favArr.length; j++) {
                        if(arr[i]["Name"] == favArr[j]["Name"]) {
                            result.push(true);
                            break;
                        }
                    }
                    if(result.length <= i) {
                    	result.push(false);
                    }
                }
                component.set("v.isFav", result);
            }
        });
        $A.enqueueAction(action);
    },
    search : function(component, pokeName, specyName) {
        let action;
        if(specyName) {
            action = component.get("c.searchSpecies");
            action.setParams({"species" : specyName});
            action.setCallback(this, function(response) {
                if(response.getState() == "SUCCESS") {
                    component.set("v.isLoading", true);
                    if(pokeName) {
                        let result = [];
                        let arr = response.getReturnValue();
                        for(let i = 0; i < arr.length; i++) {
                            if(pokeName === (arr[i])['Name']) {
                                result.push(arr[i]);
                            }
                        }
                        component.set("v.pokemons", result);
                    }else {
                        component.set("v.pokemons", response.getReturnValue());
                    }
                }
            });
            $A.enqueueAction(action);
            component.set("v.isLoading", false);
            component.set("v.isSearch", true);
        }else if(pokeName) {
            action = component.get("c.searchPokemon");
            action.setParams({"pokeName" : pokeName});
            action.setCallback(this, function(response) {
                if(response.getState() == "SUCCESS") {
                    component.set("v.isLoading", true);
                    component.set("v.pokemons", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
            component.set("v.isLoading", false);
            component.set("v.isSearch", true);
        }else {
            component.set("v.isLoading", false);
            this.getPokemons(component);
        }
    }, 
    fireView : function(component, event) {
        let index = event.getSource().get("v.value");
        let pokemon = (component.get("v.pokemons"))[index];
        let isFav = (component.get("v.isFav"))[index];
        let appEvent = $A.get("e.c:ViewStateDetail");
        appEvent.setParams({"pokemon" : pokemon, "favorite" : isFav});
        appEvent.fire();
    }
})