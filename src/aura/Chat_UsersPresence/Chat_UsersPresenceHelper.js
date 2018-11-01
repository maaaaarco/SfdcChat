/**
 * Created by mzeuli on 28.10.18.
 */
({
    /**
     * Returns input element containing search text
     * @param component
     * @returns {*}
     */
    getSearchTextInput: function (component) {
        return component.find("searchInput");
    },

    /**
     * Returns aura:iteration component's body. Returned body is an array of
     * c:Chat_SingleUserPresence components
     * @param component
     * @returns {*}
     */
    getUsersPresenceComponents: function (component) {
        return component.find("usersPresence").get("v.body");
    },

    /**
     * Returns spinner component
     * @param component
     * @returns {*}
     */
    getSpinnerComponent: function (component) {
        return component.find("spinner");
    },

    /**
     * Returns button element that open/close the popover
     * @param component
     */
    getTriggerButton: function (component) {
        return component.find("triggerBtn").getElement();
    },

    /**
     * Clear usersPresence attribute by setting its value to an empty array.
     * @param component
     */
    clearUsersPresence: function (component) {
        component.set("v.usersPresence", []);
    },

    /**
     * Sets popover's top corner position according to current viewport
     * @param component
     */
    setPopoverPosition: function (component) {
        // sets popover position
        const btn = this.getTriggerButton(component);

        component.set("v.popoverTop", btn.offsetTop + btn.clientHeight + 5);
        component.set("v.popoverLeft", btn.offsetLeft);
    },

    /**
     * Returns a RegExp to test users' name according to search text. If search text
     * is not empty returns a regexp that implements a case insensitive fuzzy search,
     * otherwise one that matches everything.
     *
     * Example:
     *      if searchText = "Marco"
     *          then regexp = /M.*a.*r.*c.*o/i
     *      if searchText = ""
     *          then regexp = .*
     *
     * @param component
     */
    buildUsersPresenceFilter: function (component) {
        const searchText = component.get("v.searchText");

        return searchText ? new RegExp(searchText.split("").join(".*"), "i") : new RegExp(".*");
    },

    /**
     * Loads users presence records related to current chat room.
     * After response is received hides the spinner.
     * @param component
     */
    loadUsersPresence: function (component) {
        const action = component.get("c.getUsersPresencePerChatRoom");

        action.setParams({
            roomId: component.get("v.roomId")
        });

        action.setCallback(this, function (response) {

            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_UsersPresenceHelper.loadUsersPresence: error while loading users presence, state is:", state);
                this.fireAlert("Error while loading users, please try again in a few sec", "warning");
                return;
            }

            component.set("v.usersPresence", response.getReturnValue());

            // close spinner
            $A.util.addClass(this.getSpinnerComponent(component), "slds-hide");
        });

        $A.enqueueAction(action);
    },

    /**
     * Updates current user's presence record related to current chat room
     * @param component
     */
    updateUserPresence: function (component) {
        const action = component.get("c.updateLastTimeSeen");

        action.setParams({
            roomId: component.get("v.roomId")
        });

        action.setCallback(this, function (response) {

            const state = response.getState();

            if (state !== "SUCCESS") {
                console.log("Chat_UsersPresenceHelper.updateUserPresence: failed to update user presence, state is: ", state);
            }

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