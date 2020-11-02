({
	init : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'}
        ]);
		helper.getFavorites(component);
	},
    handleAccountView : function(component, event, helper) {
        helper.setAccountView(component, event);
    },
    fireViewEvent : function(component, event, helper) {
        helper.fireEvent(component, event);
    }
})