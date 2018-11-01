/**
 * Created by mzeuli on 01.11.18.
 */
({
    setAlert: function (component, event, helper) {
        const message = event.getParam("message");
        const type = event.getParam("alertType");

        // checks type is a valid one
        if (/error|warning|info/i.test(type)) {
            component.set("v.message", message);
            component.set("v.alertType", type);
            component.set("v.showAlert", true);
        }
    },

    close: function (component, event, helper) {
        component.set("v.showAlert", false);
    }
})