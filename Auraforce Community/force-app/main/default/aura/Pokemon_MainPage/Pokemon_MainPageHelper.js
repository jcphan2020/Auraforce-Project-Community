({
	setAccountView : function(component, event) {
        let appEvent = $A.get("e.c:ViewStateList");
        appEvent.setParams({"accView":true, "pokeView":false, "detailView": false, "caseView": false});
        appEvent.fire();
    },
    setPokemonView : function(component, event) {
        let appEvent = $A.get("e.c:ViewStateList");
        appEvent.setParams({"accView":false, "pokeView":true, "detailView": false, "caseView": false});
        appEvent.fire();
    },
    setCaseView : function(component, event) {
        let appEvent = $A.get("e.c:ViewStateList");
        appEvent.setParams({"accView":false, "pokeView":false, "detailView": false, "caseView": true});
        appEvent.fire();
    }
})