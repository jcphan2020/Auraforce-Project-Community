({
	setSuccessMessage : function(component, event) {
        component.set("v.showMessage", true);
		component.set("v.message", "Case Successfully Submitted!");
	},
    setView : function(component, event) {
        let viewState = event.getParam("caseView");
        component.set("v.caseView", viewState);
        if(viewState) {
            component.set("v.showMessage", false);
            let form = component.find("caseForm");
            form.set("v.recordId", null);
        }
    }
})