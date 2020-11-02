({
	getFavorites : function(component) {
        let viewState = component.get("v.accView");
        if(viewState) {
            let action = component.get("c.getFavorites");
            action.setCallback(this, function(response) {
                if(response.getState() == "SUCCESS") {
                    component.set("v.favorites", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
	},
    setAccountView : function(component, event) {
        component.set("v.accView", event.getParam("accView"));
        this.getFavorites(component);
    },
    fireEvent : function(component, event) {
        let appEvent = $A.get("e.c:ViewStateDetail");
        appEvent.setParams({"pokemon": event.getSource().get("v.value"), "favorite":true});
        appEvent.fire();
    }
})