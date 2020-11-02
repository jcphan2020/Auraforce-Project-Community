({
	init : function(component, event, helper) {
        helper.getTotalPokemons(component);
	},
    togglePrevious : function(component, event, helper) {
        component.set("v.isNext", true);
        let page = component.get("v.page");
        if((page - 1) == 1) {
            component.set("v.isPrevious", false);
        }
        component.set("v.page", page - 1);
        helper.getPokemons(component);
    },
    toggleNext : function(component, event, helper) {
        component.set("v.isPrevious", true);
        let page = component.get("v.page");
        let totalPages = component.get("v.TotalPage");
        if((page + 1) == totalPages) {
            component.set("v.isNext", false);
        }
        component.set("v.page", page + 1);
        helper.getPokemons(component);
    },
    HandleSearchEvent : function(component, event, helper) {
        let pokeName = event.getParam("pokeName");
        let specyName = event.getParam("specyName");
        helper.search(component, pokeName, specyName);
    },
    fireViewEvent : function(component, event, helper) {
        helper.fireView(component, event);
    },
    handleAccountView : function(component, event, helper) {
        component.set("v.pokeView", event.getParam("pokeView"));
        helper.getPokemons(component);
    },
    findFav : function(component, event, helper) {
        let isTrue = event.getParam("value");
        if(isTrue) {
            helper.getFav(component);
        }
    }
})