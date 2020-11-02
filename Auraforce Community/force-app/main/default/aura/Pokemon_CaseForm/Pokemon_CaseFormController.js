({
	handleView : function(component, event, helper) {
        helper.setView(component, event);
	},
    handleSuccess : function(component, event, helper) {
        helper.setSuccessMessage(component, event);
    }
})