({
	search : function(component, event, helper) {
        helper.getSearch(component);
	},
    handlePokemonView : function(component, event, helper) {
        component.set("v.pokeView", event.getParam("pokeView"));
    }
})