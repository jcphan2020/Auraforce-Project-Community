({
	setDetailView : function(component, event, helper) {
        helper.setEventRecord(component, event);
        helper.getAbilities(component, event);
        helper.getMoves(component, event);
	},
    handleDetailView : function(component, event, helper) {
        component.set("v.detailView", event.getParam("detailView"));
    },
    findMoveDetail : function(component, event, helper) {
        helper.getMoveDetail(component, event);
    },
    findAbilityDetail : function(component, event, helper) {
        helper.getAbilityDetail(component, event);
    },
    setFavorite : function(component, event, helper) {
        helper.setFav(component, event);
    }
})