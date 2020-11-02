({
	setEventRecord : function(component, event) {
        component.set("v.detailView", true);
        component.set("v.isLoading", true);
        let pokemon = event.getParam("pokemon");
        let isFav = event.getParam("favorite");
        component.set("v.isFavorite", isFav);
        let action = component.get("c.searchPokemon");
        if(isFav) {
            action = component.get("c.getSelFavorite");
        }
        action.setParams({"pokeName" : pokemon["Name"]});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                component.set("v.isLoading", false);
                component.set("v.pokemon", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
        let appEvent = $A.get("e.c:ViewStateList");
        appEvent.setParams({"accView":false, "pokeView":false, "detailView": true, "caseView": false});
        appEvent.fire();
	},
    
    getAbilities : function(component, event) {
        let pokemon = event.getParam("pokemon");
        let action = component.get("c.getPokemonAbilities");
        action.setParams({"PokeName" : pokemon["Name"]});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                component.set("v.abilities", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getMoves : function(component, event) {
        let pokemon = event.getParam("pokemon");
        let action = component.get("c.getPokemonMoves");
        action.setParams({"pokeName" : pokemon["Name"]});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                this.setButtonFav(component, event);
                component.set("v.moves", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getMoveDetail : function(component, event) {
        component.set("v.MoveOrAbility", true);
        let move = event.getSource().get("v.value");
        let action = component.get("c.getMoveDetail");
        action.setParams({"move" : move});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                component.set("v.moveDetail", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getAbilityDetail : function(component, event) {
        component.set("v.MoveOrAbility", false);
        let ability = event.getSource().get("v.value");
        let action = component.get("c.getAbilityDetail");
        action.setParams({"ability" : ability});
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                component.set("v.abilityDetail", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    setFav : function(component, event) {
        let isFav = component.get("v.isFavorite");
        let pokemon = component.get("v.pokemon");
        if(isFav) {
            let action = component.get("c.deleteFavorite");
            action.setParams({"poke" : pokemon});
            action.setCallback(this, function(response) {
                if(response.getState() == "SUCCESS") {
                    component.set("v.isFavorite", false);
                    this.setButtonFav(component);
                }
            });
            $A.enqueueAction(action);
        } else {
            let action = component.get("c.addFavorite");
            action.setParams({"poke" : pokemon});
            action.setCallback(this, function(response) {
                if(response.getState() == "SUCCESS") {
                    component.set("v.isFavorite", true);
                    this.setButtonFav(component);
                }
            });
            $A.enqueueAction(action);
        }
    },
    setButtonFav : function(component) {
        let button = component.find("Fav");
        let isFav = component.get("v.isFavorite");
        if(isFav) {
            button.set("v.label", "Unfavorite");
        }else {
            button.set("v.label", "Favorite");
        }
    }
})