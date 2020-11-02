({
	doInit : function(component, event, helper) {
		helper.getUser(component);
	},
    displayChange : function(component, event, helper) {
        let display = component.get('v.display');
        component.set('v.display', !display);
        component.set("v.updateMessage", null);
    },
    sendMessage : function(component, event, helper) {
        helper.updateUser(component);
    },
    handleAccountView : function(component, event, helper) {
        helper.setAccountView(component, event);
    }
})