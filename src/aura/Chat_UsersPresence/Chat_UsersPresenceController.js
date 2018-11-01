/**
 * Created by mzeuli on 28.10.18.
 */
({
    doInit: function (component, event, helper) {
        // immediately updates current user's presence
        helper.updateUserPresence(component);

        // schedules user presence refresh
        const intervalId = window.setInterval($A.getCallback(function() {
            helper.updateUserPresence(component);
        }), 5000);

        // stores the interval id
        component.set("v.intervalId", intervalId);
    },

    doDestroy: function(component, event, helper) {
        const interval = component.get("v.intervalId");
        if (interval) window.clearInterval(interval);
    },

    setSearchText: function(component, event, helper) {
        component.set("v.searchText", event.target.value);
    },

    /**
     * Called when render event is captured, checks if popover is open. If so then
     * forces focus of search text input element
     * @param component
     * @param event
     * @param helper
     */
    doRender: function(component, event, helper) {
        const search = helper.getSearchTextInput(component);

        if (search) {
            search.getElement().focus();
        }
    },

    /**
     * Called when user starts typing in search text input element, filters users presence
     * entries
     * @param component
     * @param event
     * @param helper
     */
    filterUsers: function (component, event, helper) {

        if (component.get("v.filterUsersTimeoutId")) {
            // filter was already scheduled less than 150ms ago, do nothing
            return;
        }

        // schedules filter
        const timeoutId = window.setTimeout($A.getCallback(function() {

            // gets all users presence items
            let usersPresence = helper.getUsersPresenceComponents(component);

            // build regexp to test users name.
            let filter = helper.buildUsersPresenceFilter(component);

            for (let i = 0; i < usersPresence.length; i++) {
                let up = usersPresence[i];
                up.showOrHide(filter.test(up.getUserName()));
            }

            // reset timeout id
            component.set("v.filterUsersTimeoutId", null);
        }), 150);

        // saves timeout id
        component.set("v.filterUsersTimeoutId", timeoutId);
    },

    /**
     * Called when user press on popover's trigger button or search input
     * loose focus, toggle the popover that displays users presence
     * @param component
     * @param event
     * @param helper
     */
    togglePopover: function (component, event, helper) {

        if (component.get("v.togglePopoverTimeoutId")) {
            // toggle was already scheduled less than 80ms ago, do nothing
            return;
        }

        // schedule new toggle
        const timeoutId = window.setTimeout($A.getCallback(function() {
            const openPopover = !component.get("v.isPopoverOpen");

            if (openPopover) {
                helper.loadUsersPresence(component);
                helper.setPopoverPosition(component);
            } else {
                helper.clearUsersPresence(component);
            }

            component.set("v.isPopoverOpen", openPopover);

            // reset timeout id
            component.set("v.togglePopoverTimeoutId", null);
        }), 80);

        // saves timeout id
        component.set("v.togglePopoverTimeoutId", timeoutId);
    },
})