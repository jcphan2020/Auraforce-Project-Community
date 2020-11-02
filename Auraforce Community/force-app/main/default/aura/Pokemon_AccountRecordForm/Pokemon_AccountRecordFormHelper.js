({
	getUser : function(component) {
        let action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.user", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    updateUser : function(component) {
        component.set("v.updateMessage", "Update Successful");
    },
    setAccountView : function(component, event) {
        component.set("v.accView", event.getParam("accView"));
    }
})