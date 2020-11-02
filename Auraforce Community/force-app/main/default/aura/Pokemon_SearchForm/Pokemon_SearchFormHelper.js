({
	getSearch : function(component) {
        let pokeName = component.get("v.pokeName");
        let specy = component.get("v.specyName");
        let newEvent = $A.get("e.c:Pokemon_SearchEvent");
        newEvent.setParams({
            "pokeName" : pokeName, "specyName" : specy
        });
        newEvent.fire();
	}
})