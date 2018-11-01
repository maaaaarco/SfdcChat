/**
 * Created by mzeuli on 29.10.18.
 */
({
    /**
     * Show or hide component's content.
     * @param component
     * @param event
     * @param helper
     */
    showOrHide: function(component, event, helper) {
        const args = event.getParam("arguments");
        const el = component.find("presenceContainer");

        if (args.show) {
            $A.util.removeClass(el, "slds-hide");
        } else {
            $A.util.addClass(el, "slds-hide");
        }
    },

    /**
     * Returns user's name related to current Chat_User_Presence__c record
     * @param component
     * @param event
     * @param helper
     * @returns {string}
     */
    getUserName: function (component, event, helper) {
        return component.get("v.userPresence").CreatedBy.Name;
    }
})