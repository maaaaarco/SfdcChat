/**
 * Created by mzeuli on 28.10.18.
 */
({
    /**
     * Load current user record
     * @param component
     */
    loadCurrentUser: function (component) {
        const action = component.get("c.getCurrentUser");

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_RoomCOntroller.doInit: error while loading user, state is:", state);
                this.fireAlert("Impossible to load current user, chat won't work", "error");
                return;
            }

            component.set("v.currentUser", response.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    fireAlert: function (message, type) {
        const evt = $A.get("e.c:AlertEvent");
        evt.setParams({
            message: message,
            alertType: type
        });
        evt.fire();
    }
})